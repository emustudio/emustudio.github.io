---
layout: default
title: Memory "byte-mem"
nav_order: 3
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/byte-mem
---

{% include analytics.html category="ZXSpectrum48K" %}

# Operating memory "byte-mem"

The ZX Spectrum 48K uses the same operating memory plugin as the [MITS Altair8800]({{ site.baseurl }}/altair8800/byte-mem).
Please refer to the [byte-mem documentation]({{ site.baseurl }}/altair8800/byte-mem) for the complete memory reference,
including GUI overview, memory settings, ROM areas, bank switching, and the configuration file format.

## ZX Spectrum memory map

The ZX Spectrum 48K has a total of 64 KB address space organized as follows:

|---
| Address range | Size | Description
|-|-|-
| `0x0000` – `0x3FFF` | 16 KB | ROM (Sinclair BASIC interpreter). Must be loaded as a memory image at startup.
| `0x4000` – `0x57FF` | 6 KB | Screen bitmap memory (256×192 pixels)
| `0x5800` – `0x5AFF` | 768 bytes | Screen attribute memory (32×24 colour cells)
| `0x5B00` – `0xFFFF` | ~41 KB | Free RAM (used by BASIC, user programs, stack, etc.)
|---

### ROM image setup

The 16 KB ROM image must be configured to load at address `0x0000` at startup. In the `byte-mem` settings, configure:

|---
| Setting | Value | Description
|-|-|-
| `imageName0` | Path to ROM file (e.g. `examples/zxspectrum-48k/48.rom`) | The 16 KB ROM binary file
| `imageAddress0` | `0` | Load address (start of memory)
| `imageBank0` | `0` | Memory bank (default)
|---

Optionally, you can also set up a ROM area (`ROMfrom0 = 0`, `ROMto0 = 16383`) to prevent programs from accidentally
overwriting the ROM contents, though this is not strictly required for most software.

### Contended memory

Memory addresses `0x4000` – `0x7FFF` are subject to contention by the ULA. This is handled automatically by the
[zxspectrum-bus]({{ site.baseurl }}/zxspectrum48k/zxspectrum-bus) plugin and is transparent to the user.


