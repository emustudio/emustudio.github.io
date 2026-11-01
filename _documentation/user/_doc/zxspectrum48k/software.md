---
layout: default
title: Software and examples
nav_order: 1
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

To use BASIC or programs that call ROM routines, load the **48K ROM image** into memory at address `0x0000`. The ROM
contains the Sinclair BASIC interpreter and essential system routines (including the `BEEP` routine at `0x03B5` used
by many programs).

See the [Automation]({{ site.baseurl }}/zxspectrum48k/automation) page for details on configuring the ROM image.

## Bundled examples

emuStudio includes four programs in `examples/zx-spectrum/`. Assemble them with `as-z80`; they start at `0x8000`.
In the editor, **Save & Compile source file** loads the program and resets the CPU to its entry point. Open the ULA display,
then click **Run**. Stop execution before compiling another example. Click **Stop** when you finish a program that keeps running.

### `border_stripes.asm`

A visual first example: fills the bitmap with alternating vertical stripes, sets bright yellow ink on blue paper,
and selects a blue border. It writes directly to display memory and does not call ROM routines.

### `ay_ode_to_joy.asm`

Plays a three-voice arrangement of the opening of “Ode to Joy”. It requires the `audio-ay3_8910-chip` device and
a working host audio output. Use the supplied `config/ZxSpectrum48K.toml` (**ZX Spectrum 48K + AY**). It uses ports `0xFFFD` and `0xBFFD`
and does not call ROM routines.

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

The following suites exercise CPU behavior, interrupts, memory protection, floating bus, and Spectrum timing.
The results below were measured on **2026-10-11**, using rebuilt **emuStudio 0.50-SNAPSHOT** plugins after the [test-suite fixes][suite-fixes]{:target="_blank"},
the 48K ROM, a 3.5 MHz Z80, and a 69,888 T-state frame. The setup has AY sound and **no Kempston joystick**.

Tests ran in a headless harness with the CPU, Spectrum bus, ULA, and AY plugins. ROM tape loading was
accelerated by copying tape blocks; these results check execution after loading, **not TAP/TZX playback**.
Explicit test results and published reference screens determine PASS / FAIL; loading a program alone is insufficient.
For continuously running diagnostics, the notes identify the sampled output. **SKIP** means required hardware is absent.

### Patrik Rak's z80test

See the [upstream test descriptions][z80test]{:target="_blank"}. Download the [v1.2a ZIP][z80test-download]{:target="_blank"}
and extract the TAP files. The NEC/ST-specific SCF/CCF cases are expected skips for the Zilog CPU model.

|---
| Test file | Description | PASS / FAIL | Observed result
|-|-|-|-
| `z80full.tap` | Registers and all flags, including undocumented flags | **PASS** | All tests passed; v1.2a also saved locally as `z80full-1.2a.tap`
| `z80flags.tap` | All flags; registers ignored | **PASS** | All tests passed
| `z80doc.tap` | Registers and documented flags | **PASS** | All tests passed
| `z80docflags.tap` | Documented flags; registers ignored | **PASS** | All tests passed
| `z80ccf.tap` | Flags after CCF following each tested instruction | **PASS** | All tests passed
| `z80ccfscr.tap` | Visual CCF flag pattern | **PASS** | Matches the upstream Zilog reference pattern
| `z80memptr.tap` | Flags after BIT n,(HL), probing MEMPTR behavior | **PASS** | All tests passed
|---

### CPD-Test

[CPD-Test][cpd-test]{:target="_blank"} by Michael Sapach checks how instructions change the hidden **MEMPTR** register.
Extract the [TAP ZIP][cpd-test-tap]{:target="_blank"} or [TZX ZIP][cpd-test-tzx]{:target="_blank"} before loading.

|---
| Test file | Description | PASS / FAIL | Observed result
|-|-|-|-
| `cpd-test1250429.tap` / `.tzx` | CPD-Test v0.7b (2025-04-29) | **PASS** | `Failed 00 from 97 tests`; two 128K-only cases skipped; TAP payload tested
|---

### FUSE emulator tests

|---
| Test file | Description / download | PASS / FAIL | Observed result
|-|-|-|-
| `fusetest.tap` | [FUSE compatibility tests (ZIP)][fusetest-download]{:target="_blank"} | **PASS** | Seven checks passed; three model-specific checks skipped; contention offset `0x08`
|---

### Timing and ULA tests

The [48K timing suite][timing48k]{:target="_blank"} has a menu: leave the test number blank and press ENTER to run all.
Use the **Sane Loader TAP** below for the tested revision. For visual tests, compare the output with the reference images
in the [Spectrum test catalog][spectrum-tests]{:target="_blank"}.

|---
| Test file | Description / download | PASS / FAIL | Observed result
|-|-|-|-
| `minfo.tap` | [Machine timing information (2011)][minfo-download]{:target="_blank"} | **PASS** | Frame `69888`; EI acts as a prefix; INT pulse `32` T-states
| `timing48k-sane.tap` | [ZX Spectrum Timing Tests 48K v1.0, Sane Loader (2025)][timing48k-download]{:target="_blank"} | **PASS** | Early timings detected; `All Tests Complete 100% Pass`
| `timing.tap` | [Patrik Rak's Timing Test v0.3 (ZIP)][rak-timing-download]{:target="_blank"} | **PASS** | Tests 0–7 match the 48K early-timing references, including I/R contention; test 8 is 128K-only
| `ulatest3.tap` | [ULA Test 3 (2011)][ulatest3-download]{:target="_blank"} | **PASS** | Default `FFFF` / `FFFE` scan: rows 14329–14473 match the 48K reference data
| `ula48-simple.tap` | [ULA 48 Simple Test (2012)][ula48-download]{:target="_blank"} | **PASS** | Captured display and border match the Zilog NMOS reference
| `nec48-contention.tap` | [48K NEC Contention Test Suite (2008)][nec48-download]{:target="_blank"} | **PASS** | All six menu tests match their published result screens
| `float48k.tap` | [Float48K (2008)][float48-download]{:target="_blank"} | **PASS** | Sampled first display-line fetch window: first driven byte at T-state 14338; alternating bitmap/attribute bytes and undriven `255`
| `halt-contention.tap` | [HALT Contention Test (2021)][halt-download]{:target="_blank"} | **PASS** | `7FFE:60`, `7FFF:60`, `8000:61`, `8001:61` match reference
| `ldir-lddr.tap` | [LDIR-LDDR contention (2021)][ldir-download]{:target="_blank"} | **PASS** | Captured display and border transition match reference
| `otir-otdr.tap` | [OTIR-OTDR contention (2009)][otir-download]{:target="_blank"} | **PASS** | Captured display and border transition match reference
| `io-contend.tap` | [I/O contention (2021)][io-download]{:target="_blank"} | **PASS** | Result screen and border match reference
| `ir-contention.tap` | [I/R refresh contention (2023)][ir-download]{:target="_blank"} | **PASS** | Captured display and border bands match the 48K reference (snow disabled)
|---

### ZXSpectrumNextTests

These [block flag][nexttest-block]{:target="_blank"}, [CCF/SCF stability][nexttest-ccfscf]{:target="_blank"}, and
[interrupt prefix][nexttest-intskip]{:target="_blank"} tests run on the 48K model.

|---
| Test file | Description | PASS / FAIL | Observed result
|-|-|-|-
| [`z80bltst.tap`][next-block-tap]{:target="_blank"} | Z80BlockInstructionFlags v5.0 | **PASS** | Executed flag checks and HF-vs-B log pass; first INIR/INDR cases skip because Kempston port `0x1F` is unavailable
| [`ccffrm.tap`][next-ccfscf-tap]{:target="_blank"} | Z80CcfScfOutcomeStability v1.1 | **PASS** | SCF and CCF runs show `No error` in both sampled address ranges
| [`int_skip.tap`][next-intskip-tap]{:target="_blank"} | Z80IntSkip v4.1 | **PASS** | Two ISR entries per INT; DD/FD/EI/DI inhibit interrupts; SCF+CCF allows them; IFF2 checks correct
|---

`int_skip.tap` intentionally stays in its final loop with the result displayed. This is normal completion.
The block flag suite's `unexpected IN 1F,FE,FF` messages identify skipped Kempston-dependent cases.

### Additional CPU, interrupt, and memory tests

|---
| Test file | Description / download | PASS / FAIL | Observed result
|-|-|-|-
| `zexall.tap` | [ZEXALL for Spectrum (2018)][zexall-download]{:target="_blank"} | **PASS** | All 67 instruction groups report OK; verified in independent groups
| `zexdoc.tap` | [ZEXDOC for Spectrum (2018)][zexdoc-download]{:target="_blank"} | **PASS** | All 67 instruction groups report OK with documented flag masks; verified in independent groups
| `z80tests.tap` | [Mark Woodmass's Z80 Test Suite (2008)][woodmass-download]{:target="_blank"} | **PASS** | All flags-menu CRCs and MEMPTR-menu checks pass
| `z80-xcf-flavor.tap` | [Z80 XCF Flavor v1.5 (archive)][xcf-download]{:target="_blank"} | **PASS** | Detects Zilog SCF/CCF flavor; six patterns match that column
| `z80type.tap` | [Z80 processor type detector (2024)][z80type-download]{:target="_blank"} | **PASS** | Detects Zilog Z80 / Z08400 or similar NMOS CPU
| `interrupt-retrigger.tap` | [Interrupt Retriggering Test (2021)][retrigger-download]{:target="_blank"} | **PASS** | `Your emulator is good`
| `ei48k.tap` | [EI48K (2021)][ei-download]{:target="_blank"} | **PASS** | `EI at INT: 110E`; `EI/HALT at INT: 00`; matches reference
| `prefixes.tap` | [Prefixes (2022)][prefixes-download]{:target="_blank"} | **PASS** | Captured display and yellow border stripe match reference
| `Rom_Boundary_Test.TAP` | [ROM Boundary Test (2025, ZIP)][rom-boundary-download]{:target="_blank"} | **PASS** | Both `3fff-4000` and `ffff-0000` pass using the installed byte-memory plugin with protected ROM
| `ini-hc.tap` | [INI H and C Flags Clearing Test (2024)][ini-hc-download]{:target="_blank"} | **SKIP** | Requires Kempston joystick; without it the program reports uncleared H/C flags
|---

The [Spectrum test catalog][spectrum-tests]{:target="_blank"} and [Z80 test catalog][cpu-tests]{:target="_blank"}
contain more diagnostics and historical revisions. Choose releases marked for 48K; 128K paging and hardware-specific
tests need their corresponding devices. Downloaded local filenames may be shorter than archive filenames.


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

[z80test]: https://github.com/raxoft/z80test
[cpd-test]: https://github.com/redcode/Z80/wiki/CPD-Test
[cpd-test-tzx]: https://zxe.io/depot/software/ZX%20Spectrum/CPD-Test%20v0.7b%20%282025-04-29%29%28Sapach,%20Michael%29%28TZX%29%5B%21%5D.zip

[spectrum-tests]: https://github.com/redcode/ZXSpectrum/wiki/Tests
[cpu-tests]: https://github.com/redcode/Z80/wiki/Tests
[z80test-download]: https://zxe.io/depot/software/ZX%20Spectrum/Zilog%20Z80%20CPU%20Test%20Suite%20v1.2a%20%282023-12-02%29%28Rak%2C%20Patrik%29%5B%21%5D.zip
[cpd-test-tap]: https://zxe.io/depot/software/ZX%20Spectrum/CPD-Test%20v0.7b%20%282025-04-29%29%28Sapach%2C%20Michael%29%28TAP%29%5B%21%5D.zip
[fusetest-download]: https://zxe.io/depot/software/ZX%20Spectrum/Fuse%20Test%20%282008-03-28%29%28Kendall%2C%20Philip%29%5B%21%5D.zip
[timing48k-download]: https://zxe.io/depot/software/ZX%20Spectrum/ZX%20Spectrum%20Timing%20Tests%20-%2048K%20v1.0%20%282025-05-05%29%28Woodmass%2C%20Mark%29%28Sane%20Loader%29%5B%21%5D.tap
[rak-timing-download]: https://zxe.io/depot/software/ZX%20Spectrum/Timing%20Test%20v0.3%20%282013-12-09%29%28Rak%2C%20Patrik%29%5B%21%5D.zip
[ulatest3-download]: https://zxe.io/depot/software/ZX%20Spectrum/ULA%20Test%203%20%282011-08-24%29%28Bobrowski%2C%20Jan%29%5B%21%5D.tap
[ula48-download]: https://zxe.io/depot/software/ZX%20Spectrum/ULA%2048%20Simple%20Test%20%282012-10-06%29%28azesmbog%29%5B%21%5D.tap
[nec48-download]: https://zxe.io/depot/software/ZX%20Spectrum/48K%20NEC%20Contention%20Test%20Suite%20%282008-09-14%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[float48-download]: https://zxe.io/depot/software/ZX%20Spectrum/Float48K%20%282008-03-24%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[halt-download]: https://zxe.io/depot/software/ZX%20Spectrum/HALT%20Contention%20Test%20%282021-09-14%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[ldir-download]: https://zxe.io/depot/software/ZX%20Spectrum/LDIR-LDDR%20%282021-12-17%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[otir-download]: https://zxe.io/depot/software/ZX%20Spectrum/OTIR-OTDR%20%282009-05-23%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[io-download]: https://zxe.io/depot/software/ZX%20Spectrum/IO%20Contend%20%282021-03-02%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[ir-download]: https://zxe.io/depot/software/ZX%20Spectrum/IR%20Contention%20%282023-01-08%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[zexall-download]: https://zxe.io/depot/software/ZX%20Spectrum/Z80%20Full%20Instruction%20Set%20Exerciser%20for%20Spectrum%20%282018%29%28Harston%2C%20Jonathan%20Graham%29%5B%21%5D.tap
[zexdoc-download]: https://zxe.io/depot/software/ZX%20Spectrum/Z80%20Documented%20Instruction%20Set%20Exerciser%20for%20Spectrum%20%282018%29%28Harston%2C%20Jonathan%20Graham%29%5B%21%5D.tap
[woodmass-download]: https://zxe.io/depot/software/ZX%20Spectrum/Z80%20Test%20Suite%20%282008%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[xcf-download]: https://zxe.io/depot/software/ZX%20Spectrum/Z80%20XCF%20Flavor%20v1.5%20%282024-02-06%29%28Sainz%20de%20Baranda%20y%20Go%C3%B1i%2C%20Manuel%29%5B%21%5D.tar.xz
[z80type-download]: https://zxe.io/depot/software/ZX%20Spectrum/Z80%20Processor%20Type%20Detection%20%282024-10-04%29%28Bobrowski%2C%20Jan%29%5B%21%5D.tap
[retrigger-download]: https://zxe.io/depot/software/ZX%20Spectrum/Interrupt%20Retriggering%20Test%20%282021-12-17%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[ei-download]: https://zxe.io/depot/software/ZX%20Spectrum/EI48K%20%282021-09-27%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[prefixes-download]: https://zxe.io/depot/software/ZX%20Spectrum/Prefixes%20%282022-06-12%29%28Woodmass%2C%20Mark%29%5B%21%5D.tap
[rom-boundary-download]: https://zxe.io/depot/software/ZX%20Spectrum/ROM%20Boundary%20Test%20%282025-07-18%29%28Ala-K%C3%B6nni%2C%20Jussi%29%5B%21%5D.zip
[ini-hc-download]: https://zxe.io/depot/software/ZX%20Spectrum/INI%20H%20and%20C%20Flags%20Clearing%20Test%20%282024-12-20%29%28Ala-K%C3%B6nni%2C%20Jussi%29%5B%21%5D.tap

[next-block-tap]: https://raw.githubusercontent.com/MrKWatkins/ZXSpectrumNextTests/develop/Tests/ZX48_ZX128/Z80BlockInstructionFlags/z80bltst.tap

[next-ccfscf-tap]: https://raw.githubusercontent.com/MrKWatkins/ZXSpectrumNextTests/develop/Tests/ZX48_ZX128/Z80CcfScfOutcomeStability/ccffrm.tap

[next-intskip-tap]: https://raw.githubusercontent.com/MrKWatkins/ZXSpectrumNextTests/develop/Tests/ZX48_ZX128/Z80IntSkip/int_skip.tap

[minfo-download]: https://zxe.io/depot/software/ZX%20Spectrum/Minfo%20%282011-08-20%29%28Bobrowski%2C%20Jan%29%5B%21%5D.tap

[suite-fixes]: https://github.com/emustudio/emuStudio/issues/433
