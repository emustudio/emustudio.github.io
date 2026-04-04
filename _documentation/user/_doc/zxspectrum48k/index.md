---
layout: default
title: ZX Spectrum 48K
description: "ZX Spectrum 48K emulator in emuStudio — emulate the classic Sinclair home computer with Zilog Z80 CPU, ULA chip, and audio tape support."
nav_order: 8
has_children: true
permalink: /zxspectrum48k/
---

{% include analytics.html category="ZXSpectrum48K" %}

# ZX Spectrum 48K

The [ZX Spectrum][zxspectrum]{:target="_blank"} is an 8-bit home computer developed by [Sinclair Research][sinclair]{:target="_blank"}
and released in the United Kingdom in 1982. Designed by Rick Dickinson with electronics by Richard Altwasser and
software by Steve Vickers, the Spectrum was one of the most popular home computers in the UK and many other countries
during the 1980s. As Wikipedia states:

> The Spectrum was among the first mainstream-audience home computers in the UK, similar in significance to the Commodore 64 in the USA.
>> Wikipedia, ZX Spectrum

![ZX Spectrum 48K]({{ site.baseurl }}/assets/zxspectrum48k/zxspectrum48k.png)

The machine featured the Zilog Z80A CPU running at 3.5 MHz, which was backward compatible with the Intel 8080 instruction
set. The heart of the system was a custom chip called the ULA (Uncommitted Logic Array), which handled video display,
keyboard scanning, audio output (a simple beeper), and cassette tape I/O - all in a single chip, keeping the cost
remarkably low.

The ZX Spectrum became famous for its enormous software library, especially games, and sparked a generation of bedroom
programmers who learned to code on the machine.

Basic configuration of ZX Spectrum 48K:

|---
| Item | Notes
|-|-
|Processor | Zilog Z80A
|Speed | 3.5 MHz
|RAM | 48 KB (addresses `0x4000` - `0xFFFF`)
|ROM | 16 KB (addresses `0x0000` - `0x3FFF`), containing Sinclair BASIC interpreter
|Video | 256×192 pixels with 32×24 colour attributes, 8-pixel wide border
|Sound | 1-bit beeper via ULA port `0xFE`
|Storage | Cassette tape (via EAR/MIC sockets)
|Keyboard | 40-key rubber keyboard (8 half-rows × 5 keys)
|---

## ZX Spectrum 48K for emuStudio

In emuStudio, ZX Spectrum 48K is emulated using the Zilog Z80 CPU, byte-based operating memory, and three specialized
device plugins:

- **zxspectrum-bus** — a proxy between CPU, memory, and devices implementing memory/I/O contention and floating bus
  behavior
- **zxspectrum-ula** — the ULA chip emulation providing video display, keyboard input, and beeper audio
- **audiotape-player** — a cassette tape deck emulation supporting TAP and TZX tape image files

The abstract schema for emuStudio:

![Abstract schema of ZX Spectrum 48K]({{ site.baseurl }}/assets/zxspectrum48k/zxspectrum48k-schema.png){:style="max-width:543"}

The assembler used for the ZX Spectrum is [`as-z80`]({{ site.baseurl }}/altair8800/as-z80), which is the same assembler
plugin used for the Altair8800 with Zilog Z80 CPU. The CPU plugin is also the same
[`z80-cpu`]({{ site.baseurl }}/altair8800/z80-cpu), and the memory is the same
[`byte-mem`]({{ site.baseurl }}/altair8800/byte-mem).

### Requirements

The ZX Spectrum 48K emulation requires the original 16 KB ROM image. The ROM image is copyrighted by Amstrad, who have
kindly given permission for it to be redistributed for emulation purposes. The ROM image must be configured in the
`byte-mem` plugin settings to be loaded at address `0x0000` at startup.

Each plugin is described in further sections.


[zxspectrum]: https://en.wikipedia.org/wiki/ZX_Spectrum
[sinclair]: https://en.wikipedia.org/wiki/Sinclair_Research


