---
layout: default
title: Emulator engine
nav_order: 3
parent: Writing a CPU
permalink: /cpu/engine
---

{% include analytics.html category="developer" %}

# Emulator engine

Emulator engine is the core of the emulator. It interprets binary-encoded instructions stored in a memory (emuStudio
assumes it's a von-Neumann-like CPU). Execution of one instruction involves four basic steps: fetch, decode and execute,
and store, executed in order. Those steps can overlap in the implementation.

A pseudo-algorithm for emulator engine can look as follows (using [interpretation technique][interpreter]{:target="_blank"}):

{:.code-example}

```java
public class EmulatorEngine {
    private final CPU cpu;
    private final MemoryContext<Byte> memory;

    // internal CPU registers
    private int currentInstruction;

    EmulatorEngine(MemoryContext<Byte> memory, CPU cpu) {
        this.memory = Objects.requireNonNull(memory);
        this.cpu = Objects.requireNonNull(cpu);
    }

    CPU.RunState step() {
        int instruction = memory.read(currentInstruction);
        currentInstruction = currentInstruction + 1;

        switch (instruction) {
            case 0: // ADD
                ...
                return CPU.RunState.STATE_STOPPED_BREAK;
            case 4: // JMP
                ...
                return CPU.RunState.STATE_STOPPED_BREAK;
            case 99: // HLT
                return CPU.RunState.STATE_STOPPED_NORMAL;
            default:
                return CPU.RunState.STATE_STOPPED_BAD_INSTR;
        }
    }

    CPU.RunState run() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                if (cpu.isBreakpointSet(currentInstruction)) {
                    return CPU.RunState.STATE_STOPPED_BREAK;
                }
                CPU.RunState result = step();
                if (result != CPU.RunState.STATE_STOPPED_BREAK) {
                    return result;
                }
            } catch (IndexOutOfBoundsException e) {
                return CPU.RunState.STATE_STOPPED_ADDR_FALLOUT;
            }
        }
        return CPU.RunState.STATE_STOPPED_BREAK;
    }

    ...
}
```

This is illustrative pseudocode; the instruction bodies depend on your CPU. Check breakpoints before fetching the next
instruction. Continuous execution must also respond to thread interruption so `AbstractCPU.pause()` and `stop()` can
cancel it. The engine's `run()` is called by the plugin's `call()`; the public CPU method is `execute()`.

## Data-driven opcode dispatch

The bundled Intel 8080 and Z80 engines keep opcode-to-handler mappings in `dispatch-tables.txt` resources beside their
`DispatchTables` classes. A section names the public dispatch-table field and handler signature, followed by hexadecimal
opcode and `EmulatorEngine` method pairs:

{:.code-example}
```text
[DISPATCH_TABLE] retInt
00 I_NOP
01 I_LXI
```

The loader binds those names with `MethodHandles.findVirtual` during class initialization. Blank lines and comments
beginning with `#` are ignored; a missing resource, malformed row, unknown table, or missing handler fails initialization
instead of silently assigning an opcode. Add or change bundled CPU mappings in this resource, not in a hand-written
static assignment block. This is an implementation convention for the bundled engines, not a new plugin API.

## Emulating accurate timing

Accurate timing in the emulation is sometimes necessary to achieve "intended" (real) response times: visual, audio,
or network speed of the emulated computer. 

Often times computer components work in sync together, i.e. the speed of each component is usually derived from one
crystal clock. For example, a Zilog Z80 CPU runs on 3.5MHz, and the video chip runs on 7MHz. In this case, the video
chip generates [two pixels per one CPU cycle][zxdesign]{:target="_blank"}.

Timing of computer components in emulators is usually also derived from one "clock", but there are more ways how to 
achieve target speed in the emulator. For example, video redraw speed can be derived from the number of executed CPU
cycles, and CPU speed can be derived from audio buffer size, etc.

In this section, we'll be discussing ways of how to achieve time accurate CPU emulation. When talking about target 
(emulated) CPU speed in relation to the host CPU, we can observe three cases:

1. The host CPU is faster than the emulated CPU
2. The host CPU is slower than the emulated CPU
3. The host CPU speed is equal to the emulated CPU speed

The last case is the ideal one, of course. In the second case there's not much we can do actually, except some drastic
emulation quality reduction (e.g. lowering FPS), if actually possible.

The first case is the most common one, and there are several solutions possible. We know that every instruction takes
several clock ticks (sometimes called t-states) to execute. For example, the Zilog Z80 CPU takes 4 t-states per `NOP`
instruction. Each clock tick takes constant time to execute, based on the clock frequency of the CPU. For example, the
Intel 8080 CPU has a clock frequency of 2 MHz, so every clock tick takes $1 / 2000000 = 5 \times 10^{-7} s = 0.5$ microseconds.

One way of achieving accurate timing is to execute the instructions in a loop, and measure the time spent in the loop.
If the time is less than the intended time, we can execute more instructions in the next iteration. If the time is greater,
we can execute less (or no) instructions in the next iteration. This way we can achieve accurate timing.

Computing the "intended" time is therefore based on time measurement on the host, and comparing it with emulation time
computed as the number of executed t-states multiplied by the time of one t-state. Then, if the host time is smaller
than emulated time (we're still talking about the first case above), we need to slow down the emulation actually
"doing nothing" until the host time catches up the emulated time.

The wait can use sleeping or busy waiting. `System.nanoTime()` measures elapsed time, but its resolution depends on
the host; nanosecond units do not guarantee nanosecond resolution. Sleep duration also depends on the operating system
scheduler. Execute batches of T-states and account for the time already spent, rather than sleeping after every cycle.

The general solution, which is very usual in emulators, is to setup a "time slot" (>= the time measurement accuracy)
in the beginning of the emulation. Then, in the loop we calculate target machine cycles which should be executed in the
time slot. Then we execute instructions until we achieve target machine cycles, and "do nothing" until the time slot is
over. Then we repeat the process.

Described algorithm is implemented in emuLib library in the class `AccurateFrequencyRunner`. Usage (taken from Intel 8080 emulator)
is: 

```java
public class EmulatorEngine {
    ...
    private final AccurateFrequencyRunner preciseRunner = new AccurateFrequencyRunner();

    CPU.RunState run() {
        return preciseRunner.run(
                () -> (double) context.getCPUFrequency(),
                () -> {
                    try {
                        if (cpu.isBreakpointSet(PC)) {
                            currentRunState = CPU.RunState.STATE_STOPPED_BREAK;
                        } else {
                            int cycles = dispatch(); // this will update currentRunState
                            preciseRunner.addExecutedCycles(cycles); // this is very much needed!
                            context.passedCycles(cycles);
                        }
                    } catch (IndexOutOfBoundsException e) {
                        LOGGER.error("Unexpected error", e);
                        currentRunState = CPU.RunState.STATE_STOPPED_ADDR_FALLOUT;
                    } catch (Throwable e) {
                        LOGGER.error("Unexpected error", e);
                        currentRunState = CPU.RunState.STATE_STOPPED_BAD_INSTR;
                    }
                    return currentRunState;
                }
        );
    }

    ...
}
```



[zxdesign]: http://www.zxdesign.info/cpu1.shtml
[interpreter]: https://en.wikipedia.org/wiki/Interpreter_(computing)
