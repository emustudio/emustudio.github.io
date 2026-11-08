---
layout: default
title: Memory "ram-mem"
nav_order: 4
parent: RAM
permalink: /ram/ram-mem
---

{% include analytics.html category="RAM" %}

# Program memory ("ram-mem")

RAM memory is a part of RAM simulator and acts as the "program memory" (it holds just the program, no data).

The RAM CPU reads instructions from this memory and data from abstract tapes. Compile source code or load a compiled
binary image to populate program memory.

The memory window provides **Load image file...** for compiled programs and **Erase memory** to clear the content.
Inspect values in the memory table; double-click an editable cell and press Enter to confirm a change.
