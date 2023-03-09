---
layout: default
title: CPU "rasp-cpu"
nav_order: 2
parent: RASP
permalink: /rasp/rasp-cpu
---

{% include analytics.html category="RASP" %}

# CPU "rasp-cpu"

This plugin is the core of the emulation/simulation. Even if we're supposed to talk about the RASP simulator, because
emulation is connected more with imitation of real hardware than the abstract machine, there is a plugin that calls
itself a RASP CPU. It is really not accurate, but CPU nowadays means something as the
main or core engine of the computation which the machine does. So the name got stuck rather with this convention.

The plugin strictly requires a `rasp-mem`, and two instances of `abstract-tape` plugins, representing the input and 
output tapes. After boot, the CPU assigns the specific meaning to each tape.


## Status panel

In the following image, you can see the status panel of `rasp-cpu`.

![RAM CPU status panel]({{ site.baseurl }}/assets/rasp/rasp-cpu-status.png)

It is split into three parts. Within the 'Internal status' part, there is shown the content of registers `R0`
(accumulator) and `IP`. Register `IP` is the position of the program memory head. It stands for "instruction pointer". It
is pointing at the next instruction being executed.

The input/output part shows the next unread symbol ("next input"), and the last symbol written to the output tape ("last
output"). This is just for convenience; it is possible to see the same values in particular tape devices.

The last part, "Run state", shows in which state the whole emulation is, and it is common to all emulators in emuStudio.
The state "breakpoint" means that the emulation is paused.
