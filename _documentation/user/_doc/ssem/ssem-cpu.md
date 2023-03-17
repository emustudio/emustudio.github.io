---
layout: default
title: CPU "ssem-cpu"
nav_order: 2
parent: SSEM
permalink: /ssem/ssem-cpu
---

{% include analytics.html category="SSEM" %}

# SSEM CPU emulator

SSEM is one of the first implementations of the von-Neumann design of a computer. It contained a control unit,
arithmetic-logic unit (ALU), and memory (which actually is a CRT display too).

The speed of CPU is around 700 instructions per second.

The `ssem-cpu` plugin implements the control unit (instruction decoding and executing) and ALU.

## Status panel

Status panel is shown below:

![SSEM CPU Status panel GUI]({{ site.baseurl }}/assets/ssem/ssem-status-panel.png)

Registers section shows hexadecimal, decimal and binary representation of the:
- accumulator (`A`)
- "control-instruction" (`CI`), which holds memory address of the current instruction (zero-based program counter)

Memory-snippet shows "actual" memory-cell values (hexadecimal, decimal and binary):
- `M[CI]`: memory cell value at `CI` (the current row with the instruction)
- line part (correctly reversed) of the current instruction row
- `M[line]`: memory cell value at `line` address
