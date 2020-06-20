---
layout: default
title: CPU "ssem-cpu"
nav_order: 2
parent: SSEM
permalink: /ssem/ssem-cpu
---

# SSEM CPU emulator

SSEM is one of the first implementations of the von-Neumann design of a computer. It contained a control unit, arithmetic-logic unit, and I/O subsystem (CRT display).

The speed of CPU is around 700 instructions per second.

The architecture of our SSEM CPU emulator will look as follows (below is Display and Memory just to show how it is connected in overall):

![SSEM scheme]({{ site.baseurl }}/assets/ssem/ssem-scheme.svg)

## Status panel

The status panel is the interaction point between the CPU and the user. With it, the user can be allowed to modify or view the internal status of the CPU emulator. This is very handy when learning or checking how it works, what the registers' values are (and compare them with those shown on a display), etc. The status panel shows the following:

- CPU run state
- Internal state: registers or possibly portion of memory
- Speed

SSEM CPU status panel looks as follows:

![SSEM CPU Status panel GUI]({{ site.baseurl }}/assets/ssem/cpu-status-panel.png)
