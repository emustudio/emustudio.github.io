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

ZX Spectrum software in TAP and TZX format can be found at various online archives:

- [Speccy.cz][speccy]{:target="_blank"} — Czech and Slovak ZX Spectrum and Didaktik archive
- [World of Spectrum][wos]{:target="_blank"} — comprehensive ZX Spectrum archive
- [Planet Emu][planetemu]{:target="_blank"} — ZX Spectrum tape images


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

## Czech and Slovak scene

The Czech and Slovak Spectrum scene includes text adventures, arcade and puzzle games, demos, music, utilities,
and electronic magazines for the ZX Spectrum and compatible Didaktik computers. František Fuka
([Fuxoft][fuxoft]{:target="_blank"}) created games such as **Podraz 3** and **Tetris 2**; the archives also preserve
releases distributed by **Proxima Software** and the Slovak publisher **Ultrasoft**.

### Games to try

These downloads from the [Czech and Slovak archive][cs-games]{:target="_blank"} are **ZIP archives containing both TAP
and TZX files**. Extract the archive, then select a `.tap` or `.tzx` file in the Audio Tape Player.

|---
| Game | Author / publisher | Description | Download
|-|-|-|-
| Belegost | Cybexlab | Czech fantasy text adventure | [TAP + TZX (ZIP)][belegost]{:target="_blank"}
| Podraz 3 | Fuxoft | Czech text adventure | [TAP + TZX (ZIP)][podraz3]{:target="_blank"}
| Tetris 2 | Fuxoft / Ultrasoft | Falling-block puzzle game | [TAP + TZX (ZIP)][tetris2]{:target="_blank"}
| Quadrax | David Durčák, Marián Ferko / Ultrasoft | Puzzle game with two cooperating characters | [TAP + TZX (ZIP)][quadrax]{:target="_blank"}
| Towdie | DSA Computer Graphics / Ultrasoft | Slovak arcade adventure | [TAP + TZX (ZIP)][towdie]{:target="_blank"}
|---

### More software and scene resources

- [Czech and Slovak games][cs-games]{:target="_blank"} — individual downloads, often with manuals and links to game details.
- [Demos][cs-demos]{:target="_blank"}, [utilities][cs-programs]{:target="_blank"}, and [electronic magazines][cs-magazines]{:target="_blank"} — more local scene productions in the same archive.
- [Proxima Software collection][proxima]{:target="_blank"} — TAP and TZX collections, cassette covers, and manuals.
- [Ultrasoft collection][ultrasoft]{:target="_blank"} — original tape images in TZX and separate TAP versions with the tape protection removed.
- [English translations][cs-english]{:target="_blank"} — translated Czech and Slovak games, including Towdie and selected text adventures.
- [Spectristi][spectristi]{:target="_blank"} — news aggregator for Czech and Slovak Spectrum websites.

Check each release's hardware requirements: these archives also contain software for 128K machines, AY sound,
and disk interfaces. For the virtual computer documented here, choose a **48K-compatible tape release** and follow
the loading steps above.

## Online resources

ZX Spectrum software can be found at:

- [Speccy.cz][speccy]{:target="_blank"} — Czech and Slovak ZX Spectrum archive with games and demos
- [World of Spectrum][wos]{:target="_blank"} — comprehensive archive with thousands of titles
- [Planet Emu][planetemu]{:target="_blank"} — ZX Spectrum tape images collection
- [Z80 Stealth][z80stealth]{:target="_blank"} — Z80 development tools and resources

## Z80 test suites

For testing the Z80 CPU accuracy, see the [Z80 CPU documentation]({{ site.baseurl }}/altair8800/z80-cpu#testing-the-cpu)
which describes how to run various Z80 test suites (Patrik Rak's z80test, ZXSpectrumNextTests, ZEXALL) in emuStudio.

The following table lists known Z80 test suites and their results when run in the ZX Spectrum 48K emulation:

### Patrik Rak's z80test

|---
| Test file | Description | Result
|-|-|-
| `z80full.tap` | Complete Z80 instruction test | ✅ PASS
| `z80flags.tap` | Documented instruction flag test | ✅ PASS
| `z80doc.tap` | Documented instruction test | ✅ PASS
| `z80docflags.tap` | Documented instruction flag variants | ✅ PASS
| `z80ccf.tap` | CCF instruction test | ✅ PASS
| `z80ccfscr.tap` | CCF instruction screen output test | ✅ PASS
| `z80memptr.tap` | MEMPTR/WZ register test | ✅ PASS
|---

### FUSE emulator tests

|---
| Test file | Description | Result
|-|-|-
| `fusetest.tap` | FUSE emulator compatibility test | ✅ PASS
|---

### Timing tests 48K

|---
| Test file | Description | Result
|-|-|-
| [Timing tests 48K][timing48k]{:target="_blank"} | Instruction timing / T-state accuracy test for 48K model | ✅ PASS
|---

### ULA tests

|---
| Test file | Description | Result
|-|-|-
| `ulatest3.tap` | ULA timing and contention test | ✅ PASS
|---

### ZXSpectrumNextTests

|---
| Test file | Description | Result
|-|-|-
| [Z80BlockInstructionFlags][nexttest-block]{:target="_blank"} | Block instruction flag behavior tests (LDI/LDIR/CPI/CPIR etc.) | ✅ PASS
| [Z80CcfScfOutcomeStability][nexttest-ccfscf]{:target="_blank"} | CCF/SCF flag outcome stability tests | ✅ PASS
| [Z80IntSkip][nexttest-intskip]{:target="_blank"} | Interrupt skip after EI instruction test | ✅ PASS
|---


[speccy]: https://cs.speccy.cz/
[wos]: https://worldofspectrum.org/
[planetemu]: https://www.planetemu.net/roms/sinclair-zx-spectrum-demos-tap
[fuxoft]: https://www.fuxoft.cz/tvorba.htm
[cs-games]: https://cs.speccy.cz/?scn=1
[cs-programs]: https://cs.speccy.cz/?scn=2
[cs-demos]: https://cs.speccy.cz/?scn=3
[cs-magazines]: https://cs.speccy.cz/?scn=4
[belegost]: https://cs.speccy.cz/games/Textovky/belegost.zip
[podraz3]: https://cs.speccy.cz/games/Textovky/podraz3.zip
[tetris2]: https://cs.speccy.cz/games/Tetris2.zip
[quadrax]: https://cs.speccy.cz/games/Quadrax.zip
[towdie]: https://cs.speccy.cz/games/Towdie.zip
[proxima]: https://www.zx-spectrum.cz/index.php?article_id=proxima.php&cat1=4&cat2=2
[ultrasoft]: https://www.zx-spectrum.cz/index.php?article_id=ultrasoft3.php&cat1=4&cat2=2
[cs-english]: https://www.zx-spectrum.cz/index.php?article_id=translation.php&cat1=4&cat2=2&lang=en
[spectristi]: https://spectristi.i-logout.cz/
[z80stealth]: http://z80stealth.emuunlim.com/download.htm
[timing48k]: https://zxspectrum4.net/op_timing.php
[nexttest-block]: https://github.com/MrKWatkins/ZXSpectrumNextTests/tree/develop/Tests/ZX48_ZX128/Z80BlockInstructionFlags
[nexttest-ccfscf]: https://github.com/MrKWatkins/ZXSpectrumNextTests/tree/develop/Tests/ZX48_ZX128/Z80CcfScfOutcomeStability
[nexttest-intskip]: https://github.com/MrKWatkins/ZXSpectrumNextTests/tree/develop/Tests/ZX48_ZX128/Z80IntSkip


