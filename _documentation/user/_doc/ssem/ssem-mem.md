---
layout: default
title: Memory "ssem-mem"
nav_order: 5
parent: SSEM
permalink: /ssem/ssem-mem
---

{% include analytics.html category="SSEM" %}

# Memory "ssem-mem"

SSEM (1948), a von-Neumann computer, from United Kingdom, used the world's first **random-access** memory called Williams 
or [Williams-Kilburn][tube]{:target="_blank"} tube. It was bit-controlled memory, i.e. the smallest unit was a bit.

The Williams-Kilburn tube stores bits as electrical charge patterns on a cathode-ray tube's surface. A pickup plate
reads the charge, and periodic refresh restores it. This is volatile storage: it requires power and refresh to retain
data. The emulated memory presents the stored bits in the GUI described below.

Interesting fact is that [EDSAC][edsac]{:target="_blank"} computer (1949), which was directly inspired by von-Neumann's
["First draft of a report on the EDVAC"][edvac]{:target="_blank"} did not have random-access memory.

SSEM memory has 32 memory cells (called words, in emuStudio called "rows"). Each cell has size of 32 bits (4 bytes, even 
though the word "byte" was [formed later][byte]{:target="_blank"}). The memory could contain instructions or data (hence von-Neumann
computer). Each SSEM instruction perfectly fits in a single memory cell.

The bit representation of a memory cell is reversed. For example, value `3`, in common personal computers is represented
as `011`, but in SSEM memory it's represented as `110`.

An instruction uses the following fields within a memory word:

| Bits | 0–4 | 5–12 | 13–15 | 16–31 |
|:-----|:----|:-----|:------|:------|
| Use | Line (`LLLLL`) | Unused | Opcode (`III`) | Unused |

where bits `LLLLL` denote a "line", which was interpreted as memory "address" - index of a memory cell. It was used
as instruction operand. Bits `III` specify the instruction opcode (3 bits are enough for 7 instructions used by the
computer). The rest of bits are unused, and thus were often used as data store.

## Graphical user interface (GUI)

The memory window looks as follows:

![SSEM Memory GUI sample look]({{ site.baseurl }}/assets/ssem/ssem-memory.png){: style="max-width: 961px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Load image**. Load a compiled memory image. |
| <span class="circle">2</span> | **Dump memory**. Save the current memory content. |
| <span class="circle">3</span> | **Erase memory**. Clear the memory content. |
| <span class="circle">4</span> | **Memory table**. Inspect memory values; double-click an editable cell and press Enter to confirm the change. |

Double-click a bit cell to edit it. Accepted values are `1` and `0`; press **Delete** to clear a bit to `0`.

You can also double-click a hexadecimal, decimal, or character cell to edit the word. Both numeric columns accept
decimal integers or hexadecimal integers with a `0x` prefix. For example, enter `0x20` for hexadecimal 20; entering `20`
stores decimal 20, even in the **Hex** column. A leading `0` selects octal, so use `0x` explicitly for hexadecimal
values. Values must fit a signed 32-bit integer. A character edit uses the first
four characters. The plugin bit-reverses the decoded word for storage.

Navigating cells is possible also with arrow keys.

[tube]: https://en.wikipedia.org/wiki/Manchester_Small-Scale_Experimental_Machine#Williams-Kilburn_tube
[edsac]: https://en.wikipedia.org/wiki/EDSAC
[byte]: https://en.wikipedia.org/wiki/Byte#Etymology_and_history
[edvac]: https://en.wikipedia.org/wiki/First_Draft_of_a_Report_on_the_EDVAC
