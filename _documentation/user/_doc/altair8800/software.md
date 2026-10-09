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
computers sometimes needs a different disk controller, terminal or processor, even if it is also called CP/M.

The following sites provide disk images, memory images, source code and manuals:

- Peter Schorn: [original Altair8800 software][schorn-software]{:target="_blank"},
  [operating systems][schorn-os]{:target="_blank"}, [programming languages][schorn-langs]{:target="_blank"},
  [office applications][schorn-office]{:target="_blank"}, [games and tools][schorn-games]{:target="_blank"}.
- [Altair clone downloads][aclone]{:target="_blank"}.
- [DeRamp Altair software archive][deramp]{:target="_blank"}.

The following subsections describe emuStudio setup and execution. Device requirements are listed in
[Software requiring other hardware](#software-requiring-other-hardware).

## Downloading and preparing software

To download one of Schorn's packages, please follow these steps:

1. Follow the download link in the appropriate table below and save the ZIP file.
2. Extract the ZIP into its own directory. Keep its disk images, supporting files and documentation together.
3. Make working copies of the disk images before mounting them. Guest programs write directly to mounted images.
4. Start emuStudio and choose **MITS Altair8800 (Z80)** for the CP/M collections, or the 8080 computer for original
   MITS software. Use a copy of the computer configuration when changing its devices.
5. Stop the emulation before changing memory, disks or settings. Apply the setup described below, then follow the
   steps for the chosen system or application. Wait for each prompt before typing the next answer.

For example, on Linux, the following commands download and extract CP/M 2.2 and the games package:

```sh
mkdir -p ~/Downloads/altair8800-software/packages/cpm2
mkdir -p ~/Downloads/altair8800-software/packages/games
cd ~/Downloads/altair8800-software/packages/cpm2
curl -fLO https://schorn.ch/cpm/zip/cpm2.zip
unzip cpm2.zip
cp cpm2.dsk cpm2-work.dsk
cd ../games
curl -fLO https://schorn.ch/cpm/zip/games.zip
unzip games.zip
cp games.dsk games-work.dsk
```

Mount the working copies, keeping the downloaded originals.

Schorn's extensionless files, such as `cpm2`, `basic` and `wordstar`, are command scripts for SIMH. They describe the
required hardware and mounts; they are not executable programs for emuStudio. The following tables translate those
scripts into emuStudio settings and guest commands.

### File formats

|---
| File | How to use it
|-|-
| Raw disk image, usually `.dsk` | Mount in the specified disk device. The filename extension does not identify its geometry or filesystem.
| Raw memory image, `.bin` | Load through the byte-memory GUI at the address stated below, in bank 0.
| Intel HEX, `.hex` | Load through the byte-memory GUI with offset `0`; the records supply the addresses. Do not add the ROM address again.
| CP/M `.com` | Copy into a CP/M disk and execute at the CP/M prompt, usually without `.COM`. Only a file explicitly supplied as a boot ROM, such as `cpm1rom.com`, is loaded directly into memory.
| BASIC `.bas`, VTL `.vtl`, assembly `.asm` | Source text for the matching interpreter or assembler. These are not memory images.
| MITS paper tape, `.tap` or binary tape records | Feed through the appropriate tape loader or use a supplied memory/disk version. Loading the whole tape as raw memory does not extract its program.
| `.wav` cassette recording | Play through the cassette interface with its matching bootstrap loader; it is not a raw paper tape.
| `.imd`, `.nsi`, `.raw.gz` | ImageDisk, North Star or compressed image formats. They cannot be mounted as ordinary Altair raw disks without a suitable conversion and controller.
|---

## Computer setup

Open a plugin's settings from the emuStudio plugin controls. In the byte-memory window, click the wrench toolbar
button to set memory banks and startup images. When a change requires reopening the computer, save the configuration
and close and reopen it before loading the images.

### CPU and operating memory

Use Z80 for Schorn's CP/M applications. Some programs use Z80 instructions and will not work on the 8080 computer.
Set memory size to `65536` bytes. For CP/M 2.2 and original MITS software, set **1 memory bank**. For banked CP/M 3,
set **8 banks** and **common address `0xC000`**. Leave the SIMH pseudo device connected to CPU and memory: the
banked BIOS uses it to select memory banks.

![CP/M 2.2 memory banks and boot image settings]({{ site.baseurl }}/assets/altair8800/software-byte-mem-settings.png){:style="max-width:858px"}

### Serial I/O and terminal

For Schorn CP/M disks, leave these 88-SIO port aliases enabled:

- status: `0x10, 0x14, 0x16, 0x18`;
- data: `0x11, 0x15, 0x17, 0x19`.

For Altair DOS and original Disk BASIC, also add status port `0x00` and data port `0x01`. Keep the status and data
lists paired in the same order. Original BASIC can put the high bit on output characters; enable **clear output
bit 8** in 88-SIO if the text contains unexpected characters. For MITS software, enable uppercase input and use
`UNCHANGED` for Delete and Backspace initially. Keep terminal half-duplex disabled.

![88-SIO console port aliases for CP/M]({{ site.baseurl }}/assets/altair8800/software-88-sio-settings.png){:style="max-width:488px"}

ADM-3A is suitable for the operating-system prompts and many text programs. Schorn's WordStar, VEDIT, Multiplan,
SuperCalc2 and Turbo Pascal are configured for VT100. To use them, please follow these steps:

1. Close the running computer and open its copied configuration in the schema editor.
2. Replace `adm3A-terminal` with `vt100-terminal`.
3. Connect VT100 to 88-SIO in both directions. Keep one terminal on that connection.
4. Save and reopen the computer. Open the VT100 window before starting emulation.

The terminal changes the display and keyboard handling; the CPU port settings remain the same.

### Floppy disks

For 88-DCDD images, use **32 sectors per track** and **137 bytes per sector**, including Schorn's enlarged CP/M
images. Their BIOS provides a larger logical disk than the original 77-track media. Do not truncate an enlarged
image to the size of a physical Altair floppy. The guest BIOS interprets the sector payload and skew.

![88-DCDD mounted system disk and sector settings]({{ site.baseurl }}/assets/altair8800/software-88-dcdd-settings.png){:style="max-width:599px"}

Minidisk images use the separate **88-MDS** plugin: 35 tracks, 16 sectors per track, 137 bytes per sector. Replace
88-DCDD with 88-MDS and connect it to the CPU. Both controllers use ports `0x08` through `0x0A`, so connect only the
one required by the software. The 88-4PIO used by MITS hard disks stays at `0xA0` through `0xA7`.

### Hard disks

Schorn's `i.dsk` and `j.dsk` use the **SIMH** hard-disk interface. They are different from MITS hard-disk images.
The bundled computer configuration may select MITS mode, which is intended for original Hard Disk BASIC.

To mount a Schorn SIMH hard disk, please follow these steps:

1. In the copied configuration, select `SIMH` as the 88-HDSK controller type (`controllerType = "SIMH"`).
2. In the schema, connect 88-HDSK to the CPU and byte-memory in both directions. Its SIMH controller uses CPU port
   `0xFD` and accesses memory directly.
3. Save and reopen the computer. In the 88-HDSK device window, mount `i.dsk` in drive 0. Leave the default geometry
   of 32 sectors per track and 128 bytes per sector for these SIMH images.
4. Boot the matching floppy disk as described below. The supplied CP/M 2.2 BIOS exposes drive 0 as `I:` and drive 1
   as `J:`; CP/M 3 supplies four hard-disk letters `I:` through `L:`.
5. At the CP/M prompt type `I:` and then `DIR` to inspect the disk.

These disks are optional for the basic CP/M boot and most application packages. Mount them when the table or the
package's script calls for them. Apple II and ImageDisk images in the CP/M archives require other formats; mounting
one with the default SIMH geometry does not make it compatible.

## Boot ROM

Booting operating systems on Altair requires a special ROM image to be loaded in operating memory. Its purpose is
to load some blocks of data from a disk device and then execute them. The code block is often called a 'bootloader'.
A bootloader is device-specific, and often also disk format-specific.

The following table lists the bootloaders used on this page:

|---
| Bootloader | Load address | Use
|-|-|-
| `examples/altair8800/boot/dbl.bin` | `0xFF00` | Original 88-DCDD-format disks: `altcpm.dsk`, `altdos.dsk`, `mbasic.dsk` and the native floppy BASIC disks.
| `examples/altair8800/boot/mdbl.bin` | `0xFF00` | Schorn's current `cpm2.dsk`, `cpm3.dsk` and the larger CP/M-family disks. Works with one bank as well as banked memory.
| `cpm1rom.com` from [CP/M 1.4][pkg-cpm1]{:target="_blank"} | `0xFF00` | The supplied `cpm1.dsk`; this package needs its own loader.
| `dbl.bin` from [Burcon CP/M][pkg-burcon]{:target="_blank"} | `0xFF00` | Burcon's `cpm.dsk`, paired with the BIOS in that archive.
| [Original `DBL.HEX`][mini-dbl]{:target="_blank"} | Addresses in HEX (`0xFF00`) | Minidisk-capable MITS loader, with the console patch described in the minidisk section.
| [Original `HDBL.HEX`][hdbl]{:target="_blank"} | Addresses in HEX (`0xFC00`) | MITS hard-disk boot loader and monitor, for Hard Disk BASIC.
|---

The bundled bootloaders have assembly source which can be modified to user needs. The two bundled loaders are not
interchangeable for every image: `dbl.bin` does not boot Schorn's current `cpm2.dsk`.

To load a binary boot ROM, please follow these steps:

1. Reset the computer before loading the images.
2. Open the byte-memory GUI and select bank 0.
3. Use **Load image**, choose the bootloader and set the load address to `0xFF00`.
4. Mount the chosen system disk in drive `A:` (drive 0) of 88-DCDD.
5. Show the terminal window, jump to location `0xFF00` in the emuStudio debugger, and run emulation.
6. Wait for the system's prompt. Type commands into the terminal, not the source editor.

For a HEX file, use load offset `0` and jump to its stated entry point. Memory settings can also load images at
startup with `imageName0`, `imageAddress0` and `imageBank0 = 0`. A reset reloads configured startup images; reload
manually loaded images after resetting if necessary.

## CP/M 2.2

Schorn's [CP/M 2.2 archive][pkg-cpm2]{:target="_blank"} supplies `cpm2.dsk`, utilities and SIMH support.
Use this disk for the application tables below.

To run Schorn CP/M 2.2, please follow these steps:

1. Set Z80, 64K memory, one bank, and the serial and floppy settings described above.
2. Load `mdbl.bin` into bank 0 at `0xFF00`.
3. Mount `cpm2.dsk` in 88-DCDD drive `A:`. Optionally mount `app.dsk` from the same archive in drive `B:`.
4. Open the terminal, jump to `0xFF00`, and run the emulation.
5. Wait for `64K CP/M Version 2.2` and the `A>` prompt.
6. Type `DIR` to list the disk, or `LS` for the supplied directory utility. Type `B:` and then `DIR` to inspect
   `app.dsk`, if mounted.

The following image shows `DIR` at the CP/M command prompt:

![Operating system CP/M 2.2]({{ site.baseurl }}/assets/altair8800/software-cpm22.png){:style="max-width:737px"}

Commands are followed by Enter. `DIR B:` lists another drive without changing the current drive. `USER 1` selects
user area 1; use `USER 0` to return. `TYPE filename` displays text, and `PIP` copies files. More information can be
found in the [CP/M 2.2 manual][cpm22]{:target="_blank"}.

The boot disk includes Microsoft BASIC, ELIZA, Star Trek, Othello and Ladder. For example, type `MBASIC ELIZA` to
start ELIZA, or `OTHELLO` to start Othello. The optional `app.dsk` contains PROLOGZ, Pascal MT+ and SPL; see the
programming-language table for their commands.

## CP/M 3

Schorn's [CP/M 3 archive][pkg-cpm3]{:target="_blank"} contains a banked system with an Altair BIOS.
It needs the SIMH pseudo device and `mdbl.bin`.

To boot it, please follow these steps:

1. Choose the Z80 computer. Set memory to 64K, **8 banks**, and **common address `0xC000`**.
2. Keep SIMH pseudo connected to the CPU and memory.
3. Load `examples/altair8800/boot/mdbl.bin` into bank 0 at `0xFF00`.
4. Mount `cpm3.dsk` in 88-DCDD drive `A:`. Use 32 sectors per track and 137 bytes per sector.
5. Open the terminal, jump to `0xFF00`, and run the emulation.
6. Wait for the loader messages and `A>` prompt. Type `DIR` or `HELP`.

![CP/M 3 memory banks and common boundary settings]({{ site.baseurl }}/assets/altair8800/software-cpm3-memory-settings.png){:style="max-width:858px"}

![Operating system CP/M 3 (banked version)]({{ site.baseurl }}/assets/altair8800/software-cpm3.png){:style="max-width:737px"}

The application tables use CP/M 2.2 unless specified otherwise. See the [CP/M 3 manual][cpm3manual]{:target="_blank"}
and [SIMH AltairZ80 manual][simhmanual]{:target="_blank"} for the BIOS and additional disk formats.

## Other CP/M operating systems

Schorn supplies complete boot disks for many CP/M replacements. For the one-bank rows in the following table,
use the CP/M 2.2 computer setup and `mdbl.bin`; replace the drive `A:` image with the image shown. For the eight-bank
rows, use the CP/M 3 setup. Mount any indicated second floppy in `B:` before booting. The optional SIMH hard disks
use the setup described above. Then open the terminal, jump to `0xFF00`, run, and wait for the command prompt.

|---
|Download | Drive A:; additional disks | Memory banks and startup
|-|-|-
|[CP/M 1.4][pkg-cpm1]{:target="_blank"} | `cpm1.dsk`; `cpm1b.dsk` | 1; use `cpm1rom.com`
|[Burcon CP/M][pkg-burcon]{:target="_blank"} | `cpm.dsk`; `sysgen.dsk` | 1; use package `dbl.bin`
|[Personal CP/M][pkg-pcpm]{:target="_blank"} | `pcpm.dsk` | 1
|[DOS+][pkg-dosplus]{:target="_blank"} | `dosplus.dsk`; optional SIMH `i.dsk` | 1
|[NovaDOS][pkg-novados]{:target="_blank"} | `novados.dsk`; `novadosb.dsk` | 1
|[P2DOS][pkg-p2dos]{:target="_blank"} | `p2dos.dsk`; `p2dosb.dsk`; optional SIMH `i.dsk` | 1
|[QP/M 2.7][pkg-qpm]{:target="_blank"} | `qpm.dsk` | 1
|[SuperDOS][pkg-superdos]{:target="_blank"} | `superdos.dsk`; `superdosb.dsk` | 1
|[Z80DOS][pkg-z80dos]{:target="_blank"} | `z80dos.dsk`; `z80dosb.dsk` | 1
|[ZSDOS][pkg-zsdos]{:target="_blank"} | `zsdos.dsk`; optional SIMH `i.dsk` | 1
|[NZ-COM][pkg-nzcom]{:target="_blank"} | `nzcom.dsk`; `nzcomb.dsk`; optional SIMH `i.dsk` | 1; then `STARTZCM`
|[Z3PLUS][pkg-z3plus]{:target="_blank"} | `z3plus.dsk`; `z3plusb.dsk`; optional SIMH `i.dsk` | 8; then `STARTZ3P`
|[RCL Z3PLUS collection][pkg-rcl_z3plus_cpm3_2017]{:target="_blank"} | `z3plus.dsk`; `disk__RCL_Empty_Scratch_Disk_1mb.dsk` | 8; nested `rcl_z3plus_cpm3_2017/` directory
|[TurboDOS 1.22P][pkg-turbodos]{:target="_blank"} | package `cpm2.dsk`; SIMH `i.dsk` and `j.dsk` | 1; then `TURBODOS`
|[ZCPR3][pkg-zcpr3]{:target="_blank"} | package `cpm2.dsk`; SIMH `i.dsk` and `j.dsk` | 1; consult package notes before replacing the CCP
|---

CP/M 1.4 uses a different disk layout: load `cpm1rom.com` as raw memory at `0xFF00`, mount `cpm1.dsk` in `A:` and
`cpm1b.dsk` in `B:`, jump to `0xFF00`, and run. Its `cpm1dev.dsk` is a separate CP/M 2.2 development disk for rebuilding
the 1.4 system; use `mdbl.bin` for that disk.

Burcon's package contains `dbl.bin`, `cpm.dsk`, `sysgen.dsk` and instructions for rebuilding its BIOS. Load the
package's own `dbl.bin` at `0xFF00`, mount `cpm.dsk` in `A:` and `sysgen.dsk` in `B:`, and boot with one memory bank.
Burcon disk access returns `Bdos Err On A: Bad Sector` in emuStudio. Use the Schorn CP/M 2.2 setup above
for emuStudio applications.

For NZ-COM, boot its disk, then type `STARTZCM`. For Z3PLUS, boot with eight banks, then type `STARTZ3P`. The RCL
collection uses the same banked setup and also supplies two SIMH hard disks full of utilities. Mount those in 88-HDSK
drives 0 and 1; they appear as `I:` and `J:`. Type `DIR I:` or `DIR J:` and use `USER n` to select a listed user area.

TurboDOS first boots CP/M from its own `cpm2.dsk`. Mount its `i.dsk` and `j.dsk` as SIMH hard disks, then type
`TURBODOS` at `A>`. This is the supplied single-user setup; it does not establish a multi-terminal installation.
MP/M and CP/NET require additional facilities and are described below.

## Altair DOS v1.0

Altair DOS is in [Original Altair software][pkg-altsw]{:target="_blank"} (`altdos.dsk`, `altdos2.dsk`). It runs directly
on the computer, without CP/M.

To boot it, please follow these steps:

1. Use one memory bank. In 88-SIO add status port `0x00` and data port `0x01` to the existing lists.
2. Load the bundled `dbl.bin` at `0xFF00`.
3. Mount `altdos.dsk` in 88-DCDD drive `A:`. Optionally mount `altdos2.dsk` in `B:`.
4. Open the terminal, jump to `0xFF00`, and run.
5. Answer the startup questions, pressing Enter after each answer:

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

## BASIC

MITS Disk BASIC runs directly on Altair; it does not run under CP/M. Microsoft `MBASIC.COM` in the CP/M collections
is a different program. A disk for one environment is not automatically readable in the other.

### MITS Disk BASIC

MITS BASIC 4.1 is in [Original Altair software][pkg-altsw]{:target="_blank"} as `mbasic.dsk`. To boot it, please follow
these steps:

1. Set one memory bank and add 88-SIO status `0x00` and data `0x01` aliases.
2. Load the bundled `dbl.bin` at `0xFF00` and mount `mbasic.dsk` in 88-DCDD drive `A:`.
3. Open the terminal, jump to `0xFF00`, and run.
4. Answer the startup questions as follows, waiting for each next prompt:

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

The `disbas50.dsk` image in `altsw.zip` is paired with `disbas50.bin`. Load that binary at `0x0000`, apply the console
patch in the next section at `0x534F`, mount its disk in drive 0, and start at `0x0000`. Answer the disk questions
as above, then `MOUNT 0` and `FILES`. This is a separate way to start BASIC 5.0, not a CP/M application.

### 4K, 8K and Extended BASIC memory images

The [original software archive][pkg-altsw]{:target="_blank"} also contains BASIC as raw memory images. They normally
read the physical Altair sense switches to choose their console. The emuStudio computer has no front-panel sense
switch device on port `0xFF`; the unconnected port reads `0xFF`. To select the emulated 2SIO console, replace the
specified `IN 0xFF` instruction with `MVI A,0x08` in memory. This supplies the switch value used by the package's
SIMH scripts without adding a device.

To run one of these images, please follow these steps:

1. Choose the **8080** computer and use 64K memory with one bank. Stop and reset the computer.
2. Open byte-memory, select bank 0, and load the selected `.bin` at `0x0000`.
3. In the memory editor, change the two bytes `DB FF` at the indicated address to `3E 08`. Change only the listed
   console-selection instructions. Keep the downloaded file unchanged.
4. Enable 88-SIO status `0x10` and data `0x11`, uppercase input, and clear output bit 8.
5. Open the terminal, jump to `0x0000`, and run.
6. Answer `MEMORY SIZE?` with `61440`. Answer `TERMINAL WIDTH?` with `80` if asked, and the trigonometric-functions
   question with `Y`. Wait for `OK` before entering a program.
7. Type `PRINT 2+2`; the result should be `4`. For a small program, enter `10 PRINT "HELLO"`, then `RUN`.

|---
| Binary | Version | Address of console patch
|-|-|-
| `4kbas32.bin` | 4K BASIC 3.2 | `0x0D34` and `0x0D45`
| `4kbas40.bin` | 4K BASIC 4.0 | `0x0D24`
| `8kbas.bin` | 8K BASIC 4.0 | `0x193A`
| `exbas.bin` | Extended BASIC 4.0 | `0x38EB`
| `disbas50.bin` | Disk Extended BASIC 5.0 | `0x534F`; also mount `disbas50.dsk`
|---

These patch addresses refer only to the named binaries in `altsw.zip`. Other releases and ROM versions have different
addresses. For a different image, use its supplied source and loader instructions rather than applying these offsets.

### Minidisk BASIC

The [more original software archive][pkg-althdsw]{:target="_blank"} contains `mini0.dsk` through `mini4.dsk` and
Mini-Disk BASIC 300-5-E. To prepare it, please follow these steps:

1. Choose the **8080** computer. Replace 88-DCDD with 88-MDS in a copied schema and connect it to the CPU.
   Use one memory bank and the 2SIO console at `0x10`/`0x11`.
2. Mount `mini0.dsk` through `mini4.dsk` in minidisk drives 0 through 4.
3. Load [original `DBL.HEX`][mini-dbl]{:target="_blank"} through byte-memory with offset `0`.
4. Change bytes `DB FF` at `0xFF22` to `3E 00`, selecting the 2SIO console at `0x10`/`0x11`.
5. Set a debugger breakpoint at `0x5452`, the BASIC console-selection instruction in `mini0.dsk`. To select
   that address, use the debugger jump control, toggle its breakpoint, then jump back to `0xFF00`.
6. Open the terminal and run. When the CPU pauses at `0x5452`, change `DB FF` at that address to `3E 08` in
   byte-memory, unset the breakpoint, and resume. This patches BASIC itself after the disk loader has loaded it.
7. Answer memory size `61440`, lineprinter `C`, highest disk number `4`, files `4`, and random files `4`.
8. At `OK`, type `MOUNT 0`, then `FILES 0`. Use `MOUNT 1` and `FILES 1` for another drive, and `RUN "name"` for a
   program on the selected BASIC disk. The archive notes that an initial disk I/O error mounting drive 0 can occur.

The patch addresses apply to the files in `althdsw.zip`. Apply the patches after each cold boot.

The supplied minidisk-capable loader is different from the bundled simplified `dbl.bin`. Additional minidisk BASIC,
CP/M and transfer tools are in the [minidisk archive][clone-mini]{:target="_blank"}; use the [88-MDS manual][mds-manual]{:target="_blank"}
for its disk layout.

![Minidisk BASIC disk directory in emuStudio]({{ site.baseurl }}/assets/altair8800/software-minidisk-basic.png){:style="max-width:737px"}

### Hard Disk BASIC and accounting software

The [more original software archive][pkg-althdsw]{:target="_blank"} contains `hdbasic-300-5-c-acct.dsk` and
`hdbasic-300-5-f.dsk`. More accounting and data images are in [DeRamp's hard-disk BASIC directory][deramp-hdbasic]{:target="_blank"}.
These are original MITS platter images, not Schorn's SIMH `i.dsk`.

To prepare this installation, please follow these steps:

1. Choose the **8080** computer with one memory bank and the 2SIO console at `0x10`/`0x11`. Select `MITS` as
   the 88-HDSK controller type. Connect 88-HDSK to **88-4PIO**, and connect 88-4PIO to the CPU.
   Set 88-4PIO base port to `0xA0` with two PIAs. This is the connection used by the bundled MITS configuration.
2. Mount `hdbasic-300-5-c-acct.dsk` as **unit 0 removable** (`image0`) and `hdbasic-300-5-f.dsk` as **unit 0 fixed**
   (`image1`). Each platter uses 406 cylinders, two surfaces, 24 sectors and 256 bytes per sector.
3. Load [original `HDBL.HEX`][hdbl]{:target="_blank"} with memory offset `0`. Set a debugger breakpoint at `0x7289`
   for `hdbasic-300-5-c-acct.dsk`, then jump to `0xFC00` and run. The loader reads the system from the removable platter.
4. When BASIC pauses at `0x7289`, change `DB FF` there to `3E 08` in byte-memory, unset the breakpoint, and resume.
   This selects the 2SIO console. The corresponding instruction in `hdbasic-300-5-f.dsk` is at `0x7286`.
5. Answer memory size `61440`, lineprinter `C`, highest disk number `0` for unit 0, and files `6`. The accounting
   version then asks for the day, month and year. For a demonstration date, answer `9`, `10`, and `78` respectively,
   pressing Enter after each answer. These prompts differ from floppy BASIC's random-file question.
6. At `OK`, use `MOUNT 0` and `FILES 0`. Select an accounting program using its filename with `RUN "name"`.
7. For example, `RUN "AP MENU"` selects Accounts Payable. When a module asks for a password, use its initials
   followed by `TEST`, for example `APTEST`, `ARTEST`, `GLTEST` or `PRTEST`. The accompanying notes describe the modules and required data disks.

See the [hard-disk contents and passwords][hd-contents]{:target="_blank"} and
[floppy accounting notes][accounting]{:target="_blank"}. Keep the working platter images: accounting programs change
records. Printing needs a matching printer connection and is not supplied merely by the terminal window.

## CP/M applications

For the following application tables, use the Schorn CP/M 2.2 boot described above. A common sequence applies to
all ordinary application disks:

1. Download and extract [CP/M 2.2][pkg-cpm2]{:target="_blank"} and the chosen application archive.
2. Mount a working copy of `cpm2.dsk` in 88-DCDD drive `A:` and the application image in `B:`. Use the Z80 computer,
   one memory bank, and `mdbl.bin` at `0xFF00`.
3. If the program is configured for VT100, use the VT100 terminal setup described above.
4. Open the terminal, jump to `0xFF00`, run, and wait for `A>`.
5. Type `B:` and press Enter. At `B>` type `DIR`, then the command in the table. Omit `.COM` when starting a program.
6. Keep the application disk selected while running; overlays, libraries and game data must be on the expected drive.
   Answer the program's questions in the terminal.

A table command separated by `;` means separate commands followed by Enter, not a CP/M command separator.
An application disk normally cannot replace the boot disk. ACT, COMAL, PILOT, SPL, MINOL/VTL and FOCAL development
are exceptions: their supplied images contain a boot system and should be mounted in `A:`.

### Programming languages

|---
|Download | Disk image | Commands after boot
|-|-|-
|[ACT 3.0][pkg-act]{:target="_blank"} | `act.dsk` in A: | `ACT80` for 8080/Z80 assembly; `ACT65`, `ACT68`, `ACT86` are cross-assemblers. Read `TYPE CMDLIST.DOC`.
|[JANUS Ada 1.5][pkg-ada]{:target="_blank"} | `ada.dsk` | `JANUS PRIME`; then `JLINK PRIME`; `PRIME`. The source is `PRIME.PKG`; `C.SUB` supplies the same sequence.
|[Algol-M 1.1][pkg-algol]{:target="_blank"} | `algol.dsk` | `ALGOLM HANOI`; then `RUNALG HANOI`. Read `TYPE ALGSTART.TXT` and `TYPE ALGINTRO.TXT`.
|[APL/Z][pkg-apl]{:target="_blank"} | `apl.dsk` | `APL`; answer its `mmddyy-` date prompt. Read `TYPE APL.DOC` for the keyboard notation.
|[Microsoft and CBASIC variants][pkg-basic]{:target="_blank"} | `basic.dsk` | `MBASIC`; or `MBASIC ELIZA`. Compiler and runtime commands are described below.
|[MTBASIC, S-BASIC, Tarbell BASIC, BBC BASIC][pkg-basiccollection]{:target="_blank"} | `mtbasic.dsk`, `sbasic.dsk`, `tbasic.dsk` or `bbcbasic.dsk` | Mount the chosen image in B:, then `MTBASIC`, `SBASIC`, `TBASIC` or `BBCBASIC`. Keep each interpreter/compiler with its libraries and documentation.
|[BDS C 1.60][pkg-bdsc]{:target="_blank"} | `bdsc160.dsk` | `CC UCASE`; then `CLINK UCASE`; `UCASE`. `bdsc160source.dsk` contains the compiler sources; package `cpm2.dsk` is a boot disk.
|[HI-TECH C 3.09 / Aztec C 1.06D][pkg-aztechitechc]{:target="_blank"} | `hitechc.dsk` or `az106d.dsk` | HI-TECH: `C HELLO.C`; `HELLO`. Aztec: `CC HELLO.C`; `AS HELLO.ASM`; `LN HELLO.O -LC`; `HELLO`. Each disk has `HELLO.SUB`.
|[Microsoft COBOL 4.65][pkg-cobol]{:target="_blank"} | `cobol.dsk` | `COBOL =SQUARO`; `A:L80 SQUARO,CDVT100,COBLIB/S,SQUARO/N/E`; `SQUARO`. Use VT100. `C.SUB` supplies this build sequence.
|[COMAL-80][pkg-comal]{:target="_blank"} | `comal.dsk` in A: | `COMAL`. Use VT100; read `TYPE STARTED.DOC` before starting the interpreter.
|[FOCAL][pkg-focal]{:target="_blank"} | `focal_dev.dsk` in A: | `FOCPM` or `FOCPM2` starts the CP/M versions. Standalone `focal.bin` starts at 0; `focal_ent.bin` needs the I/O patches in its `focal` script.
|[UNIFORTH / Forth-83][pkg-forth]{:target="_blank"} | `forth.dsk` | `UNIFORTH` or `F83`. Read `TYPE README80.TXT`; at the Forth prompt try `2 2 + .`.
|[Microsoft FORTRAN-80][pkg-fortran]{:target="_blank"} | `fortran.dsk` | `F80 =TEST`; `A:L80 TEST,F80LIB/S,FORLIB/S,TEST/N/E`; `TEST`. `C.SUB` contains this sequence; `F80C` is another supplied compiler version.
|[LISP/80 / muLISP-80][pkg-lisp]{:target="_blank"} | `lisp.dsk` | `LISP80` or `MULISP`; the latter displays a `$` prompt.
|[Modula-2 2.01][pkg-modula2]{:target="_blank"} | `modula2.dsk` | `MC ERATOS`; then `ML ERATOS`. Use the supplied `MR` runtime for the resulting module; `MC.SUB` shows the compile/link stages.
|[MUMPS 2.x / 4.06][pkg-mumps]{:target="_blank"} | `mumps2.dsk` or `mumps4.dsk` | `MUMPS`; answer the date prompt. Keep the global-storage files on the mounted disk; `SETGLOB` and `SETUP`/`SETMUMPS` configure them.
|[muSIMP-80][pkg-musimp]{:target="_blank"} | `musimp.dsk` | `MUSIMP`. Read `TYPE !README.TXT` and `TYPE READ.ME`; this package includes symbolic-algebra libraries.
|[Turbo Pascal 1.x / 3.x][pkg-pascal]{:target="_blank"} | `tp1.dsk` or `tp3.dsk` | `TURBO`; answer whether to include error messages. Use VT100. `tp3.dsk` reports 3.01A; `TINST` changes the terminal installation.
|[Pascal MT+ / PROLOGZ][pkg-cpm2]{:target="_blank"} | `app.dsk` | `MTPLUS` for Pascal compilation; `LINKMT` is its linker. `PROLOGZ` starts the Prolog environment; read `TYPE PROLOGZ.TXT`.
|[PILOT / Pascal-Z][pkg-pilot]{:target="_blank"} | `pilot.dsk` in A: | `SAMPLE1` starts a supplied demonstration. `DO PILOT/P SAMPLE1` rebuilds it; `PASCAL` starts Pascal-Z. Read `TYPE README.TXT` and `TYPE PILOT/P.DOC`.
|[Digital Research PL/I-80 1.0 / 1.4][pkg-pli]{:target="_blank"} | `pli10.dsk` or `pli14.dsk` | `PLI SAMPLE` on the 1.4 disk; `LINK SAMPLE`; `SAMPLE`. For 1.0 use a supplied source such as `FACT.PLI`: `PLI FACT`; `LINK FACT`; `FACT`.
|[ISIS-II PL/M-80][pkg-plm]{:target="_blank"} | `plm0.dsk` in A:, `plm1.dsk` in B:, `plm2.dsk` in C:, `plm3.dsk` in D: | Boot A: with `mdbl.bin`, then `ISX`. ISIS uses `:F0:` through `:F3:` for those drives. Read `TYPE README.TXT` and `TYPE MAKEPIP.SUB` before building its sample.
|[SYSCON PLMX][pkg-plmx]{:target="_blank"} | `plmx.dsk` | `PLMX MEAN`; `A:M80 =MEAN.MAC`; `A:L80 MEAN,RLIB,MEAN/N/E`; `MEAN`. `PLMX.SUB` supplies the build sequence.
|[Simple Programming Language][pkg-spl]{:target="_blank"} | `spl.dsk` in A: | `SPL FAC`; `L80 FAC,FAC/N/E`; `FAC`. `C.SUB` supplies compilation and linking; `TYPE SPL.TXT` displays the language manual.
|[MINOL / VTL-2][pkg-minolvtl]{:target="_blank"} | `cpm.dsk` in A: | `MINOL` or `VTL2`; see the small-language section for standalone memory images.
|[UCSD Pascal II.0][pkg-ucsd]{:target="_blank"} | `ucsd.dsk`, `dsk0.dsk`, `dsk1.dsk` | Special p-system disks; see the requirements section and the archive `readme.txt`.
|[UCSD source disks][pkg-ucsddsk]{:target="_blank"} | Compressed `.raw.gz` disk files | Additional source media for UCSD, not standalone CP/M applications. Decompress and use the p-system disk mapping in its documentation.
|---

Some compilers use utilities from the boot disk. Before using a supplied build script on drive `B:`, copy the required
utilities to the working application disk. For example, after booting, type:

```text
A:PIP B:=A:DO.COM
A:PIP B:=A:L80.COM
A:PIP B:=A:M80.COM
B:
DO C TEST
```

`DO` is Schorn's utility for running a `.SUB` command file; `DO C TEST` uses `C.SUB` with parameter `TEST`. For an
ordinary CP/M submission, use `A:SUBMIT C TEST` after copying any tools the script needs. Read the script first with
`TYPE C.SUB`: the examples build and overwrite output files on the working disk.

For Microsoft BASIC under CP/M, type `MBASIC`, wait for `Ok`, then enter `PRINT 2+2`. To run one of the supplied
programs, type `MBASIC ELIZA`, `MBASIC STARTREK`, `MBASIC HAMURS` or `MBASIC MSTMND` at `B>`. Other interpreter
versions on `basic.dsk` are `MBASIC45`, `MBASIC51`, `MBASIC52` and `XBASIC`.

![Microsoft BASIC running a program under CP/M in emuStudio]({{ site.baseurl }}/assets/altair8800/software-cpm-basic.png){:style="max-width:737px"}

![Turbo Pascal command menu in emuStudio VT100]({{ site.baseurl }}/assets/altair8800/software-turbo-pascal.png){:style="max-width:737px"}

The BASIC compilers also need their runtimes. `CBASIC BLACKJAK` creates an `.INT` file which is run with
`CRUN2 BLACKJAK`; the Digital Research variant uses `CBASE2` and `CRUN`. `CB80` produces relocatable output which
needs `LINK` or `LK80`. For Microsoft's BASCOM, copy `DO.COM` and `L80.COM` onto the working disk, then type
`DO BASCOM BLACKJAK`. The supplied `BASCOM.SUB` compiles, links with `BASLIB` and runs the result.

### Office applications

All the following packages use the ordinary `A:` boot disk / `B:` application disk sequence and VT100.

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

### Games

Download [Games][pkg-games]{:target="_blank"}, mount `games.dsk` in `B:`, boot `cpm2.dsk` from `A:`, then type `B:`.
Use VT100 for the screen games. Keep the complete games disk mounted because several games load accompanying data.

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

Othello is on `cpm2.dsk`: at `A>` type `OTHELLO`. ELIZA, Star Trek, Hamurabi and Mastermind are BASIC programs in
the BASIC collection and use `MBASIC name` as described above. DeRamp also has [CP/M games disks][deramp-cpm]{:target="_blank"},
including Zork and a Creative Computing disk. The latter starts with `MBASIC MENU` after selecting its drive.
Native BASIC games use `MOUNT`, `FILES` and `RUN "name"`, rather than these CP/M commands.

### Tools and CPU diagnostics

Download [Tools][pkg-tools]{:target="_blank"}, mount `tools.dsk` in `B:`, and boot CP/M 2.2. Type `B:`, then
`DDTZ27` to start the debugger, or `JOB15` to start the job utility. Their on-disk manuals are `DDTZ27.DOC` and
`JOB.DOC`; display them with `TYPE` before using the tools.

The CP/M boot disk supplies `M80`, `L80`, `DDT`, `DDTZ`, `SID`, `ZSID`, `PIP`, `STAT`, `R`, `W` and `HDIR`.
`M80` is Microsoft's assembler, `L80` its linker; both use the syntax documented by their original manuals, not
emuStudio's source editor syntax. `R` and `W` depend on the connected SIMH pseudo device and PTR/PTP.

[CPU test programs][cpu-tests]{:target="_blank"} include `TST8080.COM`, `8080PRE.COM`, `8080EXER.COM`,
`8080EXM.COM` and `CPUTEST.COM`. Copy them into a CP/M disk using the transfer steps below. Use the **8080**
computer for 8080 diagnostics, boot a suitable 8080-compatible CP/M disk such as `altcpm.dsk`, and type `TST8080`,
`8080PRE`, `8080EXM` or `CPUTEST` at the prompt. These are CP/M programs; loading them at address 0 is incorrect.
The original `8080EXER` reports CRC values which must be compared with real hardware; its `Error` text alone does
not establish a CPU defect. See the [test notes][cpu-test-notes]{:target="_blank"}. A full exerciser run can take hours.

## Moving host files into CP/M

In order to manipulate CP/M disk images, there are several options:

- the bundled `88-dcdd` command-line tool, described in [Experimental CP/M support][88-dcdd-cpm]{:target="_blank"};
- [cpmtools][cpmtools]{:target="_blank"}, with a disk definition matching the actual image;
- the guest `R.COM` and `W.COM` utilities with emuStudio's SIMH pseudo device and PTR/PTP.

### Using the bundled disk tool

Stop the emulation and unmount the working image before changing it from the host. Run the tool from the emuStudio
installation directory, where `examples/altair8800/cpm-formats.toml` is available. For example:

```sh
cd /path/to/emuStudio
bin/88-dcdd -l
bin/88-dcdd -f cpm3-simh -i /path/to/cpm2-work.dsk cpmfs ls
bin/88-dcdd -f cpm3-simh -i /path/to/cpm2-work.dsk cpmfs copy /path/to/HELLO.BAS cpm://HELLO.BAS
```

Use **`cpm3-simh` for Schorn's `cpm2.dsk` and most application disks**. Use `cpm2-simh` for `altcpm.dsk`.
An incorrect format can list a directory yet address file data incorrectly. Use `cpm1-simh` for the CP/M 1.4 system disk and consult the
format file for DeRamp and ZSDOS variants. Check `cpmfs ls` before copying. Remount the modified image, boot it,
and type `DIR` to confirm that the file is present.

To run `HELLO.BAS`, mount a disk containing `MBASIC.COM` and type `MBASIC HELLO`. A binary CP/M program such as
`TST8080.COM` is started with `TST8080`. Use short CP/M names: at most eight characters before the dot and three
in the extension.

### Using R and W inside CP/M

For Schorn's `cpm2.dsk` or `cpm3.dsk`, keep SIMH pseudo connected to CPU, memory and PTR/PTP. The host filename is
resolved against the directory from which emuStudio was started. For example, start emuStudio from a working directory
containing `HELLO.BAS`, boot CP/M, select a writable guest drive, and type:

```text
A:R HELLO.BAS
DIR HELLO.BAS
MBASIC HELLO
```

`R` opens the named host file through the pseudo device and copies it into the current CP/M drive. It does not require
a separate manual reader load. To export a guest file, type `A:W HELLO.BAS`; choose a working directory where that
host filename can be written. `HDIR` lists host files in packages which supply the matching utility. Consult the
[SIMH pseudo-device page][simh-device] for supported commands.

## Other original software

The [DeRamp archive][deramp]{:target="_blank"} preserves source, programs and disk images in addition to Schorn's
packages. Use the correct environment for each family:

|---
| Collection | How to start
|-|-
| [8-inch CP/M disks][deramp-cpm]{:target="_blank"} | Mount a bootable Lifeboat image in drive 0 and boot its matching loader at `0xFF00`. Burcon disk access returns `Bdos Err On A: Bad Sector` in emuStudio. Application-only images require a BIOS which supports their disk layout.
| [Paper tape and cassette][deramp-tapes]{:target="_blank"} | Includes BASIC 1.0, 3.2 and 4.x, loaders and Programming System II. Use the matching bootstrap and terminal switch selection, or the disk/memory alternatives on this page. Tape records contain addresses and checksums, not just code bytes.
| [ROMs and monitors][clone-roms]{:target="_blank"} | Load Intel HEX with offset 0, or a binary at its documented origin. Open the serial terminal and jump to the monitor's entry point.
| [Front-panel programs][front-panel]{:target="_blank"} | Load HEX with offset 0 and jump to the source's entry point. `ECHO.HEX` uses the serial console. Kill-the-Bit and Pong need front-panel switches/lights; the debugger is not a substitute for their original controls.
| [Disk and transfer utilities][deramp-utils]{:target="_blank"} | Use the controller named in the source and the specified load address. Physical floppy/serial-transfer utilities are not needed merely to mount an image in emuStudio.
| [Manuals][manuals]{:target="_blank"} | BASIC, DOS, CP/M, assembler/linker, accounting and peripheral documentation; these are documentation files, not guest programs.
|---

### MITS Programming System II

The [Programming System II floppy package][ps2-disk]{:target="_blank"} provides a convenient disk-based alternative
to loading its monitor, editor, assembler and debugger from tape. To start it, please follow these steps:

1. Download `PS2DEMO.DSK` and `PS2PROM.HEX` from that directory.
2. Use one memory bank and the 88-DCDD controller. Enable the 2SIO console ports `0x10`/`0x11`.
3. Mount a working copy of `PS2DEMO.DSK` in drive 0. Load `PS2PROM.HEX` in byte-memory with offset `0`.
4. Open the terminal, jump to `0xF000`, and run.
5. At the workspace prompt, choose `4` for the editor and AM2 assembler, or `3` for the debugger and AM2. Workspace
   `2` contains 8K BASIC with the Chase program. The package's [instructions][ps2-readme]{:target="_blank"} describe
   the preset memory layout.
6. In an editor workspace, type `EDT` to start a new edit, `I` to insert source, Ctrl-Z to finish insertion, and `E`
   to return to the monitor. Use `EDT(R)` to retain existing source when editing again.
7. Start the assembler with `AM2`. Its `EOA` command returns to the monitor. Follow the supplied manual for assembly,
   saving and execution; the monitor uses octal addresses.

The tape package's `PS2-EDT.BIN`, `PS2-ASM.BIN`, `PS2-AM2.BIN` and `PS2-DBG.BIN` are monitor-load records, not ordinary
raw memory binaries. Do not load them at address zero just because their extension is `.BIN`.

### Small languages and monitors

[MINOL and VTL-2][pkg-minolvtl]{:target="_blank"} include a bootable `cpm.dsk`. Use Z80, one bank, `mdbl.bin` at
`0xFF00`, and mount that disk in `A:`. At `A>` type `MINOL` or `VTL2`. On-disk `MINOL22.TXT`, `MITSVTL2.TXT` and
`VTL2SIMH.TXT` describe the syntax. This avoids the physical-console switch selection needed by the standalone
`minol22.bin` and `mitsvtl2.bin` versions.

For standalone VTL-2 from that same archive, load `mitsvtl2.bin` at `0xF800`, change `DB FF` at `0xF820` to `3E 08`,
and start at `0xF800` with the 2SIO console. For standalone MINOL, load `minol22.bin` at 0, change `DB FF` at `0x0252`
to `3E 00`, enable 2SIO status `0x10` and data `0x11`, and start at 0. This last switch read controls its prompt.
Use the 8080 computer for both standalone versions. The CP/M versions are the simpler installation.

The ROM directory also contains TURMON (`0xFD00`), hexadecimal TURMONH (`0xFD00`) and the Altair monitor (`0xF800`).
Load their HEX files with offset 0, enable the `0x10`/`0x11` console, open the terminal and jump to the stated entry
point. TURMON takes octal addresses; TURMONH takes hexadecimal addresses. Other monitors, including CUTER and the
improved loader/monitor ROMs, have their own I/O and origin settings in the supplied sources and manuals.

## Software requiring other hardware

Some packages require devices or services unavailable in the standard emuStudio Altair schema.
Changing a disk filename or its geometry cannot replace a missing controller or simulator service.

|---
| Download or family | Requirement and execution route
|-|-
| [Burcon CP/M][pkg-burcon]{:target="_blank"} | `DIR` returns `Bdos Err On A: Bad Sector` in emuStudio. Its BIOS requires additional sector validation.
| [MP/M II][pkg-mpm]{:target="_blank"} | Its script sets banked memory with common boundary `0xB000`, attaches `mpm.dsk` and SIMH `i.dsk`, and opens four telnet terminals. emuStudio has timer/banking support but does not provide that SIMH multi-terminal SIO installation. The supplied multi-user configuration cannot run with the standard emuStudio schema.
| [CP/NET and CPNOS][pkg-cpnet]{:target="_blank"} | Require SIMH's NET socket device as well as client/server operating systems. A normal emuStudio SIO connection does not implement the network device.
| [CompuPro CP/M Plus][pkg-cpmplus]{:target="_blank"} | Uses I8272, DISK1A/DISK2 and SystemSupport1 serial devices with IMD disks. This is separate from Schorn's runnable Altair `cpm3.dsk`. emuStudio does not supply these controllers.
| [UCSD Pascal II.0][pkg-ucsd]{:target="_blank"} and [additional source disks][pkg-ucsddsk]{:target="_blank"} | Its `ucsd` script boots `ucsd.dsk` in floppy drive 4, attaches `dsk0.dsk` and `dsk1.dsk` to SIMH hard-disk drives, and loads the p-system with `PASCAL`. It needs the package's special disk layout; raw `.gz` source disks are not ordinary CP/M floppies. The standard CP/M setup on this page does not supply that installation.
| Schorn's `appleiicpm.dsk`, `128sssd.imd` and `JRTPAS30.IMD` | Need the specified Apple II or ImageDisk sector format and mapping. Do not mount an IMD file as a raw 137-byte-sector disk.
| [Other Schorn operating systems][schorn-os2]{:target="_blank"} | CompuPro, Cromemco, North Star, Vector Graphic, CP/M-86, 86-DOS, MS-DOS, CP/M-68K and related systems need their stated processors/controllers. They cannot run with the standard emuStudio Altair 8080/Z80 schema.
| DeRamp North Star and iCOM disk trees | North Star, Tarbell and iCOM controller-specific images need those controllers. A raw `.dsk` or `.nsi` suffix does not make them 88-DCDD disks. Preserve their readmes and use the documented hardware or a simulator which supplies it.
| MITS BASIC 1.0 and other unconverted tape-only releases | The archived `.tap` files need their matching bootstrap and console selection. They require a console switch register that the standard emuStudio schema does not supply.
| Physical front-panel, cassette, printer, music and speech programs | Require the named switches, cassette interface, printer, DAC or speech hardware. The terminal cannot supply these peripherals. Serial text programs can use the console when their ports match.
|---

## When a program does not start

If there is no output, first check the bootloader and entry address, the mounted drive 0 image, and the serial ports.
A CP/M disk expects a matching CP/M BIOS; a MITS BASIC disk expects Disk BASIC. For Schorn's current CP/M disks use
`mdbl.bin`, not the original `dbl.bin`. Check memory banks and the common boundary for banked systems.

If text is readable but the screen is filled with escape characters, use the terminal type for which the program was
installed, usually VT100 for Schorn's screen applications. If CP/M prints `NAME?`, use `DIR` to confirm that `NAME.COM`
is on the selected drive and in the selected user area. If an application starts but cannot load a file, keep its
overlays/data on that drive, check the disk format, and wait for disk operations before entering another command.

For BASIC memory-size errors, distinguish bytes from kilobytes and use the explicit answers above. For standalone
BASIC with no console output, confirm that the listed console patch was applied after loading and was not lost on
reset. Hardware-specific archives require their own installation rather than further changes to a working CP/M setup.

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
