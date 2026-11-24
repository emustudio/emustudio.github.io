---
layout: default
title: Memory "ram-mem"
nav_order: 4
parent: RAM
permalink: /ram/ram-mem
---

{% include analytics.html category="RAM" %}

# Program memory ("ram-mem")

RAM program memory holds instructions, and the storage tape holds data registers. Open the memory window to inspect the compiled program, its labels, and instruction addresses.

![RAM program memory with compiled addresses, labels, and instructions]({{ site.baseurl }}/assets/ram/ram-memory.png)

1. Compile your source file or choose **Load image file…** in the memory window to load a compiled program.
2. Open **Emulator → Show memory…** to inspect program addresses, labels, and decoded instructions.
3. Use **Erase memory** to clear the program. To change an instruction, edit the source and compile again.

See [Abstract tapes]({{ '/ram/abstract-tape' | relative_url }}) for the storage, input, and output tapes.
