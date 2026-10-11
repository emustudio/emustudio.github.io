---
layout: default
title: Automation
nav_order: 1
parent: emuStudio Application
permalink: /application/automation
---

{% include analytics.html category="Application" %}

# Automation

Automation loads a computer, optionally compiles a source file, and runs the CPU without using the main window.
It is useful for batch runs, assignments, and programs whose device output is the main result.

In interactive mode, device GUIs are shown automatically when supported. You can interact with them, but the source
editor and debugger are unavailable.

Non-interactive mode (`--no-gui`) opens no GUI windows. Device output and access to host resources depend on each plugin.

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

The `--no-gui` argument sets the non-interactive mode. In this case, emuStudio won't show any GUI windows and
each device determines its headless behavior. Terminals can use files; other devices may run silently or require host
resources (see the involved plugins' documentation).

Argument `--waitmax 5000` waits at most 5 seconds for the running CPU to stop. When the deadline expires, the CPU is
stopped when the virtual computer is closed. A CPU still running at the deadline is logged as `Invalid state
(STATE_RUNNING)`. This limit does not include compilation or device initialization. Omit it to wait without a deadline.

Use `-p ADDRESS` (or `--program-location ADDRESS`) after `auto` to override the starting instruction address. Addresses
can use decimal or a radix prefix such as `0x8000`. Without an override, the CPU uses its reset/compiled-program location.
Check `logs/automation.log` and the device output to determine whether the run completed normally; automation failures
are not all reflected in the process exit status.
