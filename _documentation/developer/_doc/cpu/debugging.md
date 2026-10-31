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
existing debugger. The bundled 8080 and Z80 engines implement it with `DebugProbe`.

## Register access and execution hooks

Create a probe with the processor identifier and the CPU's original byte-memory context. Bind named register descriptors
to getters/setters with `register(name, bits, getter, setter)`. Widths are 1–32 bits; edits reject values outside the unsigned
register width. Register pairs can share bindings with their component registers. Inspection, edits and listener changes
require a paused CPU; register getters must be side-effect-free.

The probe exposes the original context through `memory()`. Use `instrumentedMemory()` only for the CPU's execution memory
reference. Keep disassemblers, inspectors and existing bus-cycle interfaces on the original context. Configure
`onActivityChanged` before exposing the probe to switch execution between the original and instrumented memory references.
Cache the active flag in the engine so disabled instruction dispatch only needs a boolean check.

When active, call `begin(pc)` before dispatch. A false return requests a breakpoint stop without executing the instruction.
After a successful begin, call `end(completed)` in `finally`; its return requests a stop after the instruction. Set completed
only when dispatch finishes normally. Nested dispatches are grouped into their outer instruction. Preserve existing cycle
accounting and dispatch listeners. Configure `onRegisterEdited` to notify existing CPU status listeners after successful edits;
`AbstractCPU.notifyInternalStateChanged()` provides that notification without a run-state change.

Probe listeners run on the execution thread. They must not call CPU lifecycle operations. Events contain immutable
before/after register snapshots, the instruction's physical bank/address, guest memory accesses and completion status.
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
captures, persistence and bounded history belong to the emuStudio host. Compiler source-position annotations remain separate
from user labels/comments. True machine rewind requires coordinated device/CPU/memory checkpoints and input replay; instruction
history alone does not provide restoration.

## API reference

The generated reference documents [DebugCPU]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/debug/DebugCPU.html),
[DebugProbe]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/debug/DebugProbe.html),
[InstructionFlow]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/InstructionFlow.html), and
[MemoryContext]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/MemoryContext.html).
