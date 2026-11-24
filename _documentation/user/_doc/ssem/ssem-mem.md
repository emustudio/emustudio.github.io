---
layout: default
title: Memory "ssem-mem"
nav_order: 5
parent: SSEM
permalink: /ssem/ssem-mem
---

{% include analytics.html category="SSEM" %}

# Memory "ssem-mem"

Use the SSEM memory window to inspect the 32-word Williams–Kilburn store. Each word can be viewed as a number, a bit pattern, or an instruction.

SSEM (1948), a von-Neumann computer, from United Kingdom, used the world's first **random-access** memory called Williams 
or [Williams-Kilburn][tube]{:target="_blank"} tube. It was bit-controlled memory, i.e. the smallest unit was a bit.

The Williams-Kilburn tube stores bits as electrical charge patterns on a cathode-ray tube's surface. A pickup plate
reads the charge, and periodic refresh restores it. This is volatile storage: it requires power and refresh to retain
data. The emulated memory presents the stored bits in the GUI described below.

[EDSAC][edsac]{:target="_blank"} (1949) used sequential memory. Its design drew on von Neumann's
[*First Draft of a Report on the EDVAC*][edvac]{:target="_blank"}.

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

## Load and edit store words

Open **Emulator → Show memory…**. Use **Load image file…** to load a compiled program or **Erase memory** to clear it.
The table presents the same word as bits, hexadecimal, decimal, and characters.

![SSEM memory with bit, hexadecimal, decimal and character columns]({{ site.baseurl }}/assets/ssem/ssem-memory.png)

1. Find the line to change. Use the arrow keys to move between cells.
2. Double-click a bit cell and enter `1` or `0`. Press **Delete** to clear a selected bit.
3. Alternatively, double-click a hexadecimal, decimal, or character cell, edit the whole word, and press Enter.

Both numeric columns accept signed 32-bit integers. Enter `0x20` for hexadecimal 20, `20` for decimal 20, or
`020` for octal 20. A character edit uses the first four characters. The plugin bit-reverses the decoded word for storage.

[tube]: https://en.wikipedia.org/wiki/Manchester_Small-Scale_Experimental_Machine#Williams-Kilburn_tube
[edsac]: https://en.wikipedia.org/wiki/EDSAC
[byte]: https://en.wikipedia.org/wiki/Byte#Etymology_and_history
[edvac]: https://en.wikipedia.org/wiki/First_Draft_of_a_Report_on_the_EDVAC
