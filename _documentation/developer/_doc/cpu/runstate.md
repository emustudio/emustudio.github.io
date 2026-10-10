---
layout: default
title: Run states
nav_order: 2
parent: Writing a CPU
permalink: /cpu/runstate
---

{% include analytics.html category="developer" %}

# Run states

CPU execution is represented by a run state. `AbstractCPU` starts in `STATE_STOPPED_NORMAL`; resetting the CPU puts it
in `STATE_STOPPED_BREAK`, ready to execute or single-step.

The state machine, how it should work, can be seen in the following diagram:

![runstate]({{ site.baseurl }}/assets/runstate.svg)

The states of the state machine are encoded into an enum [CPU.RunState][runstate]{:target="_blank"} in emuLib:

{:.code-example}
```java
public static enum RunState {
    STATE_STOPPED_NORMAL("stopped"),
    STATE_STOPPED_BREAK("breakpoint"),
    STATE_STOPPED_ADDR_FALLOUT("stopped (address fallout)"),
    STATE_STOPPED_BAD_INSTR("stopped (instruction fallout)"),
    STATE_RUNNING("running");

    ...
}
```

`AbstractCPU` implements the following controls:

- `reset()` stops execution, resets the engine and selects `STATE_STOPPED_BREAK`.
- `execute()` starts continuous execution only from `STATE_STOPPED_BREAK` and selects `STATE_RUNNING`.
- `step()` executes one instruction only from `STATE_STOPPED_BREAK`. An engine result of `STATE_RUNNING` becomes
  `STATE_STOPPED_BREAK`; normal stops and errors are preserved.
- `pause()` interrupts a running engine and returns to `STATE_STOPPED_BREAK`, unless the engine reports a terminal
  stop or error.
- `stop()` interrupts execution and changes running or breakpoint states to `STATE_STOPPED_NORMAL`. Existing terminal
  errors are preserved.

The engine reports `STATE_STOPPED_ADDR_FALLOUT` for an invalid memory address and `STATE_STOPPED_BAD_INSTR` for an
invalid instruction. A halt may report `STATE_STOPPED_NORMAL`, or remain running while waiting for an interrupt if
that is how the emulated processor works. Continuous execution must check thread interruption so pause and stop can
finish. CPU listeners may run outside Swing's event-dispatch thread; dispatch GUI updates onto that thread.

If the CPU plugin root class implements [CPU][cpu]{:target="_blank"} interface, it is its responsibility to notify CPU
run state changes and manage run state "listeners". But if the plugin root class extends 
[AbstractCPU][abstractCPU]{:target="_blank"}, it does not have care about listeners and run state notifications,
because the class implements it.

[runstate]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPU.RunState.html
[cpu]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPU.html
[abstractCPU]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/AbstractCPU.html
