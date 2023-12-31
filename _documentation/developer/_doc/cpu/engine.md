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

A pseudo-algorithm for emulator engine can look as follows:

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

    CPU.RunState step(CPU.RunState currentRunState) {
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
        }
    }

    CPU.RunState run(CPU.RunState currentRunState) {
        while (currentRunState == CPU.RunState.STATE_STOPPED_BREAK) {
            try {
                if (cpu.isBreakpointSet(currentInstruction)) {
                    return currentRunState;
                }
                currentRunState = step();
            } catch (...){
                currentRunState = CPU.RunState.STATE_STOPPED_XXX;
                break;
            }
        }
        return currentRunState;
    }

    ...
}
```

It uses interpretation emulation technique (the simplest one). Note that breakpoints must be manually handled - after
execution of each instruction it should be checked if the current instruction hasn't a breakpoint, and if yes, return.

## Emulating accurate timing

Accurate timing in the emulation is sometimes necessary to achieve "intended" (real) response times, visual or audio
speed, or communication speed of the emulated computer.

Usually, the most significant part where the accurate timing is needed is the CPU emulation. Usually, the frequency of
other computer components is derived from the CPU frequency. For example, the CPU frequency is 2 MHz, and the frequency
of the video chip is 1 MHz. In this case, the video chip is clocked every second CPU cycle.

In real CPUs, execution of one instruction is split into several phases, called machine cycles. Every machine cycle
usually takes constant time to execute, based on the clock frequency of the CPU. For example, the Intel 8080 CPU has a
clock frequency of 2 MHz, so every machine cycle takes $1 / 2000000 = 5^{e-7} s = 0.5$ microseconds to execute.

This also says something about timing of other devices, which is usually based on CPU cycles. In the
example above, a video chip "refresh rate" is every second CPU cycle.

How to achieve accurate timing? A basic requirement is that the host CPU (the computer which runs the emulator) must
be faster than the emulated CPU. Otherwise, the emulator will not be able to emulate the emulated CPU in real-time.

In this case there is a lot of "time" available for emulator to synchronize times for achieving accurate timing. The
emulator must "slow down" the emulation, so it appears as if the instructions ran on the intended frequency.

In general, the time synchronization is usually performed after "bunch" of machine cycles executed uncontrollably. The
reason is that the time measurement/sleeping is not accurate enough to measure the time of a single machine cycle, or
even few machine cycles. For example, Z80 CPU runs on 3.5MHz and average time measurement/sleeping accuracy is 1ms.
This means that 1 machine cycle takes 0.285ms and hence it is impossible to measure it accurately.

The general solution, which is very usual in emulators, is to setup a "time slot" (>= the time measurement accuracy)
in the beginning of the emulation. Then, in the loop we calculate target machine cycles which should be executed in the
time slot. Then we execute instructions until we achieve target machine cycles, and wait (sleep) until the time slot is
over.
Then we repeat the process.

In more detail, we begin with defining the time slot and calculating how many machine cycles should be executed in the
time slot:

```java
double frequencyKHz = ...; // emulated CPU frequency
long slotNanos = SleepUtils.SLEEP_PRECISION;
double slotMicros = slotNanos / 1000.0;

int cyclesPerSlot = Math.max(1, (int) (slotMicros * frequencyKHz / 1000.0));
```

Then we would calculate target cycles we want to execute in the next slot. There are more ways how to do it, but here
the principle is to:

1. Go "ahead" of time by sleeping in advance, in the beginning for a time equals to 1 time slot.
2. Then use real sleep length to calculate target cycles.
3. Execute the instructions until we achieve target cycles.
4. Adjust the next sleeping time as the time slot minus time spent in the computation.
5. Repeat the process.

```java
long executedCycles = 0L;

CPU.RunState currentRunState = CPU.RunState.STATE_RUNNING;
long delayNanos = slotNanos; // initial delay time

long emulationStartTime = System.nanoTime();

while (!Thread.currentThread().isInterrupted() &&(currentRunState ==CPU.RunState.STATE_RUNNING)) {
    try {
        if (delayNanos > 0) {
            // We do not require precise sleep here!
            Thread.sleep(TimeUnit.NANOSECONDS.toMillis(delayNanos));
        }
    } catch(InterruptedException e) {
        Thread.currentThread().interrupt();
        break;
    }

    long computationStartTime = System.nanoTime();

    // We take into consideration real sleep time
    long targetCycles = (computationStartTime - emulationStartTime) / slotNanos * cyclesPerSlot;

    // overflow?
    if (targetCycles < 0 || executedCycles.get() < 0) {
        targetCycles = Math.abs(targetCycles %Long.MAX_VALUE);
        executedCycles = Math.abs(executedCycles %Long.MAX_VALUE);
    }

    while ((executedCycles < targetCycles) && !Thread.currentThread().isInterrupted() && (currentRunState == CPU.RunState.STATE_RUNNING)) {
        Result result = runInstruction();
        currentRunState =result.getRunState();
        executedCycles +=result.getExecutedCycles();
    }

    long computationTime = System.nanoTime() - computationStartTime;
    delayNanos =slotNanos -computationTime;
}
return currentRunState;
```

There are two time measurements in the code above. The first one is the time between the beginning of the emulation and
the beginning of the computation. This time is used to calculate target cycles. Since we're starting with the sleep,
the time is ahead, and thus we can calculate how many cycles should have been already "done" in that time.

In the first iteration, target cycles should ideally equal to `cyclesPerSlot`, if the sleep time equals precisely to
the time slot. It's because `delayNanos = slotNanos` and in case of precise time sleep we would have
`(computationStartTime - emulationStartTime) == delayNanos`. In the next iterations, it would be equal
to `2 * delayNanos`, then `3 * delayNanos`, etc. So the `targetCycles` is cumulative value and (in theory) is vulnerable
to overflow.

Thus, we need to take the overflow into consideration. The overflow will happen when the `computationStartTime` is
suddenly lower than the `emulationStartTime`. In this case, suddenly the "ahead-of-time" `targetCycles` will be
negative, and the `executedCycles < targetCycles == false` forever. Thus, no instructions will be executed
until `targetCycles` "grow" enough to be again greater than `executedCycles`. But the "growing" can cause overflow
before `executedCycles < targetCycles == true`, so potentially the emulation would stop executing instructions forever.

In other words, in the ideal case `cyclesPerSlot == (computationStartTime - emulationStartTime) / slotNanos`
if `delayNanos == slotNanos`. Since the time measurement / sleep is not precise, the target cycles will be slightly
different to compensate the inaccuracy, and also will reflect the computation time of the previous iteration. We have
executed the instructions to the previous target cycles, but we should have done it in one "host-timing" time slot, in
which case emulation/host frequencies would be in sync. Since the host is usually faster than the emulated CPU, the
instructions were performed faster than one time slot, and thus the next "delay" is going to compensate the difference.
It's like the delay compensation will be actually reflected in the next "time ahead". So it's like future compensation,
like we have assumed how long the instruction execution will take in the next time slot.

The future delay correction starts with the measuring the `computationTime`. If the host CPU executed
the instructions exactly at the emulated CPU frequency, the `computationTime` should be equal to the time slot, and
thus set `delayNanos = 0`, because we executed 2 time slots (first the sleeping, then execution), so we will not wait
the next time slot.

However, if the `computationTime` took less than a time slot, then we will compensate the difference by setting
`delayNanos = slotNanos - computationTime`. This will cause that the next time slot will be shorter, and thus,
we will make sure only one time slot was executed (split into the sleeping = slot time minus previous execution time,
then next execution).

The described algorithm is implemented in emuLib library in the class `AccurateFrequencyRunner`. Usage (taken from Intel 8080 emulator): 

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
