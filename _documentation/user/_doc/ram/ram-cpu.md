---
layout: default
title: CPU "ram-cpu"
nav_order: 3
parent: RAM
permalink: /ram/ram-cpu
---

{% include analytics.html category="RAM" %}

# CPU "ram-cpu"

The `ram-cpu` plugin executes RAM instructions. Although RAM is an abstract machine, emuStudio uses the same CPU plugin
interface as it does for physical processors.

The plugin requires `ram-mem` and three instances of `abstract-tape`. At startup, the CPU assigns them to storage, input,
and output, in the order of the `[[DEVICE]]` entries in the computer configuration.
The bundled RAM configuration supplies these connections.

## Status panel

In the following image, you can see the status panel of `ram-cpu`.

![RAM CPU status panel]({{ site.baseurl }}/assets/ram/ram-cpu-status.png)

**Internal status** shows `R0` (the accumulator) and `IP` (the instruction pointer). `IP` is the address of the next
instruction in program memory.

The input/output section shows the next unread symbol ("next input") and the last symbol written to the output tape
("last output"). The tape windows show the same values.

**Run state** shows the emulation state, as in other emuStudio CPU plugins. The state "breakpoint" means execution is paused.

