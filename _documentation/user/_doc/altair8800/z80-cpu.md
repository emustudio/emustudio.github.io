---
layout: default
title: CPU "z80-cpu"
nav_order: 6
parent: MITS Altair8800
permalink: /altair8800/z80-cpu
---

{% include analytics.html category="Altair8800" %}

# Zilog Z80 CPU emulator

NOTE: This CPU plugin is shared across multiple virtual computers. It is used in both
[MITS Altair8800]({{ site.baseurl }}/altair8800/) and
[ZX Spectrum 48K]({{ site.baseurl }}/zxspectrum48k/) computers.
{: .info}

The `z80-cpu` plugin emulates an 8-bit Zilog Z80 with a 16-bit address space (64 KiB). Its features include:

- Documented and undocumented instructions, including DD/FD prefix chains.
- Instruction timing in T-states and memory contention through the connected bus.
- Maskable interrupts, non-maskable interrupts and the interrupt delay after `EI`.
- Disassembly, single stepping, breakpoints and instruction tracing.
- Main and alternate register sets, flags and measured execution frequency in the CPU status panel.

I/O devices are selected by the low eight bits of the port address (`00h`–`FFh`). The CPU passes the full
16-bit port address to the selected device, which allows Spectrum devices to decode its high byte.
Reading an unattached port returns `FFh`.

## CPU status panel

The **Set 1** and **Set 2** tabs show the main and alternate registers and flags. The panel also displays
`PC`, `SP`, `IX`, `IY`, `I`, `R` and the current run state.

- **CPU Frequency** sets the target clock in kHz. Pause or stop emulation before changing it.
  The change lasts for the current session; edit `frequency_khz` to make it persistent.
- **Runtime frequency** shows the measured execution rate.
- **Dump instructions history** enables tracing to standard error with repeated-address caching.
- **Load snapshot...** restores a ZX Spectrum 48K `.sna` or `.z80` snapshot while emulation is paused or stopped.
  Use it with the [ZX Spectrum computer]({{ site.baseurl }}/zxspectrum48k/z80-cpu), whose ROM, bus and ULA
  provide the hardware expected by the snapshot. After loading, run emulation to resume the program.

## Configuration file

These settings belong in the CPU's `[CPU.settings]` section of the computer TOML file. If its `[CPU]` section
contains `settings = { }`, remove that inline table before adding `[CPU.settings]`.

|---
| Name | Default value | Valid values | Description
|-|-|-|-
| `printCode` | `false` | `true` / `false` | Enable instruction tracing when the CPU is initialized.
| `printCodeUseCache` | `false` | `true` / `false` | With `printCode = true`, summarize repeated visits to instruction addresses.
| `printCodeFileName` | `"syserr"` | `"syserr"` or writable file path | Write the startup trace to standard error or a file. The file is overwritten when the CPU is initialized.
| `frequency_khz` | `4000` | Positive integer | Target CPU clock in kHz. The bundled Spectrum computer sets this to `3500`.
|---

For example, to record every instruction to a file:

```toml
[CPU.settings]
frequency_khz = 4000
printCode = true
printCodeUseCache = false
printCodeFileName = "z80-trace.txt"
```

The status panel's tracing checkbox changes the active tracer. Turning it on selects cached output to standard
error, regardless of the startup file and cache settings.

## Dumping executed instructions

Tracing prints the disassembled instruction and CPU state after its execution. It also works when single stepping.
Launch emuStudio from a terminal to see standard-error output, or use `printCodeFileName` to capture a startup trace.

For example, compile this program with [as-z80]({{ site.baseurl }}/altair8800/as-z80) into writable memory,
set the program address to `0000h`, reset the CPU and step through its first three instructions:

{:.code-example}
```asm
org 0000h
ld sp, 0FF00h
ld a, 2Ah
inc a
halt
```

With caching disabled, the first three trace lines look like this. Elapsed times vary between runs:

{:.code-example}
```text
0000 | PC=0000 |    ld sp, FF00h |   31 00 FF || regs=00 00 00 00 00 00 00 00  IX=0000 IY=0000 IFF=0 I=00 R=01 | flags=       | SP=ff00 | PC=0003
0032 | PC=0003 |       ld a, 2Ah |      3E 2A || regs=00 00 00 00 00 00 00 2a  IX=0000 IY=0000 IFF=0 I=00 R=02 | flags=       | SP=ff00 | PC=0005
0034 | PC=0005 |           inc a |         3C || regs=00 00 00 00 00 00 00 2b  IX=0000 IY=0000 IFF=0 I=00 R=03 | flags=       | SP=ff00 | PC=0006
```

|---
| Field | Meaning
|-|-
| First column | Elapsed host time in milliseconds since the tracer's first instruction; this is not a T-state count.
| First `PC` | Address of the instruction being executed.
| Mnemonic and opcode | Disassembled instruction and its bytes.
| `regs` | Main registers in order: `B C D E H L`, an unused slot, then `A`. The unused slot is not `F`.
| `IX`, `IY` | Index registers after execution.
| `IFF` | Interrupt-enable flip-flop `IFF1` after execution.
| `I`, `R` | Interrupt-vector and refresh registers after execution.
| `flags` | Set documented flags: `S Z H P N C`, where `P` represents parity/overflow. Unset flags are spaces; undocumented `X` and `Y` flags are omitted.
| `SP`, last `PC` | Stack pointer and next instruction address after execution.
|---

The fields before `||` describe the instruction; those after it describe the resulting CPU state.
With caching enabled, repeated visits are summarized as `Block from ... to ...; count=...`.
Disable caching when you need a complete trace of a loop.

## Testing the CPU

Choose a computer that provides the environment required by the test program:

|---
| Test suite | Computer setup
|-|-
| Patrik Rak's z80test | ZX Spectrum 48K with its ROM, bus, ULA, display and Audio Tape Player.
| ZXSpectrumNextTests, classic Spectrum tests | ZX Spectrum 48K; use the compatible tests listed below.
| ZEXALL / ZEXDOC | Altair with Z80 and CP/M, or the standalone Altair setup below.
|---

### Patrik Rak's Z80 Test

[Patrik Rak's z80test][z80test-raxoft]{:target="_blank"} compares instruction results with a real Zilog Z80.
`z80doc` tests registers and documented flags; `z80full` includes undocumented flags.
The suite also provides `z80flags`, `z80docflags`, `z80ccf`, `z80memptr` and the visual `z80ccfscr` test.

1. Obtain the suite's TAP files. To build them from source, install [Sjasm][sjasm]{:target="_blank"},
   [mktap][mktap]{:target="_blank"} and Make, then run `make` in the repository's `src` directory.
   Its [Makefile][z80test-makefile]{:target="_blank"} creates `z80doc.tap`, `z80full.tap` and the other variants.
2. Open the **ZX Spectrum 48K** computer with the 48K ROM loaded and start emulation.
3. Open its **Audio Tape Player** and load `z80doc.tap`.
4. In the Spectrum display, enter `LOAD ""`, press ENTER, then click **Play** in the tape player.
5. Wait for the BASIC loader to start the test and read the results on the Spectrum display.
   Reset the computer and repeat with `z80full.tap` or another variant.

These TAP files use the Spectrum ROM and display routines. Run them on the Spectrum computer without Altair
serial-port patches. See [Loading software from tape]({{ site.baseurl }}/zxspectrum48k/software#loading-software-from-tape)
for the loader workflow.

### ZXSpectrumNextTests

[ZXSpectrumNextTests][ZXSpectrumNextTests]{:target="_blank"} contains both Next-specific tests and classic Spectrum
tests. For the emulated 48K computer, use these programs from `Tests/ZX48_ZX128`:

|---
| Directory | TAP file | Purpose
|-|-|-
| [Z80BlockInstructionFlags][nexttest-block]{:target="_blank"} | `z80bltst.tap` | Flags when repeating block instructions are interrupted.
| [Z80CcfScfOutcomeStability][nexttest-ccfscf]{:target="_blank"} | `ccffrm.tap` | CCF/SCF flag stability across frame timing.
| [Z80IntSkip][nexttest-intskip]{:target="_blank"} | `int_skip.tap` | Interrupt inhibition after EI and DD/FD prefixes.
|---

1. Download a TAP file from its directory using GitHub's raw-file download.
2. Start the **ZX Spectrum 48K** computer with its ROM loaded.
3. Load the TAP in **Audio Tape Player**, enter `LOAD ""` on the Spectrum display, press ENTER and click **Play**.
4. Compare the display with the test's README and reference results. These include visual and timing tests,
   so the expected output depends on the selected program.

For example, to build the block-flags test yourself, install [sjasmplus][sjasmplus]{:target="_blank"},
then run `sjasmplus z80_block_flags_test.asm` from its directory. This produces `z80bltst.tap` and `z80bltst.sna`.
The SNA can also be opened with the CPU panel's **Load snapshot...** button, then resumed with **Run**.

The ZX Spectrum Next's Z80N instructions and additional hardware are outside this plugin's Z80/48K setup.

### ZEXALL tests

[ZEXALL and ZEXDOC][zexall]{:target="_blank"} are CP/M instruction exercisers. The repository supplies ready-to-run
`zexall.com` and `zexdoc.com` binaries. ZEXDOC checks documented flags; ZEXALL also checks undocumented flags.

#### Under CP/M

1. Boot an Altair **Z80** computer using the [CP/M 2.2 setup]({{ site.baseurl }}/altair8800/software#cpm-22).
2. Copy `zexdoc.com` and `zexall.com` to a writable CP/M disk using
   [Moving host files into CP/M]({{ site.baseurl }}/altair8800/software#moving-host-files-into-cpm).
3. At the CP/M prompt, select that drive and run `ZEXDOC` or `ZEXALL`.
4. Read the results in the terminal. These exhaustive tests can take a long time.

#### Standalone Altair with serial console

Use `as-z80`, `z80-cpu`, one 64 KiB writable memory bank and `88-sio` connected to a terminal.
The SIO data port must include `11h`. This launcher provides only the CP/M output calls needed by the exercisers.

1. Stop emulation and compile the following support code in the source editor:

{:.code-example}
```asm
org 0000h
di
halt                    ; stop when the exerciser returns to address 0

org 0005h               ; minimal BDOS entry point
push af
push de
ld a, 2
cp c
jp nz, print_string
ld a, e                 ; BDOS 2: print character in E
out (11h), a
jp bdos_return

print_string:
ld a, 9
cp c
jp nz, bdos_return
next_char:              ; BDOS 9: print '$'-terminated string at DE
ld a, (de)
inc de
cp '$'
jp z, bdos_return
out (11h), a
jp next_char

bdos_return:
pop de
pop af
ret

org 0040h               ; launcher entry point
di
ld sp, 0FF00h           ; stack in writable RAM
jp 0100h
```

2. In the memory window, load `zexdoc.com` as a raw binary at `0100h`. Keep the support code at `0000h`–`0046h`.
3. Set the program address to **`0040h`**, open the terminal and run emulation.
4. Repeat with `zexall.com` for undocumented-flag checks.

The standalone launcher writes directly to Altair port `11h`. Use the CP/M route for a complete operating-system
environment.

[z80test-raxoft]: https://github.com/raxoft/z80test
[z80test-makefile]: https://github.com/raxoft/z80test/blob/master/src/Makefile
[sjasm]: https://github.com/Konamiman/Sjasm/releases/tag/v0.42c
[mktap]: https://torinak.com/~jb/zx/mktap-16.tar.gz
[ZXSpectrumNextTests]: https://github.com/MrKWatkins/ZXSpectrumNextTests
[nexttest-block]: https://github.com/MrKWatkins/ZXSpectrumNextTests/tree/develop/Tests/ZX48_ZX128/Z80BlockInstructionFlags
[nexttest-ccfscf]: https://github.com/MrKWatkins/ZXSpectrumNextTests/tree/develop/Tests/ZX48_ZX128/Z80CcfScfOutcomeStability
[nexttest-intskip]: https://github.com/MrKWatkins/ZXSpectrumNextTests/tree/develop/Tests/ZX48_ZX128/Z80IntSkip
[sjasmplus]: https://github.com/z00m128/sjasmplus
[zexall]: https://github.com/agn453/ZEXALL
