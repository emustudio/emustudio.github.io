---
layout: default
title: CPU "rasp-cpu"
nav_order: 3
parent: RASP
permalink: /rasp/rasp-cpu
---

{% include analytics.html category="RASP" %}

# CPU "rasp-cpu"

The `rasp-cpu` plugin executes RASP instructions. Although RASP is an abstract machine, emuStudio uses the same CPU plugin
interface as it does for physical processors.

The plugin requires `rasp-mem` and two instances of `abstract-tape`. At startup, the CPU assigns them to input and output,
in the order of the `[[DEVICE]]` entries in the computer configuration.
The bundled RASP configuration supplies these connections. Both tapes accept integer symbols only.


## Status panel

In the following image, you can see the status panel of `rasp-cpu`.

![RASP CPU status panel]({{ site.baseurl }}/assets/rasp/rasp-cpu-status.png)

**Internal status** shows `R0` (the accumulator) and `IP` (the instruction pointer). `IP` is the memory address of the next
instruction.

The input/output section shows the next unread symbol ("next input") and the last symbol written to the output tape
("last output"). The tape windows show the same values.

**Run state** shows the emulation state, as in other emuStudio CPU plugins. The state "breakpoint" means execution is paused.
