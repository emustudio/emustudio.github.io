---
layout: default
title: Device "zxspectrum-ula"
nav_order: 5
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/zxspectrum-ula
---

{% include analytics.html category="ZXSpectrum48K" %}

# ZX Spectrum ULA

The `zxspectrum-ula` plugin emulates the Uncommitted Logic Array (ULA) chip, which is the central mediator of the
ZX Spectrum's host-to-emulator interaction. The ULA handles:

- **Video display** — renders the 256×192 pixel bitmap with colour attributes and border
- **Keyboard** — reads the 40-key keyboard matrix
- **Audio (beeper)** — produces 1-bit audio output via the EAR and MIC lines
- **Video recording** — captures emulation to MP4 video files

All ULA functions are accessed through a single I/O port: **port `0xFE`** (254 decimal).

## Display window

When the emulation is running, the ZX Spectrum display can be opened from the device list. It shows the 256×192 pixel
screen with border, an on-screen keyboard overlay, and a toolbar with controls.

![ZX Spectrum ULA display]({{ site.baseurl }}/assets/zxspectrum48k/zxspectrum-ula.png)

{: .list}
| The display window shows the ZX Spectrum screen output. The border colour changes based on the value written to port `0xFE`.

### Toolbar

The toolbar at the bottom of the display window provides controls for keyboard overlay, volume, and video recording:

![ZX Spectrum ULA toolbar]({{ site.baseurl }}/assets/zxspectrum48k/zxspectrum-ula-toolbar.png)

{: .list}
| <span class="circle">1</span> | Keyboard opacity control — shows a slider popup to adjust the on-screen keyboard overlay transparency (0–100%)
| <span class="circle">2</span> | Volume control — shows a slider popup to adjust the beeper volume (0–100%)
| <span class="circle">3</span> | Record — starts/stops video recording. When recording is started, the button changes to a stop icon. When stopped, a file dialog appears to save the MP4 file.

### On-screen keyboard

The ZX Spectrum's 40-key rubber keyboard layout is rendered as an overlay on the display canvas. The keyboard can
be made visible by adjusting the keyboard opacity slider in the toolbar.

![ZX Spectrum on-screen keyboard]({{ site.baseurl }}/assets/zxspectrum48k/zxspectrum-ula-keyboard.png)

The on-screen keyboard is interactive — keys can be clicked with the mouse to simulate key presses and releases.
When the keyboard overlay opacity is set to 0%, mouse interaction is disabled.

## Port `0xFE` — Write (output)

Writing to port `0xFE` controls the border colour and audio output:

```
Bit:  7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
    |   |   |   | E | M |   Border  |
    +---+---+---+---+---+---+---+---+
```

|---
| Bits | Name | Description
|-|-|-
| 0–2 | Border | Border colour (0–7, same palette as INK/PAPER)
| 3 | MIC | MIC output (directly active-low for beeper)
| 4 | EAR | EAR output (speaker/internal audio)
| 5–7 | — | Unused
|---

## Port `0xFE` — Read (input)

Reading from port `0xFE` returns the keyboard state. The high byte of the port address selects which keyboard
half-row(s) to read. A **zero** in bits 0–4 means the corresponding key is **pressed**.

|---
| Port address | Keys (bit 0 → bit 4)
|-|-
| `0xFEFE` | SHIFT, Z, X, C, V
| `0xFDFE` | A, S, D, F, G
| `0xFBFE` | Q, W, E, R, T
| `0xF7FE` | 1, 2, 3, 4, 5
| `0xEFFE` | 0, 9, 8, 7, 6
| `0xDFFE` | P, O, I, U, Y
| `0xBFFE` | ENTER, L, K, J, H
| `0x7FFE` | SPACE, SYMBOL SHIFT, M, N, B
|---

If more than one address line is made low, the result is the logical AND of all selected half-rows. Bit 6 reflects
the EAR input from the tape (active high).

### Host keyboard mapping

The host keyboard is mapped to the ZX Spectrum keyboard as follows:

- **Host SHIFT + key** → ZX Spectrum CAPS SHIFT + key
- **Host CTRL or ALT + key** → ZX Spectrum SYMBOL SHIFT + key
- **Host BACKSPACE or DELETE** → ZX Spectrum DELETE (CAPS SHIFT + 0)
- **Plain key** → ZX Spectrum key directly

## Screen memory layout

The ZX Spectrum's screen memory starts at address `0x4000` and is divided into two sections:

### Bitmap memory (`0x4000`–`0x57FF`)

The 256×192 pixel display is stored as a bitmap at addresses `0x4000` to `0x57FF` (6,144 bytes). Each byte represents
8 horizontal pixels.

The memory layout is not linear — it is interleaved in a characteristic pattern:

```
Address bits:  15  14  13  12  11  10   9   8   7   6   5   4   3   2   1   0
               0   1   0   Y7  Y6  Y2  Y1  Y0  Y5  Y4  Y3  X4  X3  X2  X1  X0
```

Where Y7–Y0 represent the pixel row (0–191) and X4–X0 represent the byte column (0–31).

The screen is divided into three "thirds" of 64 lines each. Within each third, lines are grouped by their low 3 bits
first, then by the next 3 bits. This interleaving was designed to simplify the ULA hardware.

### Attribute memory (`0x5800`–`0x5AFF`)

The colour attributes overlay the bitmap and are arranged linearly from left to right, top to bottom. Each attribute
byte controls the colour of an 8×8 pixel character cell:

```
Bit:  7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
    | F | B | P2| P1| P0| I2| I1| I0|
    +---+---+---+---+---+---+---+---+
```

|---
| Bits | Name | Description
|-|-|-
| 0–2 | INK (I0–I2) | Foreground colour (0–7)
| 3–5 | PAPER (P0–P2) | Background colour (0–7)
| 6 | BRIGHT (B) | Brightness flag (makes colours brighter)
| 7 | FLASH (F) | Flash flag (swaps INK and PAPER periodically)
|---

The colour palette (indices 0–7):

|---
| Index | Normal | Bright
|-|-|-
| 0 | Black | Black
| 1 | Blue | Bright Blue
| 2 | Red | Bright Red
| 3 | Magenta | Bright Magenta
| 4 | Green | Bright Green
| 5 | Cyan | Bright Cyan
| 6 | Yellow | Bright Yellow
| 7 | White | Bright White
|---

### FLASH effect

The FLASH attribute causes the INK and PAPER colours of the affected character cell to swap every 16 frames
(approximately every 0.32 seconds). A full normal→inverted→normal cycle takes 32 frames (~0.64 seconds).

## Audio (beeper)

The ZX Spectrum produces sound using a 1-bit beeper, controlled by bits 3 and 4 of port `0xFE`. On the real hardware
(Issue 3 board), the EAR and MIC outputs share an analog node through resistors, producing four observable voltage
levels:

|---
| EAR (bit 4) | MIC (bit 3) | Voltage
|-|-|-
| 0 | 0 (high) | 0.34 V
| 0 | 1 (low)  | 0.66 V
| 1 | 0 (high) | 3.56 V
| 1 | 1 (low)  | 3.70 V
|---

The emulator models these Issue 3 voltage levels by centering them and scaling into 16-bit PCM audio. The output
is resampled to 48 kHz stereo using fixed-point time accumulation to maintain long-term timing accuracy.

When a tape is playing, the tape input signal is mixed into the beeper output at a reduced amplitude (10% of peak)
to reproduce the familiar loading sounds.

### Volume control

The beeper volume can be adjusted from 0% to 100% using the volume slider in the toolbar. By default, the volume is
set to 100%.

## Video recording

The display window supports recording the emulation to an MP4 video file with audio. To start recording:

1. Click the **Record** button (red circle icon) in the toolbar
2. The button changes to a **Stop** icon while recording
3. Click the button again to stop recording
4. A file save dialog appears to choose the output MP4 file location

The recording captures both the video frames and the beeper audio in sync.


