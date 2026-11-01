---
layout: default
title: MITS Altair8800
description: "MITS Altair 8800 emulator in emuStudio — emulate an early personal computer with Intel 8080 and Zilog Z80 CPUs, 88-DCDD floppy, ADM-3A and VT100 terminals."
nav_order: 3
has_children: true
permalink: /altair8800/
---

{% include analytics.html category="Altair8800" %}

# MITS Altair8800

The MITS Altair 8800 was introduced in 1975 with an Intel 8080 CPU, 256 bytes of memory, and no display or keyboard.
Designed by Ed Roberts, it helped make the personal computer accessible to enthusiasts. As Wikipedia states:

> The Altair is widely recognized as the spark that ignited the microcomputer revolution.
>> Wikipedia, Altair 8800

![MITS Altair8800 with LSI ADM-3A terminal and floppy drive]({{ site.baseurl }}/assets/altair8800/altair8800.png)

The Altair became one of the early commercially successful personal computers. MITS sold the machines by mail,
directly from the factory. Enthusiasts developed hardware and software for a computer they could own and use at home,
rather than sharing a mainframe through batch jobs.

In 1975, Paul Allen and Bill Gates wrote Altair BASIC, a version of the BASIC programming language for the machine.
That work led to the founding of Microsoft.

Basic configuration of MITS Altair 8800 was:

|---
| Item | Notes
|-|-
|Processor | Intel 8080 or 8080a
|Speed | 2 MHz
|RAM | from 256 bytes to 64 kB
|ROM | optional; usually EPROM Intel 1702 with 256 bytes (They were used for various bootloaders)
|Storage | optional; paper tapes, cassette tapes or 5.25" or 8" floppy disks (MITS 88-DCDD)
|Extensions | at first 16 slots, later 18 slots
|Bus | famous [S-100][s100]{:target="_blank"}
|Video | none
|I/O | optional; parallel or serial board (MITS 88-SIO)
|Original software| [Altair DOS][ados]{:target="_blank"}, [CP/M][cpm]{:target="_blank"}, [Altair BASIC][basic]{:target="_blank"}
|---

## Altair8800 for emuStudio

In emuStudio, there exist two variants of the computer, varying in CPU. Either Intel 8080 CPU, or Zilog Z80 CPU is used.
Some behavior was inspired by [simh] emulator. Abstract schema for emuStudio (Intel 8080):

![Abstract schema of MITS Altair8800 (with Intel 8080)]({{ site.baseurl }}/assets/altair8800/altair-8080-schema.png){:style="max-width:569px; width:100%"}

Abstract schema for emuStudio (Zilog Z80):

![Abstract schema of MITS Altair8800 (with Zilog Z80)]({{ site.baseurl }}/assets/altair8800/altair-z80-schema.png){:style="max-width:569px; width:100%"}

Each plugin is described in further sections.


[simh]: http://simh.trailing-edge.com/
[s100]: https://en.wikipedia.org/wiki/S-100_bus
[ados]: http://altairclone.com/downloads/manuals/Altair%20DOS%20User's%20Manual.pdf
[cpm]: http://www.classiccmp.org/dunfield/r/cpm22.pdf
[basic]: https://en.wikipedia.org/wiki/Altair_BASIC
