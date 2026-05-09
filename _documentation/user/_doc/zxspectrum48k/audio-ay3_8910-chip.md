---
layout: default
title: Device "audio-ay3_8910-chip"
nav_order: 6.5
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/audio-ay3_8910-chip
---

{% include analytics.html category="ZXSpectrum48K" %}

# AY-3-8910 Programmable Sound Generator

The `audio-ay3_8910-chip` plugin emulates the General Instrument AY-3-8910 Programmable Sound Generator (PSG). The
AY-3-8910 was not part of the original 48K ZX Spectrum, but was included in the 128K model and many third-party
add-ons. Many ZX Spectrum games and demos use the AY chip for music and sound effects.

The chip provides:

- **3 tone channels** (A, B, C) — square-wave generators with 12-bit period control
- **1 noise generator** — shared across all channels, with 5-bit period control
- **1 envelope generator** — shared across all channels, with 16-bit period and 8 envelope shapes
- **Volume control** — 4-bit per-channel amplitude or envelope-driven volume
- **Stereo output** — mixed to stereo PCM at 48 kHz sample rate

## I/O ports

The AY chip is accessed through two I/O ports using the ZX Spectrum 128K style wiring:

|---
| Port | Address | Description
|-|-|-
| Register select | `0xFFFD` | Write a register number (0–15) to select which register to read/write
| Data | `0xBFFD` | Read or write data to/from the currently selected register
|---

{: .info}
> Only the low byte of the port address (`0xFD`) is decoded by the CPU for device dispatch. The full 16-bit address
> is used by the chip to distinguish between register select and data ports.

## Registers

The AY-3-8910 has 16 registers (R0–R15):

|---
| Register | Name | Bits used | Description
|-|-|-|-
| R0 | Channel A fine tune | 7–0 | Low 8 bits of channel A tone period
| R1 | Channel A coarse tune | 3–0 | High 4 bits of channel A tone period
| R2 | Channel B fine tune | 7–0 | Low 8 bits of channel B tone period
| R3 | Channel B coarse tune | 3–0 | High 4 bits of channel B tone period
| R4 | Channel C fine tune | 7–0 | Low 8 bits of channel C tone period
| R5 | Channel C coarse tune | 3–0 | High 4 bits of channel C tone period
| R6 | Noise period | 4–0 | Noise generator period (0–31)
| R7 | Mixer control | 7–0 | Enable/disable tone and noise per channel (active low)
| R8 | Channel A amplitude | 4–0 | Bit 4 = envelope mode; bits 3–0 = fixed volume (0–15)
| R9 | Channel B amplitude | 4–0 | Bit 4 = envelope mode; bits 3–0 = fixed volume (0–15)
| R10 | Channel C amplitude | 4–0 | Bit 4 = envelope mode; bits 3–0 = fixed volume (0–15)
| R11 | Envelope fine tune | 7–0 | Low 8 bits of envelope period
| R12 | Envelope coarse tune | 7–0 | High 8 bits of envelope period
| R13 | Envelope shape | 3–0 | Envelope shape/cycle control
| R14 | I/O Port A | 7–0 | Not used in this emulation
| R15 | I/O Port B | 7–0 | Not used in this emulation
|---

### Mixer control (R7)

The mixer register controls which channels have tone and/or noise enabled. A **zero** bit enables the corresponding
source:

```
Bit:  7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
    |IOB|IOA| NC| NB| NA| TC| TB| TA|
    +---+---+---+---+---+---+---+---+
```

|---
| Bit | Name | Description
|-|-|-
| 0 | TA | Channel A tone enable (0 = enabled)
| 1 | TB | Channel B tone enable (0 = enabled)
| 2 | TC | Channel C tone enable (0 = enabled)
| 3 | NA | Channel A noise enable (0 = enabled)
| 4 | NB | Channel B noise enable (0 = enabled)
| 5 | NC | Channel C noise enable (0 = enabled)
| 6 | IOA | I/O port A direction (unused)
| 7 | IOB | I/O port B direction (unused)
|---

### Envelope shapes (R13)

Writing to R13 restarts the envelope generator. The shape is determined by bits 3–0:

```
Bit:  3      2         1         0
    +------+---------+---------+------+
    | CONT | ATTACK  |  ALT    | HOLD |
    +------+---------+---------+------+
```

|---
| Shape (R13) | Pattern | Description
|-|-|-
| 0–3 | `\___` | Decay, then silence
| 4–7 | `/___` | Attack, then silence
| 8 | `\\\\` | Repeated decay (sawtooth down)
| 9 | `\___` | Decay, then silence (same as 0–3)
| 10 | `\/\/` | Decay-attack triangle
| 11 | `\‾‾‾` | Decay, then hold high
| 12 | `////` | Repeated attack (sawtooth up)
| 13 | `/‾‾‾` | Attack, then hold high
| 14 | `/\/\` | Attack-decay triangle
| 15 | `/___` | Attack, then silence (same as 4–7)
|---

## GUI

The AY-3-8910 plugin provides a waveform monitor window that can be opened from the device list. It displays a live
PCM trace of the generated chip output.

The toolbar at the bottom provides:
- **Volume control** — a slider popup to adjust the AY output volume (0–100%)

## Audio output

The chip generates audio at a fixed sample rate of 48 kHz, stereo (2 channels). The three tone channels are mixed
equally and converted to 16-bit PCM. The output uses a common 16-step logarithmic amplitude approximation table to
model the real chip's non-linear DAC behavior.

The audio is driven by CPU T-state timing — the chip receives cycle notifications from the CPU and advances its
internal generators accordingly. This ensures accurate pitch regardless of emulation speed.

## Configuration

The AY-3-8910 plugin has no user-configurable settings. It automatically connects to the CPU context and uses the
CPU clock frequency for timing calculations.
