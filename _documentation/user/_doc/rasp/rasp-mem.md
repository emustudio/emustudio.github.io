---
layout: default
title: Memory "rasp-mem"
nav_order: 4
parent: RASP
permalink: /rasp/rasp-mem
---

{% include analytics.html category="RASP" %}

# Memory "rasp-mem"

Inspect the shared program and data words in the RASP memory window. Load a compiled program, select a word to edit it, or clear memory before an experiment.

Compilation loads the program into RASP memory. During execution, the CPU reads instructions and operands from this
memory and writes results back to it. Inputs and outputs use the separate tapes.

## Edit a memory word

Open **Emulator → Show memory…**. Use **Load image file…** to load a compiled program or **Erase memory** to clear it.

![RASP memory showing addresses and numeric words]({{ site.baseurl }}/assets/rasp/rasp-memory.png)

1. Stop or pause execution, then find the address to change.
2. Double-click its numeric value, enter the new word, and press Enter.
3. Check the updated value before resuming.

{: .warning}
Editing an opcode changes the instruction. For example, changing `7` to `9` replaces `ADD =` with `SUB =`.
An invalid opcode can stop execution with **instruction fallout**.
