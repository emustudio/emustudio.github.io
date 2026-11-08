---
layout: default
title: Optional machine debugging
nav_order: 5
parent: Writing a CPU
permalink: /cpu/debugging
---

# Optional machine debugging

A CPU plugin can implement `Debugging` alongside `CPU`. Plugins interpret their machines; emuStudio owns rule policy,
watches, history, recording and execution control. Real processors can show registers; abstract machines can show tapes
and symbolic values. The shared CPU interface defines neither representation.

## Two operations

```java
public interface Debugging {
    Expression compile(String source);
    AutoCloseable observe(Observer observer, boolean capture);

    interface Expression {
        boolean test();
        ValueView display();
    }

    interface Observer {
        boolean beforeStep();
        boolean afterStep(boolean completed, Optional<StepView> capture);
        default void failed(String message) {}
    }
}
```

Implement the interface directly on the plugin root and delegate to a plugin-owned adapter. `DebuggingSupport` can
share observer mechanics, and `ExpressionParser` can share expression syntax with plugin-defined name/function resolvers.
Resolve names during compilation without reading guest state; evaluation and display happen at the execution seam.

Use the existing `applicationApi.getExecutionState().update(change)` service for live edits. It queues changes between
semantic steps or on the idle CPU worker, without a pause/resume transition. Compile expressions and attach/detach
observers through that same service. Keep Swing work on its event thread. `Debugging` adds no update protocol.

## Engine integration

Every outer semantic step drains `ExecutionState.processUpdates()`, including the inactive fast path. This makes live
attachment and edits possible without waiting for a continuous run to end. The host supplies the worker; do not create
another execution controller.

Call the observer before guest effects; true requests an intentional stop. After an attempted step, deliver its completed
or failed outcome, plus presentation only when capture is requested. Record the stopping step before honoring a
post-step watchpoint. A refused before-step produces no executed row.

The host owns breakpoints, hit counts, persistence and one-step continuation. It skips before-step rules once for Manual
Step or direct Continue from a breakpoint, then rearms them. Reset, jump and machine edits clear continuation. Plugins
must not implement a second breakpoint store or independent skip policy.

At computer open, `DebugSession` loads annotations, watches and rules once from the configuration's `.debugger` file:
`/path/computer.toml` uses `/path/computer.toml.debugger`. One atomic save writes all three together. Computers without
a saved configuration keep this metadata in memory. Compiler mappings, temporary diagnostics and hit counts are not
saved. Explicit annotation import/export remains separate and uses annotation format 4.

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

Accept and save invalid expressions, but deactivate only the affected rule/watch. Report temporary nonmodal diagnostics;
clear them when corrected. Runtime evaluation and presentation failures never request an emulation pause.

Recording open/write/close failure stops only the recorder, preserves any incomplete file and reports the problem.
Other debugging and emulation continue. There is no automatic restart or file-repair logic; a later recording starts
a fresh file. Recorder failures do not change the headless emulation result. A false script `ASSERT` still fails the script.

Active capture may slow execution through bounded synchronous writing. It must not silently drop requested events.
With observation inactive, retain original execution memory and avoid presentation allocations.

## Flow metadata

`Disassembler.getFlow(address)` still returns optional `InstructionFlow` for addressed programs. Unresolved indirect
targets stay unresolved; do not parse mnemonics to invent destinations. Source mappings, labels and program analysis
remain separate from machine-state presentation.

## Reference

See [Debugging]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/debugger/Debugging.html),
[StepView]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/debugger/StepView.html), and
[InstructionFlow]({{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/InstructionFlow.html).
