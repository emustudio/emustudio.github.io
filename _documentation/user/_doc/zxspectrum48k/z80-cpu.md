---
layout: default
title: CPU "z80-cpu"
nav_order: 2
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/z80-cpu
---

{% include analytics.html category="ZXSpectrum48K" %}

# Zilog Z80 CPU emulator

The ZX Spectrum 48K uses the same Z80 CPU plugin as the [MITS Altair8800]({{ site.baseurl }}/altair8800/z80-cpu).
Please refer to the [z80-cpu documentation]({{ site.baseurl }}/altair8800/z80-cpu) for the complete CPU reference,
including instruction dumping, configuration, and testing.

## ZX Spectrum enhancements

For the ZX Spectrum 48K emulation, the Z80 CPU plugin includes several enhancements beyond the base Altair8800
implementation:

- **T-state precise clock** — each instruction consumes the exact number of T-states as documented in the Z80 manual,
  which is critical for correct ULA timing and contention
- **Level-triggered interrupts** — the ULA holds INT low for 32 T-states rather than using an edge-triggered queue;
  the CPU correctly models this behavior
- **Interrupt skip window** — after `EI`, the next instruction is not interrupted (as per Z80 specification)
- **DD/FD prefix chains** — repeated IX/IY prefixes consume 4 T-states each without executing, matching real hardware
- **Memory contention support** — the CPU cooperates with the `zxspectrum-bus` plugin for adding contention delays
  during memory and I/O access

## Configuration file

|---
|Name | Default value | Valid values | Description
|-|-|-|-
|`printCode`       | false | true / false | Whether to dump executed instructions to console
|`printCodeUseCache`| false | true / false | Use cache to avoid dumping repeated blocks
|`frequency_khz` | 3500 | > 0 | CPU frequency in kHz (3500 for ZX Spectrum 48K)
|---

The standard ZX Spectrum 48K CPU frequency is **3500 kHz** (3.5 MHz).


