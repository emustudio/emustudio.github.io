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

RAM CPU reads instructions from this memory, data are read from abstract tapes. Instructions are written into this
memory only through compiling the source code or loading an already compiled binary image.

The memory plugin contains a simple graphical window, which can be seen in the following image:

![RAM memory window]({{ site.baseurl }}/assets/ram/ram-memory.png){:style="max-width:728"}

{: .list}
| <span class="circle">1</span> | Open already compiled program into memory. The previous program will be dismissed. RAM binary files has extension `.bram`.
| <span class="circle">2</span> | Dump memory content into a file (either human-readable or `.bram`).
| <span class="circle">3</span> | Clears memory.
