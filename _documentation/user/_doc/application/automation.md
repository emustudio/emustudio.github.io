---
layout: default
title: Automation
nav_order: 6
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

Automatic emulation requires source code to be present. The source code is called the "input". It will be compiled
before the emulation is executed.

More specific information about automation can be found in any section devoted to an emulated computer.

## Example

The example of running automatic emulation is as follows:

    ./emuStudio -cf config/MITSAltair8800.toml --input-file examples/as-8080/reverse.asm auto --no-gui --waitmax 5000

The `-cf` (or `--computer-file`) argument loads specific computer configuration instead of asking the user to open a
computer.

Argument `--input-file` provides the source code to be compiled and loaded into memory before the emulation is executed.
It compiles the file only in case automated emulation is executed (see below).

Command `auto` executes automatic emulation. If no other argument is provided, emuStudio will start as usual by
asking to open a virtual computer. If computer is provided, it is opened. If input-file is provided, it is loaded and
compiled into memory. Then, if the automatic emulation is interactive, will open all device GUIs and executes CPU.

The `--no-gui` argument sets the non-interactive mode. In this case, emuStudio won't show any GUI windows and the
communication with I/O is done via files (see involved plugins documentation).

Argument `--waitmax 5000` tells emuStudio that the emulation should not last for more than 5 seconds. If it didn't
finish up to this deadline, it is forcibly stopped and marked as failed.
