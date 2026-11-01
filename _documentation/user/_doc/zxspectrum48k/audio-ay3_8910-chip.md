---
layout: default
title: Device "audio-ay3_8910-chip"
nav_order: 6
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/audio-ay3_8910-chip
---

{% include analytics.html category="ZXSpectrum48K" %}

# AY-3-8910 Programmable Sound Generator

## Introduction

The General Instrument **AY-3-8910** is a Programmable Sound Generator (PSG) that
generates three independent tones, noise, and volume envelopes under software control. Once its registers are
programmed, the chip continues producing sound while the CPU performs other work. This makes it useful for
music and sound effects in games and demos.

![General Instrument AY-3-8910 sound chip in its 40-pin package]({{ site.baseurl }}/assets/zxspectrum48k/ay-3-8910-chip.jpg){: width="392" }

*AY-3-8910 chip. Photo by [Joho345, via Wikimedia Commons][hardware-photo]{:target="_blank"} (public domain).*

The original 48K ZX Spectrum had a beeper; AY sound required an expansion interface. The Spectrum 128K included
the related **AY-3-8912**, which has the same sound-generation features in a smaller package with one fewer I/O
port. The `audio-ay3_8910-chip` plugin adds AY sound to the emulated 48K computer using Spectrum 128K-style I/O ports.

The plugin provides:

- **3 tone channels** (A, B, C) — square-wave generators with 12-bit period control
- **1 noise generator** — shared across all channels, with 5-bit period control
- **1 envelope generator** — shared across all channels, with 16-bit period and 8 envelope shapes
- **Volume control** — 4-bit per-channel amplitude or envelope-driven volume
- **Stereo output** — mixed to stereo PCM at 48 kHz sample rate

[datasheet]: https://amigan.yatho.com/AY-3-8910.pdf
[hardware-photo]: https://commons.wikimedia.org/wiki/File:AY-3-8910.jpg

### Original manual

[General Instrument AY-3-8910/8912/8913 datasheet (PDF)][datasheet]{:target="_blank"} covers the chip's pins,
registers, sound generation, and electrical characteristics.

## I/O ports

The AY chip is accessed through two I/O ports using the ZX Spectrum 128K style wiring:

|---
| Port | Address | Description
|-|-|-
| Register select/read | `0xFFFD` | Write a register number (0–15); read the selected register's data
| Data write | `0xBFFD` | Write data to the currently selected register; reads return `FFh`
|---

{: .info}
> Only the low byte of the port address (`0xFD`) is decoded by the CPU for device dispatch. The full 16-bit address
> is passed to the chip, which decodes address bits A15, A14, and A1. On the attached `FDh` port, `port & C002h`
> equal to `C000h` selects or reads a register, and `8000h` writes register data. Other address bits are ignored.
> For example, `FDFDh` selects or reads a register and `BDFDh` writes its data. Addresses with a different low byte
> are not dispatched to this device by the bundled CPU wiring.

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

![AY-3-8910 waveform monitor showing generated chip output]({{ site.baseurl }}/assets/zxspectrum48k/ay-waveform.png){: style="max-width: 720px; width: 100%;" }

Click **AY output volume** in the bottom toolbar to adjust the output volume (0–100%).

## Audio output

The chip generates audio at a fixed sample rate of 48 kHz, stereo (2 channels). The three tone channels are mixed
equally and converted to 16-bit PCM. The output uses a common 16-step logarithmic amplitude approximation table to
model the real chip's non-linear DAC behavior.

The audio is driven by CPU T-state timing — the chip receives cycle notifications from the CPU and advances its
internal generators accordingly. This ensures accurate pitch regardless of emulation speed.

The AY device opens a host audio output during initialization, including in `--no-gui` mode. If that output is
unavailable, initialization reports **AY-3-8910 tone output is unavailable**. For a silent headless run or a host without
audio output, omit this optional device from the computer configuration.

Tone, noise, and envelope generators use the CPU clock in hertz and keep their divider state between audio buffers.
Register reads return data through the register-select address (`FFFDh`) and its decoded aliases; reads of the
data-write address return `FFh`. Writing R13 restarts all envelope shapes with their documented continue, attack,
alternate, and hold behavior.
