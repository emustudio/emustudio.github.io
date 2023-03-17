---
layout: default
title: Memory "ssem-mem"
nav_order: 3
parent: SSEM
permalink: /ssem/ssem-mem
---

{% include analytics.html category="SSEM" %}

# Memory "ssem-mem"

SSEM (1948), a von-Neumann computer, from United Kingdom, used the world's first **random-access** memory called Williams 
or [Williams-Kilburn][tube]{:target="_blank"} tube. It was bit-controlled memory, i.e. the smallest unit was a bit.

The base device of the memory was actually a standard Cathode-Ray-Tube (CRT). Electron beams, controlled by magnetic
fields, hit a phosphorescent surface of the vacuum tube and as they "jump" inside, they create a glow which can be seen
with naked eye. What Williams invented was the way how to permanently keep a "bit" stored in the tube, by so-called
"anticipation pulse method". When a charged electron hits the surface, some charge is leaked from the surface, which
then can be "scanned" (recognized) which then was re-inforced back-in the tube. This way the bit could "shine" permanently,
until switched "off" manually. It's true - bits could be switched off by switches on the machine.

Interesting fact is that [EDSAC][edsac]{:target="_blank"} computer (1949), which was directly inspired by von-Neumann's
["First draft of a report on the EDVAC"][edvac]{:target="_blank"} did not have random-access memory.

SSEM memory has 32 memory cells (called words, in emuStudio called "rows"). Each cell has size of 32 bits (4 bytes, even 
though the word "byte" was [formed later][byte]{:target="_blank"}). The memory could contain instructions or data (hence von-Neumann
computer). Each SSEM instruction perfectly fits in a single memory cell.

The bit representation of a memory cell is reversed. For example, value `3`, in common personal computers is represented
as `011`, but in SSEM memory it's represented as `110`.

The structure of a memory cell is as follows:

| *Bit:*  | 00 | 01 | 02 | 03 | 04 | ... | 13 | 14 | 15 | ... | 31
| *Use:*  | L | L | L | L | L | 0 | I | I | I | 0 | 0
| *Value:*| 2^0 | | | | | | | | | | 2^31

where bits `LLLLL` denote a "line", which was interpreted as memory "address" - index of a memory cell. It was used
as instruction operand. Bits `III` specify the instruction opcode (3 bits are enough for 7 instructions used by the
computer). The rest of bits are unused, and thus were often used as data store.


## Graphical user interface (GUI)

The memory window looks as follows:

![SSEM Memory GUI sample look]({{ site.baseurl }}/assets/ssem/ssem-memory.png){:style="max-width:969px"}

{: .list}
| <span class="circle">1</span> | Open SSEM binary image into memory (files compiled by SSEM compiler with extension `.bssem`)
| <span class="circle">2</span> | Dump memory into a file (binary `.bssem` or human-readable `.txt`)
| <span class="circle">3</span> | Clear memory
| <span class="circle">4</span> | Decomposed instruction bits: line bits
| <span class="circle">5</span> | Decomposed instruction bits: instruction opcode
| <span class="circle">6</span> | Hexadecimal representation of the memory "row" (32 bits), correctly reversed
| <span class="circle">7</span> | Decimal representation of the memory "row", correctly reversed
| <span class="circle">8</span> | Character string made of combining 4x 8 bits of memory "row", not reversed

It is possible to edit the bit cells manually: select the bit, double-click. The only accepted value is either 1 or 0.
With a DELETE key, the bit is cleared to 0.

It is also possible to edit hexadecimal, decimal or character string representation. Double-click on such cell and enter
the value in particular format. For hexadecimal and decimal formats, the accepted values will be bit-reversed.

Navigating cells is possible also with arrow keys.


[tube]: https://en.wikipedia.org/wiki/Manchester_Small-Scale_Experimental_Machine#Williams-Kilburn_tube
[edsac]: https://en.wikipedia.org/wiki/EDSAC
[byte]: https://en.wikipedia.org/wiki/Byte#Etymology_and_history
[edvac]: https://en.wikipedia.org/wiki/First_Draft_of_a_Report_on_the_EDVAC
