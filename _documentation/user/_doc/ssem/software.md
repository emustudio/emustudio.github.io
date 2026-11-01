---
layout: default
title: Software for SSEM
nav_order: 1
parent: SSEM
permalink: /ssem/software
---

{% include analytics.html category="SSEM" %}

# Software for SSEM

Start with the examples supplied with emuStudio, then explore the historical programs and competition entries below.
SSEM programs share just 32 words of memory between instructions and data. Some calculate a result; others turn the
store's bit patterns into pictures or animations on the [SSEM display]({{ site.baseurl }}/ssem/ssem-display).

## Run a bundled example

1. Open the **SSEM (Baby)** virtual computer.
2. Open a `.ssem` file from `examples/as-ssem/` in your emuStudio installation.
3. Click **Save & Compile source file**. Compilation loads the program into memory and resets the CPU.
4. Switch to **Debugger** and use **Step forward** to follow individual instructions, or **Run** to execute continuously.
5. Inspect numerical results in the [memory window]({{ site.baseurl }}/ssem/ssem-mem). For graphical examples, open the
   `ssem-display` device window.

Recompile before a fresh run: many examples change their own instructions or overwrite their input data.

The [bundled source directory][examples]{:target="_blank"} includes these programs. Each source file describes its inputs,
results, and any timing settings.

| Program | What to try |
|:--|:--|
| `addition.ssem` | Add two numbers and read the sum in line 31. A good first program to single-step. |
| `dec-till-negative.ssem` | Follow a countdown loop using a conditional skip and an indirect jump. |
| `highest-factor.ssem` | Explore a reconstruction of an early factor-finding program. |
| `highest-common-factor.ssem` | Find the highest common factor of two integers. |
| `bcs-division.ssem` | Perform integer division; lines 30 and 31 hold the quotient and remainder. |
| `square-root.ssem` | Approximate a square root by subtracting successive odd numbers. |
| `primegen.ssem` | Study a prime-number generator that uses self-modifying code. |
| `parabola.ssem` | Plot a curve in the unused bits of instruction words. |
| `medclock.ssem`, `noodle-timer.ssem` | Explore a clock and a timer. Their timing depends on execution speed. |
| `ssem.ssem`, `the-fraj.ssem`, `nightmare.ssem` | Watch text and picture animations in the store display. |
| `virpet.ssem` | Keep a virtual pet fed by changing its food supply in memory. |

### First program: add two numbers

Save this as `addition.ssem`, then compile and run it:

```text
00 START
01 LDN 29  ; A = -5
02 SUB 30  ; A = -5 - 3 = -8
03 STO 31  ; Store the negative sum
04 LDN 31  ; A = 8
05 STO 31  ; Store the sum
06 STP

29 NUM 5
30 NUM 3
31 NUM 0
```

When the CPU stops, the accumulator and memory line **31** contain **8**. Change the values on lines 29 and 30,
recompile, and run again. SSEM has no addition instruction, so the program forms a negative sum and negates it.
See the [assembler guide]({{ site.baseurl }}/ssem/as-ssem) for the instruction set and source syntax.

### Store display example

The bundled [ssem.ssem][ssem-ssem]{:target="_blank"} animates the text “SSEM” by changing memory words:

![SSEM store display running the bundled text animation]({{ site.baseurl }}/assets/ssem/ssem-display.png){: style="max-width: 456px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Store display**. Each row represents a store line; lit dots show set bits in the 32-bit words. |

## More program sources

These sources provide listings, explanations, or software collections. Programs written for other assemblers may need
the changes described in the next section.

- [Manchester's 1998 competition prizewinners][prizewinners]{:target="_blank"}. Listings and author notes for integer
  division, prime generation, a medieval clock, a parabola, *Tom Kilburn's Nightmare*, and the winning noodle timer.
  Several have already been adapted in the bundled examples.
- [An Introduction to Programming the “Baby” Mark 1][introduction]{:target="_blank"}. A worked highest-common-factor
  program with an assembly listing and a binary snapshot. Its example calculates the HCF of 3,141,593 and 5,214,
  leaving **79** in line 30.
- [Neil Croft's Technical Introduction to Programming the Baby (PDF)][tutorial]{:target="_blank"}. A beginner's guide
  with addition and subtraction examples, single-stepping exercises, and a discussion of the original 1948 program.
  Its control-panel instructions refer to David Sharp's simulator.
- [gobaby examples][gobaby]{:target="_blank"}. Three compact assembly listings: `simple_calc.asm`, `factor.asm`, and
  `primegen.asm`. Compare their source syntax with `as-ssem` before compiling.
- [SSEM Programmer's Reference Manual][reference]{:target="_blank"}. Instruction details and examples of addition,
  indirect jumps, instruction modification, and counters stored in spare instruction bits.
- [Computer Conservation Society's SSEM collection][ccs]{:target="_blank"}. Historical context and downloadable
  simulators. Use it to explore other implementations; their program formats and controls differ from emuStudio's.

## Adapt programs for emuStudio

Use the [as-ssem syntax]({{ site.baseurl }}/ssem/as-ssem#language-syntax) when transcribing an external listing:

- Give each instruction or data word a line number from **0 to 31**. Remove punctuation after the number:
  `01: LDN 29` becomes `01 LDN 29`.
- Remove a leading standalone word count, such as the `22` in the Manchester HCF listing. It counts stored words;
  it is not a starting address or an instruction.
- Use `STP` or `HLT` for a halt. Replace `STOP` if the source uses that spelling. `CMP` and `SKN` are accepted names
  for the conditional skip.
- Set the initial control line with `line START`. With `00 START`, execution begins on line **1**, because the CPU
  increments the control line before fetching. `JMP n` reads its destination from memory line `n`; that stored value
  must be one less than the intended destination line.
- Use `NUM` for decimal constants and `BNUM` for complete binary words. SSEM listings show the least significant bit
  on the **left**; preserve that written order when copying a snapshot row. For example,
  `0031:10000000000000000000000000000000` becomes `31 BNUM 10000000000000000000000000000000` (the value 1).
- Preserve all 32 bits in graphical or self-modifying programs. Spare instruction bits can hold pictures, counters,
  or data, so replacing a whole word with a mnemonic can change the program.

Compile the adapted `.ssem` source to produce an emuStudio `.bssem` image. A snapshot from another simulator, such as
a text `.snp` file, needs conversion; changing its extension does not convert its contents. For raw listings that use
the historical alternate subtraction opcode `101`, use an ordinary `SUB` instruction where appropriate: the current
emuStudio CPU does not execute that alternate opcode.

[examples]: https://github.com/emustudio/emuStudio/tree/develop/plugins/compiler/as-ssem/src/main/examples
[ssem-ssem]: https://github.com/emustudio/emuStudio/blob/develop/plugins/compiler/as-ssem/src/main/examples/ssem.ssem
[prizewinners]: https://www.curation.cs.manchester.ac.uk/computer50/www.computer50.org/mark1/prog98/prizewinners.html
[introduction]: https://curation.cs.manchester.ac.uk/computer50/www.computer50.org/mark1/prog98/intro.html
[tutorial]: https://www.davidsharp.com/baby/NeilCroft-TechnicalIntroductionToProgrammingTheBabyv4.0.pdf
[gobaby]: https://github.com/jcla1/gobaby/tree/master/examples
[reference]: https://curation.cs.manchester.ac.uk/computer50/www.computer50.org/mark1/prog98/ssemref.html
[ccs]: https://www.computerconservationsociety.org/software/ssem/base.htm
