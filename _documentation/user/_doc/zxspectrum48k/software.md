---
layout: default
title: Software and examples
nav_order: 7
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/software
---

{% include analytics.html category="ZXSpectrum48K" %}

# Software and examples

The ZX Spectrum 48K has an enormous library of software, much of which is available online in TAP and TZX tape image
formats. These files can be loaded into emuStudio using the [Audio Tape Player]({{ site.baseurl }}/zxspectrum48k/audiotape-player).

## Requirements

Before running any ZX Spectrum software, you need the **48K ROM image** loaded into memory at address `0x0000`. The ROM
contains the Sinclair BASIC interpreter and essential system routines (including the `BEEP` routine at `0x03B5` used
by many programs).

See the [Automation]({{ site.baseurl }}/zxspectrum48k/automation) page for details on configuring the ROM image.

## Bundled examples

emuStudio comes with two beeper demo programs in the `examples/zx-spectrum/` directory:

### `twinkle_beeper.asm`

A simple beeper example that plays the first phrase of "Twinkle Twinkle Little Star" (C C G G A A G). The program
is assembled to start at address `0x8000` and produces tones by toggling the EAR/MIC bits on port `0xFE`.

{:.code-example}
```
org 8000H

BEEPER_PORT equ 0FEH
BEEPER_ON   equ 10H
BEEPER_OFF  equ 08H

start:
    ld hl, melody
next_note:
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    ...
    call play_note
    ...
    jr next_note
finish:
    halt
```

### `zx_audio.asm`

A more complex beeper demo that plays the Imperial March and other melodies using the ROM `BEEP` routine at address
`0x03B5`. This example requires the 48K ROM to be loaded, as it calls the standard BEEP subroutine.

## Loading software from tape

Many original ZX Spectrum games and programs are available as TAP or TZX files. To load them:

1. Ensure the 48K ROM is loaded in memory
2. Start the emulation
3. Open the [Audio Tape Player]({{ site.baseurl }}/zxspectrum48k/audiotape-player)
4. Browse to the directory containing your tape files
5. Select and load the tape file
6. In the ZX Spectrum display, type `LOAD ""` and press ENTER
7. Click **Play** in the tape player
8. Wait for the program to load (you will see the characteristic loading stripes on screen)

## Online resources

ZX Spectrum software can be found at:

- [Speccy.cz][speccy]{:target="_blank"} — Czech ZX Spectrum archive with games and demos
- [World of Spectrum][wos]{:target="_blank"} — comprehensive archive with thousands of titles
- [Planet Emu][planetemu]{:target="_blank"} — ZX Spectrum tape images collection
- [Z80 Stealth][z80stealth]{:target="_blank"} — Z80 development tools and resources

## Z80 test suites

For testing the Z80 CPU accuracy, see the [Z80 CPU documentation]({{ site.baseurl }}/altair8800/z80-cpu#testing-the-cpu)
which describes how to run various Z80 test suites (Patrik Rak's z80test, ZXSpectrumNextTests, ZEXALL) in emuStudio.

The ZX Spectrum 48K emulation in emuStudio passes the following test suites:
- `z80full.tap` — complete Z80 instruction test (full pass)
- `z80flags.tap`, `z80doc.tap`, `z80docflags.tap` — documented instruction flag tests
- `z80ccf.tap`, `z80ccfscr.tap` — CCF instruction tests
- `z80memptr.tap` — MEMPTR/WZ register test
- `fusetest.tap` — FUSE emulator compatibility test
- `ulatest3.tap` — ULA timing test
- And many more (see [GitHub issue #314][issue314]{:target="_blank"} for the complete list)


[speccy]: https://cs.speccy.cz/
[wos]: https://worldofspectrum.org/
[planetemu]: https://www.planetemu.net/roms/sinclair-zx-spectrum-demos-tap
[z80stealth]: http://z80stealth.emuunlim.com/download.htm
[issue314]: https://github.com/emustudio/emuStudio/issues/314


