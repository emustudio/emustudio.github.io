---
layout: default
title: Original software
nav_order: 10
parent: MITS Altair8800
permalink: /altair8800/software
---

{% include analytics.html category="Altair8800" %}

# Original software for Altair8800

Since Altair8800 virtual computer emulates a real machine, it's possible to use real software written for the computer.
Several operating systems and programs can be run on Altair. There are many disk and memory images of those systems
available online, but only some were tested and proved to work. Some available online sites are:

- Peter Schorn: [operating systems][schorn-os]{:target="_blank"},
  [other operating systems][schorn-os2]{:target="_blank"},
  [original Altair8800 software][schorn-software]{:target="_blank"}, [programming languages][schorn-langs]{:target="_blank"},
  [office applications][schorn-office]{:target="_blank"}, [games and tools][schorn-games]{:target="_blank"},
- SIMH [CP/M and DOS][ceo-altair]{:target="_blank"}, [updated kit][ps-altair]{:target="_blank"} with 4K Basic, 8K Basic,
  Prolog, and CP/M 3
- [Altair clone][aclone]{:target="_blank"}
- [DeRamp][deramp]{:target="_blank"}

In order to manipulate with CP/M disk images, there are several options:

- please look at 88-dcdd page [Experimental CP/M support][88-dcdd-cpm]
- you can try [cpmtools][cpmtools]{:target="_blank"}.
- [SIMH emulator][simh]{:target="_blank"} supports run-time reading and writing files using utilities `HDIR.COM` (lists
  files on host computer),
  `R.COM` (reads file from host into CP/M disk image) and `W.COM` (writes a file in CP/M disk image to host)

Tested and fully-functional images in emuStudio are:

- Operating system CP/M v2.2 and 3
- Altair DOS v1.0
- BASIC programming language in various versions

Some software manuals can be found e.g. [here][manuals]{:target="_blank"}.

The following subsections describe in short how to boot some of those systems, along with screenshots how it looks.

## Boot ROM

Booting operating systems on Altair requires special ROM image to be loaded in operating memory. The purpose of a boot
ROM is to load some blocks of data from a disk device (e.g. 88-DCDD) and then execute it. The code block is often called
a 'bootloader'.

A bootloader is device-specific, and often also disk format-specific. So e.g. for loading Altair 8" diskette with "simh"
formatting there should be used different bootloader than other diskette types and/or formatting. 

The following table lists available bootloaders in emuStudio:

|---
|Bootloader | Disk type | Diskette format | Description
|-|-|-|-
|`examples/altair8800/boot/dbl.bin` | 88-dcdd | Altair8800 8", simh formatted | Original 88-dcdd bootloader ROM, compatible with 8080 and Z80
|`examples/altair8800/boot/mdbl.bin`| 88-dcdd | Altair8800 8", simh formatted | Modified 88-dcdd bootloader ROM for computers supporting memory-banking using simh device
|---

The bootloaders are provided with source code which can be modified to user needs.

Boot ROM must be loaded into memory at address `0xFF00` (hexadecimal). It is safe to jump to this address manually when
operating system image file is mounted.

NOTE: All subsequent sections assume that the bootloader has been loaded in the operating memory.

## CP/M 2.2

During Altair8800 computer era, many operating systems, applications and programming languages have been developed. On
of the most known operating systems is CP/M. It was written by Gary Kildall from Digital Research, Inc. At first it was
mono-tasking and single-user operating system which didn't need more than 64kB of memory. Subsequent versions added
multi-user variants, and they were ported to 16-bit processors.

The combination of CP/M and computers with S-100 bus (8-bit computers sharing some similarities with Altair 8800) was
big "industry standard", widely spread in 70's up to 80's years of twentieth century. The operating system took the
burden of programming abilities from user, and this was one of the reasons why the demand for hardware and software was
rapidly increased.

Tested image has name `altcpm.dsk`. It can be downloaded at [this link][ceo-altair]{:target="_blank"}.

To run CP/M, please follow these steps:

1. Mount `altcpm.dsk` to drive `A:` in MITS 88-DCDD.
2. In emuStudio jump to location `0xFF00`
3. Before starting emulation, show ADM-3A terminal
4. Run the emulation

When the steps are completed, CP/M should start (an informational message appears) and command line prompt will be
displayed:

![Operating system CP/M 2.2]({{ site.baseurl}}/assets/altair8800/cpm22.gif){:style="max-width:737px"}

Command `dir` is working, `ls` is better `dir`. More information about CP/M commands can be found at
[this link][cpm22]{:target="_blank"}.

## CP/M 3

Steps for running CP/M 3 operating systems are not that different from CP/M 2. The disk image file is called `cpm3.dsk`
and can be downloaded at [this link][ps-altair]{:target="_blank"}. CP/M 3 came with two versions: banked and non-banked.
The image is the banked version of CP/M. Also, [simh][simh]{:target="_blank"} authors provided custom BIOS and custom
bootloader (`mdbl.bin`).

Manual of CP/M 3 can be found at [this link][cpm3manual]{:target="_blank"}. For more information about
[simh][simh]{:target="_blank"} version of Altair8800 and CP/M 3, click [here][simhmanual]{:target="_blank"}.

There are some requirements for the computer architecture, a bit different for CP/M 2.2.

### CPU

It is recommended to use Z80 version of the computer. CPU Intel 8080 will work for the operating system itself, but most
provided applications require Z80.

### Operating memory

Also, the operating memory needs to be set for memory banks. The following parameters were borrowed from 
[simh][simh]{:target="_blank"} and were tested:

- 8 memory banks
- common address `C000h`

### Boot ROM

There exist specific version of bootloader (modified probably by [simh][simh]{:target="_blank"} authors) to load CP/M
into banked memory. It is available in `examples/altair8800/boot/mdbl.bin` in your emuStudio installation. Before other
steps, please load this image into operating memory at address `0xFF00` (hexadecimal).

### Steps for booting CP/M 3

Specific steps how to boot CP/M 3 in emuStudio follow:

1. Mount `cpm3.dsk` to drive `A:` in MITS 88-DCDD.
2. In emuStudio jump to location `0xFF00`
3. Before starting emulation, show ADM-3A terminal
4. Run the emulation

The following image shows the look right after the boot:

![Operating system CP/M 3 (banked version)]({{ site.baseurl }}/assets/altair8800/cpm30.gif){:style="max-width:737px"}

## Altair DOS v1.0

Altair DOS can be downloaded from ["original software"][schorn-software]{:target="_blank"} (`altdos.dsk`, `altdos2.dsk`)
Steps for booting Altair DOS v1.0 follow:

1. Make sure 88-sio includes CPU port 0 for status channel and CPU port 1 for data channel.
2. Mount `altdos.dsk` to drive `A:` in MITS 88-DCDD (optionally, mount `altdos2.dsk` to drive `B:`).
3. In emuStudio jump to location `0xFF00`
4. Before starting emulation, show ADM-3A terminal
5. Run the emulation

The system will start asking some questions. According to the [Altair manual][altairmanual]{:target="_blank"}, answers
for emuStudio are:

- `MEMORY SIZE?` -> 64 or ENTER (if memory ROM is at `0xFFFF`)
- `INTERRUPTS` -> N or just ENTER
- `HIGHEST DISK NUMBER?` -> 0 (if only 1 disk is mounted)
- `HOW MANY DISK FILES?` -> 3
- `HOW MANY RANDOM FILES?` -> 2

Basic commands you can use are e.g. `MNT 0` - to mount the drive, and then `DIR 0` to list the files.

If you want AltairDOS being able to automatically detect how much memory is installed on system, it is possible. The
system does it by very nasty trick - testing if it can write to particular address
(ofcourse, maximum is 16-bits - i.e. 64K of memory). If the result is the same as it was before reading, it means that
it reached the "end of memory". But when it fails to detect the ROM, it fails to determine the size, too, and the output
will be `INSUFFICIENT MEMORY`.

The following image shows how it looks like:

![Operating system Altair DOS 1.0]({{ site.baseurl }}/assets/altair8800/altairdos.gif){:style="max-width:737px"}

## BASIC

In this section will be presented how to boot MITS BASIC version 4.1. There is possible to boot also other versions, but
the principle is always the same.

As it is written in [simh][simh]{:target="_blank"} manual: MITS BASIC 4.1 was the commonly used software for serious
users of the Altair computer. It is a powerful (but slow) BASIC with some extended commands to allow it to access and
manage the disk. There was no operating system it ran under.

After boot, you must mount the disk with `MOUNT 0`. Then, command `FILES` will show all files on the disk. To run a
file, run command `RUN "file"`. Manual can be found at [this link][basic]{:target="_blank"}.

Steps for booting BASIC follow:

1. Mount `mbasic.dsk` to drive `A:` in MITS 88-DCDD.
2. In emuStudio jump to location `0xFF00`
3. Before starting emulation, show ADM-3A terminal
4. Run the emulation

The following image shows the look right after the boot:

![Altair 8800 Basic 4.1]({{ site.baseurl }}/assets/altair8800/mbasic.gif){:style="max-width:737px"}


[schorn-os]: http://schorn.ch/altair_4.php
[schorn-os2]: https://schorn.ch/altair_5.php
[schorn-software]: https://schorn.ch/altair_3.php
[schorn-langs]: https://schorn.ch/altair_6.php
[schorn-office]: https://schorn.ch/altair_7.php
[schorn-games]: https://schorn.ch/altair_8.php
[ceo-altair]: http://simh.trailing-edge.com/kits/ceoaltair.zip
[ps-altair]: http://simh.trailing-edge.com/kits/psaltair.zip
[aclone]: http://altairclone.com/support.htm
[deramp]: https://deramp.com/downloads/altair/
[simh]: http://simh.trailing-edge.com/
[cpmtools]: http://www.autometer.de/unix4fun/z80pack/
[cpm22]: http://www.classiccmp.org/dunfield/r/cpm22.pdf
[cpm3manual]: http://www.cpm.z80.de/manuals/cpm3-usr.pdf
[simhmanual]: http://simh.trailing-edge.com/pdf/altairz80_doc.pdf
[altairmanual]: http://altairclone.com/downloads/manuals/Altair%20DOS%20User's%20Manual.pdf
[basic]: http://bitsavers.informatik.uni-stuttgart.de/pdf/mits/Altair_8800_BASIC_4.1_Reference_Jul77.pdf
[manuals]: http://altairclone.com/altair_manuals.htm
[88-dcdd-cpm]: {{ site.baseurl }}/altair8800/88-dcdd#experimental-cpm-support
