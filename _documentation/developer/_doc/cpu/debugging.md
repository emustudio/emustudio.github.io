---
layout: default
title: Optional debugging ports
nav_order: 5
parent: Writing a CPU
permalink: /cpu/debugging
---

# Optional debugging ports

`CPU.getDebugger()` optionally exposes emuLib's `DebugCPU` port. The host uses it for portable register watches/edits,
conditional breakpoints, guest read/write watchpoints and instruction history. Plugins without this port retain their
existing debugger. All bundled CPU engines implement it with `DebugProbe`; third-party CPU plugins can use the same interface.

## Register access and execution hooks

Create a probe with `DebugProbe(processor, memory, disassembler)`, using the CPU's memory context (including word or typed instruction memory) and
a disassembler that reads the actual execution view without guest side effects. Bind named register descriptors
to getters/setters with `register(name, bits, getter, setter)`. Widths are 1–64 bits; edits reject values outside the unsigned
register width (64-bit values use the full `long` bit pattern). Register pairs can share bindings with their component registers. Inspection, edits and listener changes
require a paused CPU; register getters must be side-effect-free.

The probe exposes the original context through `memory()`. For byte memory, use `instrumentedMemory()` only for the CPU's execution memory reference. Word or raw-memory engines report numeric guest accesses with `access(address, bank, value, write)`;
typed instruction encodings remain text. Keep recording disassemblers on an inspection-only view such as
`DebugProbe.inspectionMemory(memory)`, and keep existing bus-cycle interfaces on the original context. Configure
`onActivityChanged` before exposing the probe to switch execution between the original and instrumented memory references.
Cache the active flag in the engine so disabled instruction dispatch only needs a boolean check.

When active, call `begin(pc)` before dispatch. A false return requests a breakpoint stop without executing the instruction.
After a successful begin, call `end(completed)` in `finally`; its return requests a stop after the instruction. Set completed
only when dispatch finishes normally. `begin` captures instruction text before execution. Nested dispatches are grouped
into their outer instruction. Interrupt adapters use `describeInterrupt` for injected operations, or `captureInstruction`
for the instruction actually dispatched at a vector, rather than attributing the interrupted PC's bytes to the interrupt.
Preserve existing cycle
accounting. Configure `onRegisterEdited` to notify existing CPU status listeners after successful edits;
`AbstractCPU.notifyInternalStateChanged()` provides that notification without a run-state change.

Probe listeners run on the execution thread. They must not call CPU lifecycle operations. Events contain immutable
before/after register snapshots, the instruction's physical bank/address, guest memory accesses and completion status.
Each event also carries a monotonic sequence number and opcode/disassembly text captured before execution. Capture
disassembly through side-effect-free inspection memory so it does not add guest access events; never reconstruct it from
later live memory. This preserves historical instructions after self-modification or bank changes. Failed decoding must
remain explicit without preventing the instruction outcome from being recorded.
Read accesses include instruction fetches; writes are attempted guest writes and do not prove that a ROM/device accepted
them. Debugger inspection through the original context produces no guest access events. Access hooks work independently of
UI memory-change notification settings. Listener registration order should not be used to coordinate separate tools.

## Bank inspection

`MemoryContext` defaults to one bank. Banked providers implement `getBanksCount`, `getSelectedBank`, `getCommonBoundary`
and `readBank(address, bank)`. Addresses below the common boundary use the selected bank; the shared region uses physical
bank zero. `getBank(address)` reports that physical bank. Inspecting a bank must not select it or advance guest bus timing.
The default `readBank` delegates to normal reads for bank zero, so providers with memory-mapped side effects need their own
inspection implementation. The Spectrum bus delegates bank inspection directly to its underlying memory.

An instruction in common ROM has physical bank zero, while its memory expressions can still read the selected logical bank.
Keep instruction-bank identity separate from expression evaluation context.

## Flow metadata and persistence

`Disassembler.getFlow(address)` optionally returns `InstructionFlow`: kind, next sequential address, conditional fall-through
and explicit direct targets. Use an empty target list for unresolved indirect jumps. Calls normally retain fall-through;
unconditional jumps, returns and stops do not. Do not derive targets by parsing mnemonic text. The bundled opcode adapter
adds 8080/Z80 flow metadata while Edigen-generated disassembly remains unchanged.

`CPU.getBreakpoints()` returns a snapshot of ordinary address breakpoints; `AbstractCPU` implements this. The default empty
snapshot preserves plugins that do not expose breakpoint enumeration. Named debugger rules, watches, user annotations,
captures, persistence and instruction recording belong to the emuStudio host. Compiler source-position annotations remain separate
from user labels/comments. True machine rewind requires coordinated device/CPU/memory checkpoints and input replay; instruction
history alone does not provide restoration.

## Recording ownership

The host consumes the same events for bounded recent history, continuous file recording and headless automation.
CPU plugins do not format or write recording files. Preserve the inactive-probe path: no instruction snapshots or
recording allocations when no listeners are attached. Sequence numbers identify execution order independently of
host timestamps and remain visible when the UI filters or folds events.

The application writes a versioned structured recording with processor/register definitions and captured event values.
Its reader uses bounded pages, so opening a long recording does not load the entire file into memory. Text export is
for inspection and comparison; structured recordings retain the information needed by History. Reopened recordings use
their captured instruction text and values rather than the current machine's memory or source annotations.

Continuous recording uses bounded buffered writes on the execution thread. This applies backpressure instead of
silently dropping events. File failures and incomplete recordings must be reported; clean closure flushes output and
writes a completion marker. Historical inspection remains read-only and does not restore machine state.

## API reference

The generated reference documents [DebugCPU]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/debug/DebugCPU.html),
[DebugProbe]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/debug/DebugProbe.html),
[InstructionFlow]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/InstructionFlow.html), and
[MemoryContext]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.html).
