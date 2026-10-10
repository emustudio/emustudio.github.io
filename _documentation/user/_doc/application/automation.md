---
layout: default
title: Automation
nav_order: 1
parent: emuStudio Application
permalink: /application/automation
---

{% include analytics.html category="Application" %}

# Automation

Automation, or automatic emulation, is a feature in which the user can run the emulation without manual steps.
It is useful for example in school enabling automatic processing of assignments, or when working on custom projects,
and we are curious just about the emulator or the emulation output.

Automatic emulation can be interactive, or non-interactive. In the case of interactive emulation, during the process all
device GUIs are shown automatically, allowing the user to interact with the emulated computer. The user however has no
access to the source code, debugger, or memory content.

Non-interactive mode of the automatic emulation is even more "quiet" - it does not show any GUIs. The output of the
emulation is usually redirected to one or more files. The specific behavior is plugin-based.

Source code supplied with `--input-file` is compiled and loaded before the CPU runs. This option is optional: omit it
to run code already loaded by the computer configuration, such as a ROM image.

More specific information about automation can be found in any section devoted to an emulated computer.

## Example

The example of running automatic emulation is as follows:

    ./emuStudio -cf config/MITSAltair8800.toml --input-file examples/as-8080/reverse.asm auto --no-gui --waitmax 5000

The `-cf` (or `--computer-file`) argument loads specific computer configuration instead of asking the user to open a
computer.

Argument `--input-file` provides the source code to be compiled and loaded into memory before the emulation is executed.
It compiles the file only in case automated emulation is executed (see below).

Command `auto` executes automatic emulation. Select a computer with `-cf`, `-cn`, or `-ci`. If an input file is provided,
it is compiled into memory. Interactive automation opens the device GUIs and starts the CPU.

The `--no-gui` argument sets the non-interactive mode. In this case, emuStudio won't show any GUI windows and the
communication with I/O is done via files (see involved plugins documentation).

Argument `--waitmax 5000` waits at most 5 seconds for the running CPU to stop. When the deadline expires, the CPU is
stopped and the timeout is logged. This limit does not include compilation or device initialization. Omit it to wait
without a deadline.

Use `-p ADDRESS` (or `--program-location ADDRESS`) after `auto` to override the starting instruction address. Addresses
can use decimal or a radix prefix such as `0x8000`. Without an override, the CPU uses its reset/compiled-program location.
Check `logs/automation.log` and the device output to determine whether the run completed normally; automation failures
are not all reflected in the process exit status.

## ZX Spectrum example

The ZX Spectrum 48K can also be run in automation mode. For interactive emulation with display and audio:

    ./emuStudio -cf config/ZxSpectrum48K.toml --input-file examples/zx-spectrum/twinkle_beeper.asm auto

For more details, see the [ZX Spectrum 48K automation]({{ site.baseurl }}/zxspectrum48k/automation) documentation.

