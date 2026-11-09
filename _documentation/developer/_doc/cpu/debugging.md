---
layout: default
title: Optional machine debugging
nav_order: 5
parent: Writing a CPU
permalink: /cpu/debugging
---

# Optional machine debugging

A CPU plugin can implement `Debugging` alongside `CPU`. Plugins interpret their machines; emuStudio owns breakpoints,
watches, history, recording and execution control. Real processors can show registers; abstract machines can show tapes
and symbolic values. The shared CPU interface defines neither representation.

## Two operations

```java
public interface Debugging {
    enum Capture { INSTRUCTION, ACCESSES, FULL }

    Expression compile(String source);
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
        default void failed(String message) {}
    }
}
```

Implement the interface directly on the plugin root and delegate to a plugin-owned adapter. `DebuggingSupport` can
share observer mechanics, and `ExpressionParser` can share expression syntax with plugin-defined name/function resolvers.
Resolve names during compilation without reading guest state; evaluation and display happen at the execution seam.

| Capture mode | Requested work |
|---|---|
| `INSTRUCTION` | Captured instruction and actual next address; no guest-access tracking or full presentation |
| `ACCESSES` | Instruction/next-address facts plus guest-access tracking; no full `StepView` |
| `FULL` | Instruction/next-address facts, guest-access tracking, and full recorded `StepView` |

Use `INSTRUCTION` for the default observed graph, `ACCESSES` when memory watches need guest accesses, and `FULL` only
for history or recording. Closing the observer handle removes its capture request.

Plugin editors apply register and memory changes directly, including while the CPU runs. The host does not queue
edits or coordinate them with execution steps. Keep Swing work on its event thread. `Debugging` adds no update protocol.

## Engine integration

The host supplies the execution worker; do not create another execution controller. CPU engines do not drain a host
edit queue before executing instructions.

Call the observer before guest effects; true requests an intentional stop. After an attempted step, deliver its completed
or failed outcome, captured instruction when available, and truthful actual next address. Full recorded presentation
belongs only to `Capture.FULL`. Memory watches are passive and never stop
execution. A refused before-step produces no executed row.

The host owns breakpoints, persistence and one-step continuation. It skips breakpoints once for Manual
Step or direct Continue from a breakpoint, then rearms them. Host reset and jump commands clear continuation. Plugins
must not implement a second breakpoint store or independent skip policy.

At computer open, `DebuggerSession` loads user annotations, watches, breakpoints and memory watches once from the
configuration's `.debugger` file: `/path/computer.toml` uses `/path/computer.toml.debugger`. One atomic save writes them
together. Computers without a saved configuration keep this metadata in memory. Compiler annotations, mappings and
temporary diagnostics are not saved. Explicit annotation import/export remains separate and appends annotations,
skipping exact duplicates.

Preserve actual guest-step granularity. BrainDuck grouping cannot hide observed operations; nested interrupt dispatch
must not invent extra operations or attach unrelated program locations. Inspection must use side-effect-free reads and
must not generate guest accesses. Failed/attempted writes must be described honestly.

## Values and recorded presentation

`ValueView` supplies formatted watch text, supported formats and change indication. `StepView` supplies summary,
fold identity, optional program location and immutable `ViewRow` details. Rows carry group, label, before/after
text, change marker, opaque search tags and `NavLink` navigation. There are no mandatory registers, widths or byte opcodes.

For previous-write navigation, a plugin tags its write row and supplies a `new NavLink(label, tag)` on the access row.
The host finds the earlier matching tag relative to that row's original event ordinal, including within folded groups.
It never parses displayed values or understands machine-specific tag meaning.

The host explicitly serializes this fixed presentation and its ordinal/completion envelope in bounded
recordings. Offline details, filtering, folding, links and text export require no CPU plugin, live memory or Swing.
File limits belong to the codec; shared display values contain no validation framework or public size limits.
Source links use available current mappings; recordings do not reconstruct historical sources or restore machine state.

Keep machine-specific editing in plugin controls within the shared debugger workspace. Expose only meaningful
capabilities; unsupported conditions remain visibly inactive rather than fabricating registers or memory.

## Failure behavior

Accept and save invalid expressions, but deactivate only the affected watch. Report temporary nonmodal diagnostics;
clear them when corrected. Runtime evaluation and presentation failures never request an emulation pause.

Recording open/write/close failure stops only the recorder, preserves any incomplete file and reports the problem.
Other debugging and emulation continue. There is no automatic restart or file-repair logic; a later recording starts
a fresh file. Recorder failures do not change the headless emulation result. A false script `ASSERT` still fails the script.

Active capture may slow execution through bounded synchronous writing. It must not silently drop requested events.
With observation inactive, retain original execution memory and avoid presentation allocations.

## Runtime instruction flow

`CPU.getDecoder().decode(address)` returns immutable instruction address, occupied-cell length, mnemonic, and encoding.
`DecodedInstruction` has no flow metadata. The observer's `nextAddress` reports where execution actually went, including
conditional and indirect transfers; it is never inferred from length or presentation text.

The host accumulates observed instruction transitions until a successful CPU reset, which clears the graph and retains annotations.
Memory edits, source changes, annotations, and resuming execution do not clear observations. Unexecuted alternatives
are not predicted. Mnemonic/opcode classification, static target declarations, and `.eds` flow syntax are absent.

Runtime flow capture uses lightweight instruction observation; enabling the graph does not enable full recording.
`StepView` and the `.emutrace` recording format stay unchanged. Source mappings and labels remain separate from captured
machine-state presentation.

## Reference

See [Debugging]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/debugger/Debugging.html),
[StepView]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/debugger/StepView.html), and
[DecodedInstruction]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/DecodedInstruction.html).
