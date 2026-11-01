---
layout: default
title: RASP
description: "Random Access Stored Program (RASP) machine emulator in emuStudio — study von Neumann architecture with this abstract computer simulator."
nav_order: 9
has_children: true
permalink: /rasp/
---

{% include analytics.html category="RASP" %}

# Random-Access Stored Program (RASP)

A Random Access Stored Program machine (RASP) is an abstract computer used to study
[von Neumann architecture][von-neumann]{:target="_blank"} without the details of a particular manufacturer's hardware.

The following figure shows its architecture:

![RASP machine]({{ site.baseurl }}/assets/rasp/rasp-machine.svg){: width="65%"}

The control unit reads data from the input tape and writes results to the output tape. The reading (R) and writing (W)
heads point to the current positions on these I/O tapes.

Program and data share the same memory. Instructions with operands occupy two adjacent cells: the opcode, followed by
the operand. `HALT` occupies one cell. The control unit can read and write this memory, so a program can modify its own
instructions.

Unlike the theoretical model, this implementation uses signed 32-bit integers. See the compiler's
[numeric limits]({{ site.baseurl }}/rasp/raspc-rasp#numeric-limits) before using large values.

## RASP for emuStudio

Each virtual computer in emuStudio is defined by the so-called "abstract schema". It defines all the parts of its
architecture (what it consists of) and inner communication (how architecture components are interconnected). The
following figure presents the RASP abstract schema:

![RASP abstract schema]({{ site.baseurl }}/assets/rasp/rasp-schema.png){:style="max-width:561px; width:100%"}


[von-neumann]: https://en.wikipedia.org/wiki/Von_Neumann_architecture
