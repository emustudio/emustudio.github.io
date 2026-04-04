---
layout: default
title: Device "zxspectrum-bus"
nav_order: 4
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/zxspectrum-bus
---

{% include analytics.html category="ZXSpectrum48K" %}

# ZX Spectrum Bus

The `zxspectrum-bus` plugin acts as a proxy between the Z80 CPU, operating memory, and all ZX Spectrum peripheral
devices. It wraps the `byte-mem` memory plugin and the `z80-cpu` plugin, adding the timing behaviors that make the
ZX Spectrum unique:

- **Memory contention** — delays CPU access to addresses `0x4000`–`0x7FFF` when the ULA is fetching screen data
- **I/O port contention** — delays CPU I/O accesses depending on the port address
- **Floating bus** — reading an unattached port during a ULA fetch returns the data byte the ULA is currently reading
- **Interrupt duration** — holds the INT signal low for 32 T-states at each frame boundary

The bus has no GUI and no user-configurable settings.

## Memory contention

On the 48K ZX Spectrum, memory addresses `0x4000`–`0x7FFF` are shared between the CPU and the ULA. The ULA periodically
reads from this region to refresh the display, and during those reads the CPU must wait. This wait is called
*contention*.

Contention follows the pattern **6, 5, 4, 3, 2, 1, 0, 0** repeating across each screen line. The pattern starts at
T-state 14335 after the frame interrupt. Each screen line takes 224 T-states, of which 128 are contended (16 repetitions
of the 8-cycle pattern) and 96 are non-contended (border/retrace).

The contention window covers all 192 visible screen lines. Outside this window (top border, bottom border, and vertical
retrace) there is no contention.

{:.code-example}
```
Cycle #    Delay
-------    -----
14335       6
14336       5
14337       4
14338       3
14339       2
14340       1
14341       0 (no delay)
14342       0 (no delay)
14343       6 (pattern repeats)
...
```

## I/O port contention

I/O accesses are also subject to contention. The contention pattern depends on two factors:

1. Whether the **high byte** of the port address falls in the contended range (`0x40`–`0x7F`)
2. Whether **bit 0** of the port address is set or reset

|---
| High byte in `0x40`–`0x7F`? | Low bit | Contention pattern
|-|-|-
| No  | Reset (ULA port) | N:1, C:3
| No  | Set              | N:4
| Yes | Reset            | C:1, C:3
| Yes | Set              | C:1, C:1, C:1, C:1
|---

Where `N` means no contention applied, and `C` means the standard memory contention delay is applied at the current
T-state.

## Floating bus

When the CPU reads from an I/O port that has no device attached, the ZX Spectrum returns whatever value the ULA
happens to be driving on the data bus at that moment. During active ULA screen fetches, this is either a screen byte
or an attribute byte. Outside the fetch window, the bus is undriven and returns `0xFF`.

The floating bus follows the ULA's fetch pattern within each 8 T-state group:

|---
| Phase (within 8-cycle group) | Value returned
|-|-
| 0 | Screen byte (column N)
| 1 | Attribute byte (column N)
| 2 | Screen byte (column N+1)
| 3 | Attribute byte (column N+1)
| 4–7 | `0xFF` (no ULA fetch)
|---

## Frame timing

The ZX Spectrum 48K produces exactly 312 lines per frame, each taking 224 T-states:

|---
| Section | Lines | T-states
|-|-|-
| Upper border + vertical retrace | 64 | 14,336
| Visible display | 192 | 43,008
| Lower border + vertical retrace | 56 | 12,544
| **Total frame** | **312** | **69,888**
|---

At 3.5 MHz, this gives a frame rate of approximately **50.08 Hz**.

## Interrupts

At the start of each frame (every 69,888 T-states), the ULA generates a maskable interrupt (INT). The interrupt signal
is held low for **32 T-states**, which is a level-triggered interrupt. The Z80 CPU will respond to the interrupt as
long as interrupts are enabled (`EI`).

On a 48K Spectrum, the ULA does not place an IM 2 vector on the bus during the interrupt acknowledge cycle. The
floating bus value at frame boundary is `0xFF`, so IM 2 handlers typically see vector `0xFF`.


