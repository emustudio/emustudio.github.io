---
layout: default
title: Optional machine debugging
nav_order: 5
parent: Writing a CPU
permalink: /cpu/debugging
---

# Optional machine debugging

A CPU plugin can implement `Debugging` alongside `CPU`. emuStudio owns breakpoints, watches, recording, and execution
control. The plugin supplies its machine's values, such as processor registers or symbolic tape cells.

## Debugging interface

```java
public interface Debugging {
    enum Capture { INSTRUCTION, ACCESSES, FULL }

    Expression compile(String source);
    String getExpressionsHelp();
    AutoCloseable observe(Observer observer, Capture capture);

    interface Expression {
        boolean test();
        ValueView display();
    }

    interface Observer {
        boolean beforeStep();
        boolean afterStep(boolean completed,
                          Optional<DecodedInstruction> instruction,
                          OptionalInt nextAddress,
                          Optional<StepView> capture);
        default boolean canBatchInstructions() { return false; }
        default void afterBlock(ExecutedBlock block) {
            throw new UnsupportedOperationException("Instruction batching is not supported");
        }
        default void failed(String message) {}
    }
}
```

Implement the interface directly on the plugin root and delegate to a plugin-owned adapter. `DebuggingSupport` can
share observer mechanics, and `ExpressionParser` can share expression syntax with plugin-defined name/function resolvers.
Resolve names during compilation without reading guest state; evaluation and display happen at the execution seam.

Return plain text from [`getExpressionsHelp()`]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugin/debugger/Debugging.html#getExpressionsHelp%28%29)
covering the syntax, names, and functions that `compile()` accepts.
emuStudio shows this reference in the Watches panel. Plugins using the shared parser can include
`ExpressionParser.syntaxHelp()` for the common syntax.

| Capture mode | Requested work |
|---|---|
| `INSTRUCTION` | Captured instruction and actual next address; no guest-access tracking or full presentation |
| `ACCESSES` | Instruction/next-address facts plus guest-access tracking; no full `StepView` |
| `FULL` | Instruction/next-address facts, guest-access tracking, and full recorded `StepView` |

emuStudio requests `INSTRUCTION` to follow executed branches and `FULL` during instruction recording.
Closing the observer handle removes its capture request.

Plugin editors apply register and memory changes directly, including while the CPU runs. The host does not queue
edits or coordinate them with execution steps. Keep Swing work on its event thread. `Debugging` adds no update protocol.

## Engine integration

The host supplies the execution worker; do not create another execution controller. CPU engines do not drain a host
edit queue before executing instructions.

Call the observer before guest effects; true requests an intentional stop. After an attempted step, deliver its completed
or failed outcome, captured instruction when available, and truthful actual next address. Full recorded presentation
belongs only to `Capture.FULL`. Watch expressions read current state when execution pauses or stops.
A refused before-step produces no executed row.

The host owns breakpoints, persistence and one-step continuation. It skips breakpoints once for Manual
Step or direct Continue from a breakpoint, then rearms them. Host reset and jump commands clear continuation. Plugins
must not implement a second breakpoint store or independent skip policy.

At computer open, `DebuggerSession` loads watch expressions, breakpoint addresses, and user annotations from
`[debugger]` in the computer TOML. The host saves those values when they change. Compiler annotations, source mappings,
and diagnostics are session state. Annotation import merges entries from a properties file and skips exact duplicates.

Preserve actual guest-step granularity when stopping or detailed capture requires it. BrainDuck grouping cannot hide observed operations; nested interrupt dispatch
must not invent extra operations or attach unrelated program locations. Inspection must use side-effect-free reads and
must not generate guest accesses. Failed/attempted writes must be described honestly.

## Values and recorded presentation

`ValueView` supplies formatted watch text, supported formats and change indication. `StepView` supplies summary,
fold identity, optional program location and immutable `ViewRow` details. Rows carry group, label, before/after
text, change marker, opaque search tags and `NavLink` navigation. There are no mandatory registers, widths or byte opcodes.

For previous-write navigation, a plugin tags its write row and supplies a `new NavLink(label, tag)` on the access row.
The host finds the earlier matching tag relative to that row's original event ordinal, including within folded groups.
It never parses displayed values or understands machine-specific tag meaning.

All bundled CPUs use `PackedCapture` to store before/after state and ordered accesses in primitive chunks.
Repeated instructions share their descriptions, and the recorder formats rows on demand. The 8080 and Z80
derive register pairs from captured bytes. RASP preserves signed memory words, and RAM preserves numeric
and symbolic tape values, including the tape identity and the values before and after a write.
Version 5 of `.emutrace` supports packed events and presentation rows. The reader also opens version 4 files.
Offline details, filtering, folding, links and text export require no CPU plugin, live memory or Swing.
Source links use available current mappings; recordings do not reconstruct historical sources or restore machine state.

Keep machine-specific editing in plugin controls within the shared debugger workspace. Expose only meaningful
capabilities; unsupported conditions remain visibly inactive rather than fabricating registers or memory.

## Failure behavior

Accept and save invalid expressions, but deactivate only the affected watch. Report temporary nonmodal diagnostics;
clear them when corrected. Runtime evaluation and presentation failures never request an emulation pause.

Recording open/write/close failure stops only the recorder, preserves any incomplete file and reports the problem.
Other debugging and emulation continue. Starting another file recording creates a new capture.

Active capture may slow execution through bounded synchronous writing. It must not silently drop requested events.
With observation inactive, retain original execution memory and avoid presentation allocations.

## Runtime instruction flow

`CPU.getDecoder().decode(address)` returns immutable instruction address, occupied-cell length, mnemonic, and encoding.
`DecodedInstruction` has no flow metadata. The observer's `nextAddress` reports where execution actually went, including
conditional and indirect transfers; it is never inferred from length or presentation text.

The host accumulates observed instruction transitions until a successful CPU reset, which clears the graph and retains annotations.
Memory edits, source changes, annotations, and resuming execution do not clear observations. Unexecuted alternatives
are not predicted. Mnemonic/opcode classification, static target declarations, and `.eds` flow syntax are absent.

Runtime flow capture uses lightweight instruction observation during normal execution.
Source mappings and labels remain separate from captured machine-state presentation.

### Optimized execution

Flow observation stays active during Run. An engine may replace individual callbacks with one `ExecutedBlock` only
after `DebuggingSupport.begin()` allows execution and `canBatchInstructions()` returns true, before guest effects.
Support permits batches only for `Capture.INSTRUCTION` and an explicitly opted-in observer. Existing observers
default to individual instruction callbacks. The host declines batching while breakpoints or detailed recording
require exact boundaries. Manual and timed steps retain individual execution.

`ExecutedBlock` contains immutable decoded facts for instructions actually executed, explicit observed transitions,
the final executed address and the resulting PC. Include the final address-to-PC transition. Repeated paths may be
represented once: this is a complete graph contribution, not a chronological event log or a count of executions.
An engine may omit unchanged facts already reported to the same observer. Consumers accumulate contributions;
every contribution still contains its actual final instruction and final transition. A new observer or CPU reset
requires fresh reporting, and code changes must update captured facts even for previously visited addresses.
Do not report skipped loop bodies or infer transfers from instruction length. Call `endBlock(block)` after committing
the authorized block, instead of `end(...)`. Settings changed during that block apply at its next boundary.

Plugins own optimization eligibility, code validation and bounded execution. Fall back to original instructions when
an optimization cannot preserve faults, device effects or requested observations. Keep scan chunks bounded so pause
and settings changes reach a real guest boundary promptly. Never synthesize intermediate register values or recorded
`StepView` events from a bulk result. BrainDuck groups ordinary operations and safe repeat, copy/clear and scan
operations into batches capped at 4,096 operations, with regular interrupt and elapsed-time checks. I/O, stopping
instructions and potentially failing steps retain individual callbacks.

## Reference

See [Debugging]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugin/debugger/Debugging.html),
[StepView]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugin/debugger/StepView.html), and
[DecodedInstruction]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugin/cpu/DecodedInstruction.html).
