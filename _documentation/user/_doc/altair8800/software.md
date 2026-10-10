---
layout: default
title: Original software
nav_order: 10
parent: MITS Altair8800
permalink: /altair8800/software
---

{% include analytics.html category="Altair8800" %}

# Original software for Altair8800

Since Altair8800 virtual computer emulates a real machine, it's possible to use real software written for the computer.
Several operating systems, applications and programming languages can be run on Altair. This page covers original
Altair software and Peter Schorn's collections for the Altair with an 8080 or Z80 CPU. Software for other S-100
computers sometimes needs a different disk controller, terminal or processor.

The following sites provide disk images, memory images, source code and manuals:

- Peter Schorn: [original Altair8800 software][schorn-software]{:target="_blank"},
  [operating systems][schorn-os]{:target="_blank"}, [programming languages][schorn-langs]{:target="_blank"},
  [office applications][schorn-office]{:target="_blank"}, [games and tools][schorn-games]{:target="_blank"}.
- [Altair clone downloads][aclone]{:target="_blank"}.
- [DeRamp Altair software archive][deramp]{:target="_blank"} and [manuals][manuals]{:target="_blank"}.

Choose the setup family below for the software you want to run. Stop emulation before changing settings or
loading images; reset before loading a bootloader or applying a memory patch.

## Z80 with one memory bank and 88-DCDD

![Computer schema for one-bank Z80 CP/M with 88-DCDD, SIMH pseudo, PTR/PTP and VT100]({{ site.baseurl }}/assets/altair8800/software-schema-cpm22.png){:style="max-width:796px"}

Use this setup for CP/M 2.2, the one-bank CP/M systems and the applications in this section:

1. Open **MITS Altair8800 (Z80)**. In byte-memory settings (the wrench button), set **65536 bytes** and
   **1 memory bank**. Keep SIMH pseudo connected to CPU and memory.
2. In 88-SIO, pair status ports `0x10, 0x14, 0x16, 0x18` with data ports `0x11, 0x15, 0x17, 0x19`.
3. Use VT100 for the applications below: in a copy of the computer configuration, replace `adm3A-terminal`
   with `vt100-terminal` and connect it to 88-SIO in both directions. Save and reopen the computer, then open
   the VT100 window with half-duplex disabled. ADM-3A also works for the CP/M command prompt.
4. Set 88-DCDD to **32 sectors per track** and **137 bytes per sector**. Keep enlarged Schorn images intact.

![CP/M 2.2 memory banks and boot image settings]({{ site.baseurl }}/assets/altair8800/software-byte-mem-settings.png){:style="max-width:858px"}

![88-SIO console port aliases for CP/M]({{ site.baseurl }}/assets/altair8800/software-88-sio-settings.png){:style="max-width:488px"}

![88-DCDD mounted system disk and sector settings]({{ site.baseurl }}/assets/altair8800/software-88-dcdd-settings.png){:style="max-width:599px"}

### CP/M 2.2

Schorn's [CP/M 2.2 archive][pkg-cpm2]{:target="_blank"} supplies `cpm2.dsk`, utilities and SIMH support.
Use this disk for the application tables below.

1. Reset and select memory bank 0. Load `examples/altair8800/boot/mdbl.bin` at `0xFF00` through byte-memory.
2. Mount `cpm2.dsk` in 88-DCDD drive `A:`. For Pascal MT+, PROLOGZ or SPL, mount `app.dsk` in `B:`.
3. Jump to `0xFF00` and run. At `A>`, type `DIR` or `LS`. To inspect `app.dsk`, type `B:` then `DIR`.

The following image shows `DIR` at the CP/M command prompt:

![Operating system CP/M 2.2]({{ site.baseurl }}/assets/altair8800/software-cpm22.png){:style="max-width:737px"}

Commands are followed by Enter. `DIR B:` lists another drive without changing the current drive. `USER 1` selects
user area 1; use `USER 0` to return. `TYPE filename` displays text, and `PIP` copies files. More information can be
found in the [CP/M 2.2 manual][cpm22]{:target="_blank"}.

The boot disk includes Microsoft BASIC, ELIZA, Star Trek, Othello and Ladder. For example, type `MBASIC ELIZA` to
start ELIZA, or `OTHELLO` to start Othello. The optional `app.dsk` contains PROLOGZ, Pascal MT+ and SPL; see the
programming-language table for their commands.

### Other one-bank CP/M systems

Keep the one-bank Z80 setup. For each package, reset, select bank 0, mount the disks in the table, load the
listed bootloader at `0xFF00`, then jump to `0xFF00` and run. Enter any listed startup command at `A>`.
For packages with SIMH hard disks, configure 88-HDSK as described in the next subsection before booting.

|---
| Download | Disk mounts | Bootloader and command
|-|-|-
| [CP/M 1.4][pkg-cpm1]{:target="_blank"} | `cpm1.dsk` in A:; `cpm1b.dsk` in B: | `cpm1rom.com` from the package
| [Burcon CP/M][pkg-burcon]{:target="_blank"} | `cpm.dsk` in A:; `sysgen.dsk` in B: | `dbl.bin` from the package
| [Personal CP/M][pkg-pcpm]{:target="_blank"} | `pcpm.dsk` in A: | `examples/altair8800/boot/mdbl.bin`
| [DOS+][pkg-dosplus]{:target="_blank"} | `dosplus.dsk` in A:; optional SIMH `i.dsk` in drive 0 (I:) | `examples/altair8800/boot/mdbl.bin`
| [NovaDOS][pkg-novados]{:target="_blank"} | `novados.dsk` in A:; `novadosb.dsk` in B: | `examples/altair8800/boot/mdbl.bin`
| [P2DOS][pkg-p2dos]{:target="_blank"} | `p2dos.dsk` in A:; `p2dosb.dsk` in B:; optional SIMH `i.dsk` in drive 0 (I:) | `examples/altair8800/boot/mdbl.bin`
| [QP/M 2.7][pkg-qpm]{:target="_blank"} | `qpm.dsk` in A: | `examples/altair8800/boot/mdbl.bin`
| [SuperDOS][pkg-superdos]{:target="_blank"} | `superdos.dsk` in A:; `superdosb.dsk` in B: | `examples/altair8800/boot/mdbl.bin`
| [Z80DOS][pkg-z80dos]{:target="_blank"} | `z80dos.dsk` in A:; `z80dosb.dsk` in B: | `examples/altair8800/boot/mdbl.bin`
| [ZSDOS][pkg-zsdos]{:target="_blank"} | `zsdos.dsk` in A:; optional SIMH `i.dsk` in drive 0 (I:) | `examples/altair8800/boot/mdbl.bin`
| [NZ-COM][pkg-nzcom]{:target="_blank"} | `nzcom.dsk` in A:; `nzcomb.dsk` in B:; optional SIMH `i.dsk` in drive 0 (I:) | `examples/altair8800/boot/mdbl.bin`; then `STARTZCM`
| [TurboDOS 1.22P][pkg-turbodos]{:target="_blank"} | package `cpm2.dsk` in A:; SIMH `i.dsk` and `j.dsk` (drive 0 = I:, drive 1 = J:) | `examples/altair8800/boot/mdbl.bin`; then `TURBODOS`
| [ZCPR3][pkg-zcpr3]{:target="_blank"} | package `cpm2.dsk` in A:; SIMH `i.dsk` and `j.dsk` (drive 0 = I:, drive 1 = J:) | `examples/altair8800/boot/mdbl.bin`; consult package notes before replacing the CCP
|---

CP/M 1.4's `cpm1dev.dsk` is a separate CP/M 2.2 development disk: mount it in `A:` and boot with `mdbl.bin`
at `0xFF00`. Burcon's `cpm.dsk` boots with its package loader, but `DIR` reports `Bdos Err On A: Bad Sector`;
use Schorn CP/M 2.2 for applications. TurboDOS's `TURBODOS` command starts a single-user setup.

### SIMH hard disks for CP/M

For DOS+, P2DOS, ZSDOS, NZ-COM, TurboDOS and ZCPR3 packages that supply `i.dsk` or `j.dsk`:

1. In a copy of the computer configuration, select `SIMH` for 88-HDSK (`controllerType = "SIMH").
2. Connect 88-HDSK to CPU and byte-memory in both directions. It uses CPU port `0xFD` and accesses memory directly.
3. Save and reopen the computer. Mount `i.dsk` in 88-HDSK drive 0 and, where supplied, `j.dsk` in drive 1.
   Use **32 sectors per track** and **128 bytes per sector**.
4. Boot the package's floppy listed above. At the CP/M prompt, use `DIR I:` or `DIR J:` to list the hard disks.

These images use the SIMH interface; the MITS Hard Disk BASIC setup has different wiring and geometry.

### CP/M applications

Use the one-bank Z80 setup above, including VT100. Extract the chosen package and keep its overlays, libraries
and data files with the application disk. Use a working copy of the disk image.

1. Reset, select bank 0 and load `examples/altair8800/boot/mdbl.bin` at `0xFF00`.
2. Mount `cpm2.dsk` from Schorn's CP/M 2.2 archive in `A:` and the chosen application disk in `B:`.
   For rows explicitly marked **in A:**, mount that package's bootable disk in `A:` instead.
3. Jump to `0xFF00` and run. For a `B:` application, type `B:` at `A>`, then `DIR` and its listed command.
   For a bootable package in `A:`, enter its listed command at `A>`.

Commands omit `.COM`. Semicolons in the tables separate commands; press Enter after each.

#### Programming languages

|---
|Download | Disk mounts | Commands after boot
|-|-|-
|[ACT 3.0][pkg-act]{:target="_blank"} | `act.dsk` in A: | `ACT80` for 8080/Z80 assembly; `ACT65`, `ACT68`, `ACT86` are cross-assemblers. Read `TYPE CMDLIST.DOC`.
|[JANUS Ada 1.5][pkg-ada]{:target="_blank"} | `ada.dsk` in B: | `JANUS PRIME`; then `JLINK PRIME`; `PRIME`. The source is `PRIME.PKG`; `C.SUB` supplies the same sequence.
|[Algol-M 1.1][pkg-algol]{:target="_blank"} | `algol.dsk` in B: | `ALGOLM HANOI`; then `RUNALG HANOI`. Read `TYPE ALGSTART.TXT` and `TYPE ALGINTRO.TXT`.
|[APL/Z][pkg-apl]{:target="_blank"} | `apl.dsk` in B: | `APL`; answer its `mmddyy-` date prompt. Read `TYPE APL.DOC` for the keyboard notation.
|[Microsoft and CBASIC variants][pkg-basic]{:target="_blank"} | `basic.dsk` in B: | `MBASIC`; or `MBASIC ELIZA`. Compiler and runtime commands are described below.
|[MTBASIC, S-BASIC, Tarbell BASIC, BBC BASIC][pkg-basiccollection]{:target="_blank"} | `mtbasic.dsk`, `sbasic.dsk`, `tbasic.dsk` or `bbcbasic.dsk` in B: | Mount the chosen image in B:, then `MTBASIC`, `SBASIC`, `TBASIC` or `BBCBASIC`. Keep each interpreter/compiler with its libraries and documentation.
|[BDS C 1.60][pkg-bdsc]{:target="_blank"} | `bdsc160.dsk` in B: | `CC UCASE`; then `CLINK UCASE`; `UCASE`. `bdsc160source.dsk` contains the compiler sources; package `cpm2.dsk` is a boot disk.
|[HI-TECH C 3.09 / Aztec C 1.06D][pkg-aztechitechc]{:target="_blank"} | `hitechc.dsk` or `az106d.dsk` in B: | HI-TECH: `C HELLO.C`; `HELLO`. Aztec: `CC HELLO.C`; `AS HELLO.ASM`; `LN HELLO.O -LC`; `HELLO`. Each disk has `HELLO.SUB`.
|[Microsoft COBOL 4.65][pkg-cobol]{:target="_blank"} | `cobol.dsk` in B: | `COBOL =SQUARO`; `A:L80 SQUARO,CDVT100,COBLIB/S,SQUARO/N/E`; `SQUARO`. Use VT100. `C.SUB` supplies this build sequence.
|[COMAL-80][pkg-comal]{:target="_blank"} | `comal.dsk` in A: | `COMAL`. Use VT100; read `TYPE STARTED.DOC` before starting the interpreter.
|[FOCAL][pkg-focal]{:target="_blank"} | `focal_dev.dsk` in A: | `FOCPM` or `FOCPM2` starts the CP/M versions. Standalone versions are listed in the 8080 memory-image section.
|[UNIFORTH / Forth-83][pkg-forth]{:target="_blank"} | `forth.dsk` in B: | `UNIFORTH` or `F83`. Read `TYPE README80.TXT`; at the Forth prompt try `2 2 + .`.
|[Microsoft FORTRAN-80][pkg-fortran]{:target="_blank"} | `fortran.dsk` in B: | `F80 =TEST`; `A:L80 TEST,F80LIB/S,FORLIB/S,TEST/N/E`; `TEST`. `C.SUB` contains this sequence; `F80C` is another supplied compiler version.
|[LISP/80 / muLISP-80][pkg-lisp]{:target="_blank"} | `lisp.dsk` in B: | `LISP80` or `MULISP`; the latter displays a `$` prompt.
|[Modula-2 2.01][pkg-modula2]{:target="_blank"} | `modula2.dsk` in B: | `MC ERATOS`; then `ML ERATOS`. Use the supplied `MR` runtime for the resulting module; `MC.SUB` shows the compile/link stages.
|[MUMPS 2.x / 4.06][pkg-mumps]{:target="_blank"} | `mumps2.dsk` or `mumps4.dsk` in B: | `MUMPS`; answer the date prompt. Keep the global-storage files on the mounted disk; `SETGLOB` and `SETUP`/`SETMUMPS` configure them.
|[muSIMP-80][pkg-musimp]{:target="_blank"} | `musimp.dsk` in B: | `MUSIMP`. Read `TYPE !README.TXT` and `TYPE READ.ME`; this package includes symbolic-algebra libraries.
|[Turbo Pascal 1.x / 3.x][pkg-pascal]{:target="_blank"} | `tp1.dsk` or `tp3.dsk` in B: | `TURBO`; answer whether to include error messages. Use VT100. `tp3.dsk` reports 3.01A; `TINST` changes the terminal installation.
|[Pascal MT+ / PROLOGZ][pkg-cpm2]{:target="_blank"} | `app.dsk` in B: | `MTPLUS` for Pascal compilation; `LINKMT` is its linker. `PROLOGZ` starts the Prolog environment; read `TYPE PROLOGZ.TXT`.
|[PILOT / Pascal-Z][pkg-pilot]{:target="_blank"} | `pilot.dsk` in A: | `SAMPLE1` starts a supplied demonstration. `DO PILOT/P SAMPLE1` rebuilds it; `PASCAL` starts Pascal-Z. Read `TYPE README.TXT` and `TYPE PILOT/P.DOC`.
|[Digital Research PL/I-80 1.0 / 1.4][pkg-pli]{:target="_blank"} | `pli10.dsk` or `pli14.dsk` in B: | `PLI SAMPLE` on the 1.4 disk; `LINK SAMPLE`; `SAMPLE`. For 1.0 use a supplied source such as `FACT.PLI`: `PLI FACT`; `LINK FACT`; `FACT`.
|[ISIS-II PL/M-80][pkg-plm]{:target="_blank"} | `plm0.dsk` in A:, `plm1.dsk` in B:, `plm2.dsk` in C:, `plm3.dsk` in D: | Boot A: with `mdbl.bin`, then `ISX`. ISIS uses `:F0:` through `:F3:` for those drives. Read `TYPE README.TXT` and `TYPE MAKEPIP.SUB` before building its sample.
|[SYSCON PLMX][pkg-plmx]{:target="_blank"} | `plmx.dsk` in B: | `PLMX MEAN`; `A:M80 =MEAN.MAC`; `A:L80 MEAN,RLIB,MEAN/N/E`; `MEAN`. `PLMX.SUB` supplies the build sequence.
|[Simple Programming Language][pkg-spl]{:target="_blank"} | `spl.dsk` in A: | `SPL FAC`; `L80 FAC,FAC/N/E`; `FAC`. `C.SUB` supplies compilation and linking; `TYPE SPL.TXT` displays the language manual.
|[MINOL / VTL-2][pkg-minolvtl]{:target="_blank"} | `cpm.dsk` in A: | `MINOL` or `VTL2`; `TYPE MINOL22.TXT`, `TYPE MITSVTL2.TXT` and `TYPE VTL2SIMH.TXT` describe the syntax. Standalone versions are listed below.
|---

Build scripts on `B:` may need utilities from the boot disk. Copy the required files first; for example:

```text
A:PIP B:=A:DO.COM
A:PIP B:=A:L80.COM
A:PIP B:=A:M80.COM
B:
DO C TEST
```

Schorn's `DO C TEST` runs `C.SUB` with parameter `TEST`; CP/M's `A:SUBMIT C TEST` is an alternative after copying
required tools. Read scripts with `TYPE C.SUB` first: they may overwrite working-disk files.

For Microsoft BASIC, run `MBASIC`, then try `PRINT 2+2`; supplied programs start with `MBASIC ELIZA`,
`MBASIC STARTREK`, `MBASIC HAMURS` or `MBASIC MSTMND`. Other interpreters on `basic.dsk`: `MBASIC45`, `MBASIC51`,
`MBASIC52` and `XBASIC`.

![Microsoft BASIC running a program under CP/M in emuStudio]({{ site.baseurl }}/assets/altair8800/software-cpm-basic.png){:style="max-width:737px"}

![Turbo Pascal command menu in emuStudio VT100]({{ site.baseurl }}/assets/altair8800/software-turbo-pascal.png){:style="max-width:737px"}

BASIC compiler outputs need their runtimes: `CBASIC BLACKJAK` produces `.INT` for `CRUN2 BLACKJAK`; Digital
Research uses `CBASE2`/`CRUN`; and `CB80` output needs `LINK` or `LK80`. For BASCOM, copy `DO.COM` and `L80.COM`
to the working disk, then run `DO BASCOM BLACKJAK` (`BASCOM.SUB` compiles, links with `BASLIB` and runs it).

#### Office applications

With the one-bank Z80 and VT100 setup, load `mdbl.bin` at `0xFF00`, mount `cpm2.dsk` in `A:` and the listed
disk in `B:`, then run from `0xFF00`. At `A>`, type `B:`, then the package command below.

|---
|Download | Disk in B: | Command
|-|-|-
|[dBASE II 2.4][pkg-dbase]{:target="_blank"} | `dbase.dsk` | `DBASE`; press Enter for no date, or enter the requested date. At its `.` prompt use `QUIT` to leave.
|[WordStar 4.0][pkg-wordstar]{:target="_blank"} | `wordstar.dsk` | `WS`; choose `D` to open a document or `X` to exit. The overlays must remain available.
|[WordStar 3.30 and SpellStar][pkg-ws33]{:target="_blank"} | `ws33.dsk` | `WS`; use the opening menu. Keep the supplied spelling and overlay files on the disk.
|[VEDIT PLUS 2.33b][pkg-vedit]{:target="_blank"} | `vedit.dsk` | `VEDIT`, or `VEDIT HELLO.TXT` for a file. Read `TYPE READ-ME.DOC` for its commands.
|[Multiplan 1.06][pkg-multiplan]{:target="_blank"} | `multiplan.dsk` | `MP`; use the command menu at the bottom of the screen.
|[SuperCalc2 1.00][pkg-supercalc]{:target="_blank"} | `supercalc.dsk` | `SC2`, then Enter to start or `?` for help. The executable is `SC2.COM`, not `SC.COM`.
|---

![WordStar opening menu in emuStudio VT100]({{ site.baseurl }}/assets/altair8800/software-wordstar.png){:style="max-width:737px"}

#### Games

Mount [Games][pkg-games]{:target="_blank"} `games.dsk` in `B:` and boot `cpm2.dsk` from `A:`. Select VT100 for
screen games and keep the complete disk mounted for their data files. Reset, select bank 0, load `mdbl.bin`
at `0xFF00` and run from `0xFF00`. At `A>`, type `B:`, then a game command below.

|---
| Game | Command at `B>` | Notes
|-|-|-
| Colossal Cave Adventure | `ADV` | Text adventure; keep its data files on the same disk. Wait for the introduction before entering commands.
| Catchum | `CATCHUM` | Screen game; use VT100.
| Ladder | `LADDER` | Screen game; `LADDER.DAT` must be available. Also supplied on the CP/M boot disk.
| Rogue | `ROGUE` | Read `TYPE ROGUE.DOC`; use VT100.
| Wanderer | `WANDERER` | Requires the `SCREEN.*` level files; read `TYPE WANDERER.DOC`.
| Worm | `WORM` | Use the controls shown by the game.
| Sargon | `SARGON` | Chess program; follow its startup prompts.
|---

![Ladder opening menu in emuStudio VT100]({{ site.baseurl }}/assets/altair8800/software-ladder.png){:style="max-width:737px"}

Othello is on `cpm2.dsk` (`OTHELLO` at `A>`). ELIZA, Star Trek, Hamurabi and Mastermind use `MBASIC name`.
[DeRamp CP/M games][deramp-cpm]{:target="_blank"} include Zork and a Creative Computing disk (`MBASIC MENU`).
Native BASIC games instead use `MOUNT`, `FILES` and `RUN "name"`.

#### Tools

Mount [Tools][pkg-tools]{:target="_blank"} `tools.dsk` in `B:` and `cpm2.dsk` in `A:`. Reset, select bank 0,
load `mdbl.bin` at `0xFF00` and run from `0xFF00`. Type `B:`, then `DDTZ27` (debugger) or `JOB15` (job utility).
Read `DDTZ27.DOC` and `JOB.DOC` with `TYPE`.

The CP/M boot disk supplies `M80`, `L80`, `DDT`, `DDTZ`, `SID`, `ZSID`, `PIP`, `STAT`, `R`, `W` and `HDIR`.
`M80` is Microsoft's assembler, `L80` its linker; both use the syntax documented by their original manuals, not
emuStudio's source editor syntax. `R` and `W` depend on the connected SIMH pseudo device and PTR/PTP.

### Moving host files into CP/M

Use any of these to manipulate CP/M images:

- the bundled `88-dcdd` command-line tool, described in [Experimental CP/M support][88-dcdd-cpm]{:target="_blank"};
- [cpmtools][cpmtools]{:target="_blank"}, with a disk definition matching the actual image;
- the guest `R.COM` and `W.COM` utilities with emuStudio's SIMH pseudo device and PTR/PTP.

#### Using the bundled disk tool

Stop emulation and unmount the working image before host-side changes. Run the tool from the emuStudio installation
directory, where `examples/altair8800/cpm-formats.toml` is available:

```sh
cd /path/to/emuStudio
bin/88-dcdd -l
bin/88-dcdd -f cpm3-simh -i /path/to/cpm2-work.dsk cpmfs ls
bin/88-dcdd -f cpm3-simh -i /path/to/cpm2-work.dsk cpmfs copy /path/to/HELLO.BAS cpm://HELLO.BAS
```

Use **`cpm3-simh` for Schorn's `cpm2.dsk` and most application disks**, `cpm2-simh` for `altcpm.dsk`, and
`cpm1-simh` for the CP/M 1.4 system disk. Wrong formats can list directories but corrupt file access; check
`cpmfs ls`, consult the format file for DeRamp/ZSDOS variants, then remount and verify with guest `DIR`.

Run `HELLO.BAS` with `MBASIC HELLO` from a disk containing `MBASIC.COM`; start `TST8080.COM` with `TST8080`.
CP/M filenames allow up to eight characters, plus a three-character extension.

#### Using R and W inside CP/M

For Schorn's `cpm2.dsk`/`cpm3.dsk`, connect SIMH pseudo to CPU, memory and PTR/PTP. Host paths are relative to
emuStudio's working directory. Start it in a directory containing `HELLO.BAS`, boot CP/M, select a writable drive:

```text
A:R HELLO.BAS
DIR HELLO.BAS
MBASIC HELLO
```

`A:R HELLO.BAS` imports a host file; `A:W HELLO.BAS` exports one to the working directory. `HDIR` is available in
packages that include it. See the [SIMH pseudo-device page][simh-device]{:target="_blank"}.

## Z80 with banked memory and 88-DCDD

![Computer schema for banked Z80 CP/M with 88-DCDD, SIMH pseudo, PTR/PTP and ADM-3A]({{ site.baseurl }}/assets/altair8800/software-schema-cpm3.png){:style="max-width:796px"}

Use this setup for CP/M 3, Z3PLUS and the RCL Z3PLUS collection:

1. Open **MITS Altair8800 (Z80)**. Set byte-memory to **65536 bytes**, **8 banks** and
   **common address `0xC000`**. Keep SIMH pseudo connected to CPU and memory so the BIOS can switch banks.
2. Pair 88-SIO status ports `0x10, 0x14, 0x16, 0x18` with data ports `0x11, 0x15, 0x17, 0x19`.
   Open the connected terminal with half-duplex disabled; use VT100 for screen applications.
3. Set 88-DCDD to **32 sectors per track** and **137 bytes per sector**.

### CP/M 3

Schorn's [CP/M 3 archive][pkg-cpm3]{:target="_blank"} contains a banked system with an Altair BIOS.
It needs the SIMH pseudo device and `mdbl.bin`.

1. Reset, select bank 0 and load `examples/altair8800/boot/mdbl.bin` at `0xFF00`.
2. Mount `cpm3.dsk` in 88-DCDD drive `A:`.
3. Jump to `0xFF00` and run. At `A>`, type `DIR` or `HELP`.

![CP/M 3 memory banks and common boundary settings]({{ site.baseurl }}/assets/altair8800/software-cpm3-memory-settings.png){:style="max-width:858px"}

![Operating system CP/M 3 (banked version)]({{ site.baseurl }}/assets/altair8800/software-cpm3.png){:style="max-width:737px"}

The applications in the one-bank section use CP/M 2.2. See the [CP/M 3 manual][cpm3manual]{:target="_blank"}
and [SIMH AltairZ80 manual][simhmanual]{:target="_blank"} for the BIOS and additional disk formats.

### Z3PLUS and RCL Z3PLUS

Keep the eight-bank setup. Reset, select bank 0, mount the listed floppies, load `mdbl.bin` at `0xFF00`,
then jump to `0xFF00` and run. Type `STARTZ3P` at `A>`.

|---
| Download | Disk mounts | Bootloader and command
|-|-|-
| [Z3PLUS][pkg-z3plus]{:target="_blank"} | `z3plus.dsk` in A:; `z3plusb.dsk` in B:; optional SIMH `i.dsk` in drive 0 (I:) | `examples/altair8800/boot/mdbl.bin`; then `STARTZ3P`
| [RCL Z3PLUS collection][pkg-rcl_z3plus_cpm3_2017]{:target="_blank"} | `z3plus.dsk` in A:; `disk__RCL_Empty_Scratch_Disk_1mb.dsk` in B: | `examples/altair8800/boot/mdbl.bin`; images are in `rcl_z3plus_cpm3_2017/`; then `STARTZ3P`
|---

Before booting Z3PLUS or RCL with optional `i.dsk` and `j.dsk`, select SIMH mode for 88-HDSK, connect it to
CPU and byte-memory in both directions, and reopen the computer. Mount the images in drives 0 and 1 with 32 sectors per track and
128 bytes per sector. CP/M 3 exposes hard disks as `I:` through `L:`; use `DIR I:` and `DIR J:` for these two.

## 8080 with one memory bank and 88-DCDD

![Computer schema for 8080 floppy software with 88-DCDD and ADM-3A]({{ site.baseurl }}/assets/altair8800/software-schema-8080-floppy.png){:style="max-width:767px"}

Use this setup for Altair DOS, native floppy Disk BASIC, Programming System II and 8080 CP/M diagnostics:

1. Open **MITS Altair8800** with the 8080 CPU. Set byte-memory to **65536 bytes** and **1 memory bank**.
2. In 88-SIO, enable paired status/data ports `0x00`/`0x01` for DOS and Disk BASIC and `0x10`/`0x11` for 2SIO.
   Enable uppercase input and clear output bit 8; initially leave Delete and Backspace as `UNCHANGED`.
3. Open the connected ADM-3A terminal with half-duplex disabled.
4. Set 88-DCDD to **32 sectors per track** and **137 bytes per sector**.

### Altair DOS v1.0

Altair DOS is in [Original Altair software][pkg-altsw]{:target="_blank"} (`altdos.dsk`, `altdos2.dsk`). It runs directly
on the computer, without CP/M.

1. Reset and select bank 0. Load `examples/altair8800/boot/dbl.bin` at `0xFF00`.
2. Mount `altdos.dsk` in 88-DCDD drive `A:`; mount `altdos2.dsk` in `B:` if you want the second disk.
3. Jump to `0xFF00` and run, then answer each prompt:

|---
| Question | Answer
|-|-
| `MEMORY SIZE?` | `64` (kilobytes, with 64K installed)
| `INTERRUPTS?` | `N`
| `HIGHEST DISK NUMBER?` | `0`, or `1` if the second disk is mounted
| `HOW MANY DISK FILES?` | `3`
| `HOW MANY RANDOM FILES?` | `2`
|---

When the `.` prompt appears, type `MNT 0`, wait for the next prompt, then type `DIR 0`. For the second disk use
`MNT 1` and `DIR 1`. `EDIT name 0` opens the editor. The disk also has assembler, linker and FORTRAN tools; their
commands differ from CP/M commands. See the [Altair DOS manual][altairmanual]{:target="_blank"}.

Automatic memory detection probes writable memory. If all 64K is RAM and no ROM boundary is configured, the probe
can wrap around and report `INSUFFICIENT MEMORY`. The explicit answer above avoids relying on that probe.

![Operating system Altair DOS 1.0]({{ site.baseurl }}/assets/altair8800/software-altairdos.png){:style="max-width:737px"}

### MITS Disk BASIC

MITS BASIC 4.1 is in [Original Altair software][pkg-altsw]{:target="_blank"} as `mbasic.dsk`.
It runs directly on the 8080, unlike the CP/M program `MBASIC.COM`.

1. Reset and select bank 0. Load `examples/altair8800/boot/dbl.bin` at `0xFF00`.
2. Mount `mbasic.dsk` in 88-DCDD drive `A:`.
3. Jump to `0xFF00` and run, then answer each prompt:

|---
| Question | Answer
|-|-
| `MEMORY SIZE?` | `61440` (bytes, leaving the top 4K unused)
| `LINEPRINTER?` | `C`
| `HIGHEST DISK NUMBER?` | `0`
| `HOW MANY FILES?` | `3`
| `HOW MANY RANDOM FILES?` | `2`
|---

BASIC's memory-size answer is in **bytes**, unlike Altair DOS. `64` is not an answer for 64K here. Enter by itself
can use automatic detection when a suitable ROM boundary is configured.

When `OK` appears, type the following commands one at a time:

```text
MOUNT 0
FILES
RUN "STARTREK"
```

`MOUNT 0` makes the disk available to BASIC, even though it is already mounted in the device GUI. `FILES` lists its
programs. `LOAD "STARTREK"` loads without running; `LIST` displays the source, and `RUN` executes it. Other supplied
programs include INVEST, 3DTTT, DAYOWEEK, DAYSPAN, DIAMOND, RUSROU, BOXING, MAP, ANNUITY, LOAN and BOMBER.
Use the name printed by `FILES`. The [BASIC 4.1 reference manual][basic]{:target="_blank"} describes the disk commands.

![Altair 8800 Basic 4.1]({{ site.baseurl }}/assets/altair8800/software-disk-basic.png){:style="max-width:737px"}

The same steps apply to the following native 8-inch floppy versions:

|---
| Download | System disk | Notes
|-|-|-
| [Original Altair software][pkg-altsw]{:target="_blank"} | `extbas5.dsk` | Disk Extended BASIC 300-5-C. Boot from `0xFF00`, then `MOUNT 0`, `FILES`, `RUN "STARTREK"`.
| [More original software][pkg-althdsw]{:target="_blank"} | `fdbasic-300-5-f.dsk` | Disk Extended BASIC 300-5-F. Boot from `0xFF00`, then `MOUNT 0` and `FILES`.
| [Altair clone BASIC disks][clone-basic]{:target="_blank"} | Disk BASIC 4.1 and 5.0 disk images | Choose the native floppy image, boot it with `dbl.bin`, and list its contents with `FILES`.
| [DeRamp floppy BASIC][deramp-basic]{:target="_blank"} | BASIC, games and accounting disks | Boot a compatible Disk BASIC system disk in drive 0; mount the data disk in another drive, then use `MOUNT 1` and `FILES 1` for drive 1.
|---

### Disk Extended BASIC 5.0 memory image

Use the 8080 floppy setup above for `disbas50.bin` and `disbas50.dsk` from
[Original Altair software][pkg-altsw]{:target="_blank"}. This version starts from a memory image instead of `dbl.bin`.

1. Reset, select bank 0 and load `disbas50.bin` at `0x0000`.
2. Replace `DB FF` at `0x534F` with `3E 08` and mount `disbas50.dsk` in 88-DCDD drive `A:`.
3. Jump to `0x0000` and run. Answer memory `61440`, lineprinter `C`, highest disk `0`, files `3`, random files `2`.
4. At `OK`, type `MOUNT 0`, then `FILES`.

### MITS Programming System II

The [Programming System II floppy package][ps2-disk]{:target="_blank"} boots its monitor, editor, assembler and
debugger from disk.

1. Reset and select bank 0. Mount a working copy of `PS2DEMO.DSK` in 88-DCDD drive `A:`.
2. Load `PS2PROM.HEX` through byte-memory at offset `0`; the HEX records supply the addresses.
3. Jump to `0xF000` and run.

Choose workspace `4` for editor/AM2, `3` for debugger/AM2, or
`2` for 8K BASIC/Chase; see the [package instructions][ps2-readme]{:target="_blank"} for memory layout. In the
editor, `EDT`, `I`, source, Ctrl-Z, `E` edits a file; `EDT(R)` reopens it. Run `AM2` to assemble and `EOA` to
return to the monitor. Addresses are octal.

The tape package's `PS2-EDT.BIN`, `PS2-ASM.BIN`, `PS2-AM2.BIN` and `PS2-DBG.BIN` are monitor-load records, not ordinary
raw memory binaries. Do not load them at address zero just because their extension is `.BIN`.

### Other 8-inch CP/M disks

For a bootable Lifeboat image from [DeRamp's CP/M archive][deramp-cpm]{:target="_blank"}, keep the 8080 floppy
setup, mount the image in `A:`, reset and select bank 0. Load the package's matching loader at `0xFF00`, then
jump to `0xFF00` and run. Application-only images need a boot disk whose BIOS supports their layout.

### 8080 CPU diagnostics under CP/M

[CPU tests][cpu-tests]{:target="_blank"} include `TST8080.COM`, `8080PRE.COM`, `8080EXER.COM`, `8080EXM.COM` and
`CPUTEST.COM`. Copy the chosen `.COM` to a working copy of `altcpm.dsk`
with the bundled `88-dcdd` tool's `cpm2-simh` format. Mount that disk in `A:`, reset, select bank 0 and load
`examples/altair8800/boot/dbl.bin` at `0xFF00`. Jump to `0xFF00` and run, then type the test name without `.COM`
at `A>` (for example, `TST8080`). Compare `8080EXER` CRCs with real hardware; its `Error` text alone
does not prove a CPU defect. See the [test notes][cpu-test-notes]{:target="_blank"}; a full run can take hours.

## 8080 with one memory bank and serial console

![Computer schema for standalone 8080 software with 88-SIO and ADM-3A]({{ site.baseurl }}/assets/altair8800/software-schema-8080-serial.png){:style="max-width:767px"}

Use this setup for standalone BASIC, MINOL, VTL-2, FOCAL and serial monitors:

1. Open the 8080 **MITS Altair8800**. Set byte-memory to **65536 bytes** and **1 memory bank**.
2. Enable paired 88-SIO status/data ports `0x10`/`0x11`, uppercase input and clear output bit 8.
3. Open the connected ADM-3A terminal with half-duplex disabled. These memory images do not need a system disk.

### 4K, 8K and Extended BASIC memory images

Download [Original Altair software][pkg-altsw]{:target="_blank"} (`altsw.zip`) and choose a binary below.
These images read sense switches at port `0xFF`, which the standard computer lacks.

1. Reset, select bank 0 and load the chosen binary at `0x0000` through byte-memory.
2. At each patch address in its row, replace bytes `DB FF` (`IN 0xFF`) with `3E 08` to select 2SIO.
3. Jump to `0x0000` and run. Answer memory size `61440`, terminal width `80` if asked, and trigonometric functions `Y`.
4. At `OK`, type `PRINT 2+2`; it should return `4`.

|---
| Binary | Version | Address of console patch
|-|-|-
| `4kbas32.bin` | 4K BASIC 3.2 | `0x0D34` and `0x0D45`
| `4kbas40.bin` | 4K BASIC 4.0 | `0x0D24`
| `8kbas.bin` | 8K BASIC 4.0 | `0x193A`
| `exbas.bin` | Extended BASIC 4.0 | `0x38EB`
|---

These patch addresses refer only to the named binaries in `altsw.zip`. Other releases and ROM versions have different
addresses. For a different image, use its supplied source and loader instructions rather than applying these offsets.

### MINOL, VTL-2 and monitors

Download the binaries from [MINOL / VTL-2][pkg-minolvtl]{:target="_blank"}.

Reset and select bank 0 before loading either binary; reapply its patch after each reset.

Standalone VTL-2: load `mitsvtl2.bin` at `0xF800`, patch `DB FF` at `0xF820` to `3E 08`, then start at `0xF800`.
Standalone MINOL: load `minol22.bin` at 0, patch `DB FF` at `0x0252` to `3E 00`, enable 2SIO `0x10`/`0x11`,
then start at 0.

The [ROM directory][clone-roms]{:target="_blank"} contains TURMON (`0xFD00`), hexadecimal TURMONH (`0xFD00`)
and the Altair monitor (`0xF800`).
Load their HEX files with offset 0, enable the `0x10`/`0x11` console, open the terminal and jump to the stated entry
point. TURMON takes octal addresses; TURMONH takes hexadecimal addresses. Other monitors, including CUTER and the
improved loader/monitor ROMs, have their own I/O and origin settings in the supplied sources and manuals.

### Standalone FOCAL

The [FOCAL archive][pkg-focal]{:target="_blank"} supplies `focal.bin`: reset, select bank 0, load it at `0x0000`,
then jump to `0x0000` and run. For `focal_ent.bin`, apply the I/O patches listed in the archive's `focal` script
before starting; the patch offsets differ from those of the BASIC images above.

## 8080 with 88-MDS minidisks

![Computer schema for 8080 Minidisk BASIC with 88-MDS and ADM-3A]({{ site.baseurl }}/assets/altair8800/software-schema-minidisk.png){:style="max-width:767px"}

### Minidisk BASIC

Download [More original software][pkg-althdsw]{:target="_blank"} (`althdsw.zip`), which contains `mini0.dsk`
through `mini4.dsk` and Mini-Disk BASIC 300-5-E.

1. Open the 8080 **MITS Altair8800** with 65536 bytes and one bank. In a copied configuration, replace 88-DCDD
   with **88-MDS** and connect it to CPU. Both controllers use `0x08`–`0x0A`; keep only 88-MDS connected.
   Save and reopen the computer.
2. Enable 88-SIO `0x10`/`0x11`, uppercase input and clear output bit 8. Open ADM-3A with half-duplex disabled.
3. Use 35 tracks, 16 sectors per track and 137 bytes per sector. Mount `mini0.dsk` through `mini4.dsk` in drives 0–4.
4. Reset, select bank 0 and load [original `DBL.HEX`][mini-dbl]{:target="_blank"} through byte-memory at offset `0`.
   Replace `DB FF` at `0xFF22` with `3E 00` and set a breakpoint at `0x5452`.
5. Jump to `0xFF00` and run. At the breakpoint, replace `DB FF` at `0x5452` with `3E 08`, remove the breakpoint
   and resume.
6. Answer memory `61440`, lineprinter `C`, highest disk `4`, files `4`, random files `4`.
   At `OK`, use `MOUNT n` and `FILES n` for each drive, then `RUN "name"`.

An initial drive-0 mount I/O error can occur.

The patch addresses apply to the files in `althdsw.zip`. Apply the patches after each cold boot.

The supplied minidisk-capable loader is different from the bundled simplified `dbl.bin`. Additional minidisk BASIC,
CP/M and transfer tools are in the [minidisk archive][clone-mini]{:target="_blank"}; use the [88-MDS manual][mds-manual]{:target="_blank"}
for its disk layout.

![Minidisk BASIC disk directory in emuStudio]({{ site.baseurl }}/assets/altair8800/software-minidisk-basic.png){:style="max-width:737px"}

## 8080 with MITS hard disks

![Computer schema for 8080 Hard Disk BASIC with 88-4PIO, MITS 88-HDSK and ADM-3A]({{ site.baseurl }}/assets/altair8800/software-schema-mits-hard-disk.png){:style="max-width:767px"}

### Hard Disk BASIC and accounting software

The [more original software archive][pkg-althdsw]{:target="_blank"} contains `hdbasic-300-5-c-acct.dsk` and
`hdbasic-300-5-f.dsk`. More accounting and data images are in [DeRamp's hard-disk BASIC directory][deramp-hdbasic]{:target="_blank"}.
These are original MITS platter images, not Schorn's SIMH `i.dsk`.

1. Open the 8080 **MITS Altair8800** with **65536 bytes** and **1 memory bank**. Enable 88-SIO `0x10`/`0x11`,
   uppercase input and clear output bit 8; open ADM-3A with half-duplex disabled.
2. In a copied configuration, select **MITS** mode for 88-HDSK and connect it to 88-4PIO and CPU.
   Set 88-4PIO to base `0xA0` with two PIAs. Save and reopen the computer.
3. Mount `hdbasic-300-5-c-acct.dsk` as unit 0 removable (`image0`) and `hdbasic-300-5-f.dsk` as unit 0 fixed
   (`image1`). Use **406 cylinders**, **2 surfaces**, **24 sectors** and **256 bytes per sector**.
4. Reset, select bank 0 and load [original `HDBL.HEX`][hdbl]{:target="_blank"} through byte-memory at offset `0`.
5. Set a breakpoint at `0x7289` for the `c-acct` image (`0x7286` for the `f` image). Jump to `0xFC00` and run.
   At the breakpoint, replace `DB FF` with `3E 08`, remove the breakpoint and resume.
6. Answer memory `61440`, lineprinter `C`, highest disk `0`, files `6`. The accounting disk also asks for a date
   (e.g. `9`, `10`, `78`). At `OK`, type `MOUNT 0` and `FILES 0`.
7. Start an accounting module with `RUN "AP MENU"`, for example. Passwords are module initials plus `TEST`,
   such as `APTEST`. Keep working platter copies: accounting programs modify records.

Printing requires a printer device. See the linked notes for modules and data disks.

See the [hard-disk contents and passwords][hd-contents]{:target="_blank"} and
[floppy accounting notes][accounting]{:target="_blank"}.

## Software requiring other hardware

Some software needs devices or services absent from the standard Altair schema; changing an image filename or geometry
cannot replace a missing controller or simulator service.

|---
| Download or family | Requirement and execution route
|-|-
| [Burcon CP/M][pkg-burcon]{:target="_blank"} | `DIR` returns `Bdos Err On A: Bad Sector` in emuStudio. Its BIOS requires additional sector validation.
| [MP/M II][pkg-mpm]{:target="_blank"} | Requires banked memory (common boundary `0xB000`), `mpm.dsk`, SIMH `i.dsk` and four telnet terminals. The standard schema lacks its multi-terminal SIO setup.
| [CP/NET and CPNOS][pkg-cpnet]{:target="_blank"} | Require SIMH's NET socket device; ordinary emuStudio SIO does not provide it.
| [CompuPro CP/M Plus][pkg-cpmplus]{:target="_blank"} | Requires I8272, DISK1A/DISK2, SystemSupport1 serial devices and IMD media; distinct from runnable Schorn Altair `cpm3.dsk`.
| [UCSD Pascal II.0][pkg-ucsd]{:target="_blank"} and [additional source disks][pkg-ucsddsk]{:target="_blank"} | Needs its special drive mapping: `ucsd.dsk` in floppy 4, `dsk0.dsk`/`dsk1.dsk` as SIMH hard disks, then `PASCAL`. Raw `.gz` source disks are not CP/M floppies.
| Schorn's `appleiicpm.dsk`, `128sssd.imd` and `JRTPAS30.IMD` | Require Apple II or ImageDisk format/mapping; do not mount IMD as raw 137-byte-sector media.
| [Other Schorn operating systems][schorn-os2]{:target="_blank"} | CompuPro, Cromemco, North Star, Vector Graphic, CP/M-86, 86-DOS, MS-DOS and CP/M-68K need other processors/controllers.
| DeRamp North Star and iCOM disk trees | Require North Star, Tarbell or iCOM controllers. `.dsk`/`.nsi` extensions do not make these 88-DCDD images.
| [Paper tape and cassette releases][deramp-tapes]{:target="_blank"}, including MITS BASIC 1.0 | Require matching `.tap` bootstrap and a console switch register, which the standard schema lacks. Tape records contain addresses and checksums; use the disk/memory alternatives above where available.
| [Front-panel programs][front-panel]{:target="_blank"}, cassette, printer, music and speech programs | Kill-the-Bit and Pong require physical switches/lights; other programs require their named hardware. A terminal only supports serial text when ports match.
| [Disk and transfer utilities][deramp-utils]{:target="_blank"} | Physical floppy/serial-transfer tools require the controller and load address named in their source.
|---

## When a program does not start

If nothing appears, check the bootloader/entry address, drive 0 image, serial ports and memory banks. Match the
loader and BIOS to the disk: Schorn's current CP/M uses `mdbl.bin`, while MITS BASIC needs Disk BASIC. For garbled
screens select the configured terminal (often VT100); for CP/M `NAME?`, check `DIR`, drive and user area. Missing
application files usually mean overlays/data are on the wrong drive or the disk format is wrong. BASIC memory
answers use bytes or kilobytes as specified; reapply standalone console patches after reset.

[schorn-software]: https://schorn.ch/altair_3.php
[schorn-os]: https://schorn.ch/altair_4.php
[schorn-os2]: https://schorn.ch/altair_5.php
[schorn-langs]: https://schorn.ch/altair_6.php
[schorn-office]: https://schorn.ch/altair_7.php
[schorn-games]: https://schorn.ch/altair_8.php
[aclone]: https://altairclone.com/downloads/
[deramp]: https://deramp.com/downloads/altair/software/
[cpmtools]: https://www.moria.de/~michael/cpmtools/
[simhmanual]: https://github.com/open-simh/simh/blob/master/doc/altairz80_doc.docx
[cpm22]: https://deramp.com/downloads/altair/software/manuals/CPM%202.2%20Manual.pdf
[cpm3manual]: http://www.cpm.z80.de/manuals/cpm3-usr.pdf
[altairmanual]: https://altairclone.com/downloads/manuals/Altair%20DOS%20User%27s%20Manual.pdf
[basic]: https://deramp.com/downloads/altair/software/manuals/BASIC%20Manual%2077%20(4.1).pdf
[manuals]: https://deramp.com/downloads/altair/software/manuals/
[mini-dbl]: https://altairclone.com/downloads/roms/DBL.HEX
[hdbl]: https://deramp.com/downloads/altair/software/roms/orginal_roms/HDBL.HEX
[clone-basic]: https://altairclone.com/downloads/basic/
[deramp-basic]: https://deramp.com/downloads/altair/software/8_inch_floppy/BASIC/
[clone-mini]: https://altairclone.com/downloads/minidisk/
[mds-manual]: https://deramp.com/downloads/altair/hardware/minidisk/88-MDS%20Minidisk%20Manual.pdf
[deramp-hdbasic]: https://deramp.com/downloads/altair/software/hard_disk/BASIC/
[hd-contents]: https://deramp.com/downloads/altair/software/hard_disk/BASIC/Hard%20Disk%20Content.txt
[accounting]: https://deramp.com/downloads/altair/software/8_inch_floppy/BASIC/Accounting/
[deramp-cpm]: https://deramp.com/downloads/altair/software/8_inch_floppy/CPM/
[cpu-tests]: https://altairclone.com/downloads/cpu_tests/
[cpu-test-notes]: https://altairclone.com/downloads/cpu_tests/%2BREADME.TXT
[88-dcdd-cpm]: {{ site.baseurl }}/altair8800/88-dcdd#experimental-cpm-support
[simh-device]: {{ site.baseurl }}/altair8800/simh-pseudo
[deramp-tapes]: https://deramp.com/downloads/altair/software/papertape_cassette/
[clone-roms]: https://altairclone.com/downloads/roms/
[front-panel]: https://altairclone.com/downloads/front_panel/
[deramp-utils]: https://deramp.com/downloads/altair/software/utilities/
[ps2-disk]: https://altairclone.com/downloads/mits_programming_package/floppy_drive_support/
[ps2-readme]: https://altairclone.com/downloads/mits_programming_package/floppy_drive_support/ReadMe.pdf
[pkg-altsw]: https://schorn.ch/cpm/zip/altsw.zip
[pkg-burcon]: https://schorn.ch/cpm/zip/burcon.zip
[pkg-minolvtl]: https://schorn.ch/cpm/zip/minolvtl.zip
[pkg-althdsw]: https://schorn.ch/cpm/zip/althdsw.zip
[pkg-cpm1]: https://schorn.ch/cpm/zip/cpm1.zip
[pkg-cpm2]: https://schorn.ch/cpm/zip/cpm2.zip
[pkg-cpnet]: https://schorn.ch/cpm/zip/cpnet.zip
[pkg-pcpm]: https://schorn.ch/cpm/zip/pcpm.zip
[pkg-cpm3]: https://schorn.ch/cpm/zip/cpm3.zip
[pkg-mpm]: https://schorn.ch/cpm/zip/mpm.zip
[pkg-dosplus]: https://schorn.ch/cpm/zip/dosplus.zip
[pkg-novados]: https://schorn.ch/cpm/zip/novados.zip
[pkg-p2dos]: https://schorn.ch/cpm/zip/p2dos.zip
[pkg-qpm]: https://schorn.ch/cpm/zip/qpm.zip
[pkg-superdos]: https://schorn.ch/cpm/zip/superdos.zip
[pkg-z80dos]: https://schorn.ch/cpm/zip/z80dos.zip
[pkg-zsdos]: https://schorn.ch/cpm/zip/zsdos.zip
[pkg-nzcom]: https://schorn.ch/cpm/zip/nzcom.zip
[pkg-z3plus]: https://schorn.ch/cpm/zip/z3plus.zip
[pkg-rcl_z3plus_cpm3_2017]: https://schorn.ch/cpm/zip/rcl_z3plus_cpm3_2017.zip
[pkg-turbodos]: https://schorn.ch/cpm/zip/turbodos.zip
[pkg-zcpr3]: https://schorn.ch/cpm/zip/zcpr3.zip
[pkg-act]: https://schorn.ch/cpm/zip/act.zip
[pkg-ada]: https://schorn.ch/cpm/zip/ada.zip
[pkg-algol]: https://schorn.ch/cpm/zip/algol.zip
[pkg-apl]: https://schorn.ch/cpm/zip/apl.zip
[pkg-basic]: https://schorn.ch/cpm/zip/basic.zip
[pkg-basiccollection]: https://schorn.ch/cpm/zip/basiccollection.zip
[pkg-bdsc]: https://schorn.ch/cpm/zip/bdsc.zip
[pkg-aztechitechc]: https://schorn.ch/cpm/zip/aztechitechc.zip
[pkg-cobol]: https://schorn.ch/cpm/zip/cobol.zip
[pkg-comal]: https://schorn.ch/cpm/zip/comal.zip
[pkg-focal]: https://schorn.ch/cpm/zip/focal.zip
[pkg-forth]: https://schorn.ch/cpm/zip/forth.zip
[pkg-fortran]: https://schorn.ch/cpm/zip/fortran.zip
[pkg-lisp]: https://schorn.ch/cpm/zip/lisp.zip
[pkg-modula2]: https://schorn.ch/cpm/zip/modula2.zip
[pkg-mumps]: https://schorn.ch/cpm/zip/mumps.zip
[pkg-musimp]: https://schorn.ch/cpm/zip/musimp.zip
[pkg-pascal]: https://schorn.ch/cpm/zip/pascal.zip
[pkg-ucsd]: https://schorn.ch/cpm/zip/ucsd.zip
[pkg-ucsddsk]: https://schorn.ch/cpm/zip/ucsddsk.zip
[pkg-pilot]: https://schorn.ch/cpm/zip/pilot.zip
[pkg-pli]: https://schorn.ch/cpm/zip/pli.zip
[pkg-plm]: https://schorn.ch/cpm/zip/plm.zip
[pkg-plmx]: https://schorn.ch/cpm/zip/plmx.zip
[pkg-spl]: https://schorn.ch/cpm/zip/spl.zip
[pkg-dbase]: https://schorn.ch/cpm/zip/dbase.zip
[pkg-wordstar]: https://schorn.ch/cpm/zip/wordstar.zip
[pkg-ws33]: https://schorn.ch/cpm/zip/ws33.zip
[pkg-vedit]: https://schorn.ch/cpm/zip/vedit.zip
[pkg-multiplan]: https://schorn.ch/cpm/zip/multiplan.zip
[pkg-supercalc]: https://schorn.ch/cpm/zip/supercalc.zip
[pkg-games]: https://schorn.ch/cpm/zip/games.zip
[pkg-tools]: https://schorn.ch/cpm/zip/tools.zip
[pkg-cpmplus]: https://schorn.ch/cpm/zip/cpmplus.zip
