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

The memory plugin contains a simple graphical window, which can be seen in the following image:

![RAM memory window]({{ site.baseurl }}/assets/ram/ram-memory.png){:style="max-width:728"}

{: .list}
| <span class="circle">1</span> | Load a compiled program, replacing the previous one. RAM binary files have the extension `.bram`.
| <span class="circle">2</span> | Dump memory content into a file (either human-readable or `.bram`).
| <span class="circle">3</span> | Clears memory.
