---
layout: default
title: Run states
nav_order: 2
parent: Writing a CPU
permalink: /cpu/runstate
---

{% include analytics.html category="developer" %}

# Run states

CPU execution is represented by a run state owned by emuStudio's execution module. Resetting the machine puts it in
`STATE_STOPPED_BREAK`, ready to execute or single-step. CPU plugins return instruction outcomes; they do not own the
host's lifecycle state or start execution threads.

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

The host implements the following controls:

- `reset()` requests execution to stop, waits for actual loop exit, then resets memory, devices, and CPU before selecting
  `STATE_STOPPED_BREAK`.
- `execute()` starts continuous execution only from `STATE_STOPPED_BREAK` and selects `STATE_RUNNING`.
- `step()` invokes the plugin's synchronous step only from `STATE_STOPPED_BREAK`. An engine result of `STATE_RUNNING` becomes
  `STATE_STOPPED_BREAK`; normal stops and errors are preserved.
- `pause()` requests interruption and returns to `STATE_STOPPED_BREAK` after execution exits, unless the engine reports a terminal
  stop or error.
- `stop()` requests interruption and changes running or breakpoint states to `STATE_STOPPED_NORMAL` after execution exits. Existing terminal
  errors are preserved.

The engine reports `STATE_STOPPED_ADDR_FALLOUT` for an invalid memory address and `STATE_STOPPED_BAD_INSTR` for an
invalid instruction. A halt may report `STATE_STOPPED_NORMAL`, or remain running while waiting for an interrupt if
that is how the emulated processor works. An actual halt or failure wins a race with a pause or stop request.

## Thread ownership and completion

Each machine has one command scheduler and one CPU worker. Continuous `CPU.execute()` runs on the worker and returns
only after its instruction loop exits. `CPU.step()` returns the result of one instruction; `CPU.reset(int)` completes
inline. The host keeps the scheduler available for cancellation while the worker is occupied. A separate watcher thread
is unnecessary. Timed stepping waits its configured delay after each completed step, preventing a backlog of timer ticks.
Manual step, pause, stop, reset, replacement timed runs, and close cancel the previous timed sequence.

Stopping is cooperative: check thread interruption in the instruction loop and preserve interruption when handling
interruptible waits. There is no force kill or timeout. Pause, stop, reset, and close remain pending until the loop actually
exits. Future cancellation alone does not prove exit. Until then, memory and device resources remain intact; the host
rejects new start, step, and reset requests. GUI commands are asynchronous, so waiting does not block Swing.

`CPUContext` exposes `getRunState()`, `getInstructionLocation()` and `getMeasuredFrequencyKhz()` directly.
Register a `CPUContext.CPUListener` using
`addCPUListener` to receive `runStateChanged` and `internalStateChanged` notifications. Call `removeCPUListener` when
the view or plugin is disposed. CPU plugins emit notifications internally; the public context has no state setter or
notification methods. Callbacks may run outside Swing's event-dispatch thread; dispatch GUI updates onto Swing and
never block a callback waiting for an execution command.

Register and memory editors write directly, including from Swing callbacks while the CPU runs. The host does not
queue these changes, pause execution, or coordinate edits with instruction steps. Host commands that require a paused
machine keep their own validation.

For CPUs that measure executed frequency, `sampleFrequency()` is called by the existing command scheduler. Sampling
must be short and non-blocking. `FrequencyCalculator` owns no scheduler; instruction timing remains in the worker's
`AccurateFrequencyRunner` loop.

[runstate]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPU.RunState.html
[cpu]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPU.html
[abstractCPU]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/AbstractCPU.html
