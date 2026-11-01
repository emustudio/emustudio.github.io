---
layout: default
title: Memory "rasp-mem"
nav_order: 4
parent: RASP
permalink: /rasp/rasp-mem
---

{% include analytics.html category="RASP" %}

# Memory "rasp-mem"

The `rasp-mem` plugin stores both program and data, following RASP's von Neumann architecture.

Compilation loads the program into RASP memory. During execution, the CPU reads instructions and operands from this
memory and writes results back to it. Inputs and outputs use the separate tapes.

## Graphical user interface (GUI)

Open the memory window from the **Debugger** tab in emuStudio:

![RASP memory window]({{ site.baseurl }}/assets/rasp/rasp-memory.png)

{: .list}
| <span class="circle">1</span> | Load a compiled program, replacing the previous one. RASP binary files have the extension `.brasp`.
| <span class="circle">2</span> | Dump memory content into a file (either human-readable or `.brasp`).
| <span class="circle">3</span> | Clears memory.

The table with memory content is editable. By double-clicking on a row you can simply edit the value. You confirm your
changes by the `ENTER` key:

![RASP memory window]({{ site.baseurl }}/assets/rasp/rasp-memory-edit.png)

NOTE: By editing an opcode cell (a cell that contains an instruction opcode), the instruction is changed. It is also possible
to set invalid opcode values, which stop emulation with "instruction fallout".

For example, if a cell contains the `ADD =` instruction (operation code 7), which is then changed to 9 (`SUB =`), 
the instruction on that location will be now changed and emuStudio will interpret it as such.
