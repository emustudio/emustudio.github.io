---
layout: default
title: CPU "ssem-cpu"
nav_order: 4
parent: SSEM
permalink: /ssem/ssem-cpu
---

{% include analytics.html category="SSEM" %}

# SSEM CPU emulator

SSEM is one of the first implementations of the von-Neumann design of a computer. It contained a control unit,
arithmetic-logic unit (ALU), and memory (which actually is a CRT display too).

The emulator targets about 700 instructions per second (1.44 ms per instruction). Actual speed depends on the host.

The `ssem-cpu` plugin implements the control unit (instruction decoding and executing) and ALU.

## Status panel

Status panel is shown below:

![SSEM CPU Status panel GUI]({{ site.baseurl }}/assets/ssem/ssem-status-panel.png){: style="max-width: 596px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **A**. Read the accumulator in hexadecimal, decimal, and binary. |
| <span class="circle">2</span> | **CI**. Read the control-instruction byte address. |
| <span class="circle">3</span> | **M[CI]**. Read the instruction word at the control-instruction address. |
| <span class="circle">4</span> | **line**. Read the decoded and reversed instruction-line field. |
| <span class="circle">5</span> | **M[line]**. Read the memory word selected by that line field. |

The registers section shows hexadecimal, decimal, and binary representations of:

- accumulator (`A`)
- "control-instruction" (`CI`), the byte address of the current control line. The CPU increments it by four before
  fetching the next instruction; line `n` has byte address `4 * n`.

The memory snippet shows the current cell values in hexadecimal, decimal, and binary:

- `M[CI]`: memory cell value at `CI` (the current row with the instruction)
- line part (correctly reversed) of the current instruction row
- `M[line]`: memory cell value at `line` address
