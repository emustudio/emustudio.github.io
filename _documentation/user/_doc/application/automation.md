---
layout: default
title: Automation
nav_order: 1
parent: emuStudio Application
permalink: /application/automation
---

{% include analytics.html category="Application" %}

# Automation

Use automation to run an emulated computer from the command line, without opening the main window. emuStudio loads a
computer, optionally compiles a source file, and runs the CPU until it stops. Choose interactive mode to use device
windows, or non-interactive mode to run without GUI windows; supported devices read input from files and write output
to files. Automation suits batch runs, reproducible tests, and checking programs such as school assignments.

This page explains the two automation modes, where input comes from, and how to start, limit, and evaluate a run.
Each emulated computer's documentation describes its automation-specific behavior.

## Modes

Automation runs in one of two modes: interactive and non-interactive. They differ in whether device windows appear.

In **interactive mode** (default), emuStudio shows device GUIs automatically when the devices support them. You can interact with
them, but the source editor and debugger are unavailable.

In **non-interactive mode** (`--no-gui` option), emuStudio opens no GUI windows. Supported devices use the inputs and
outputs described in [Device input](#device-input) and [Device output](#device-output). Some devices still require
host resources, such as audio output.

{: .note}
Non-interactive runs ignore breakpoints and log this in `logs/automation.log` when the CPU starts. Saved breakpoints
remain available for interactive runs.

## Input

A run combines the program the CPU executes with any input its devices supply. Device input can come from configured
files, values defined in the program source, or data the guest requests from the host during the run.

### Program source

The CPU runs either a source file you supply or code already loaded by the computer configuration.

With `--input-file` option, emuStudio compiles the source file and loads it into memory before the CPU runs. The file is
compiled only when automation runs.

Without `--input-file` option, the CPU runs code loaded by the computer configuration, such as a ROM image.

### Device input

Prepare any configured input files before the run. In interactive mode, you can also use device windows to type into
a terminal or attach media.

Relative file paths in device settings resolve against the directory where you start emuStudio. The same rule applies
to [device output](#device-output).

The bundled devices support these inputs.

|---
| Device | Input | Source | Mode
|-|-|-|-
| [ADM-3A terminal]({{ site.baseurl }}/altair8800/adm3a-terminal) | Keyboard input | `adm3A-terminal.in`, configurable with `inputFileName` | Non-interactive
| [VT100 terminal]({{ site.baseurl }}/altair8800/vt100-terminal) | Keyboard input | `vt100-terminal.in`, configurable with `inputFileName` | Non-interactive
| [Byte memory]({{ site.baseurl }}/altair8800/byte-mem) | Memory images | `imageNameN` and `imageAddressN`. Optional `imageBankN` defaults to `0`. | Both
| [88-DCDD]({{ site.baseurl }}/altair8800/88-dcdd) | Floppy disk images | `image0` … `image15` with `imageMounted0` … `imageMounted15` | Both
| [88-MDS]({{ site.baseurl }}/altair8800/88-mds) | Raw minidisk images | `image0` … `image15`, attached at startup | Both
| [88-HDSK]({{ site.baseurl }}/altair8800/88-hdsk) | Hard disk images | `image0` … `image7` in MITS mode, `image0` … `image15` in SIMH mode | Both
| [ZX Spectrum Audio Tape Player]({{ site.baseurl }}/zxspectrum48k/audiotape-player) | Tape images | `automationEvents` in the `audiotape-player` device settings | Both
| Abstract tape ([RAM]({{ site.baseurl }}/ram/ramc-ram), [RASP]({{ site.baseurl }}/rasp/raspc-rasp)) | Input tape content | `<input>` lines in the source file | Both
|---

#### Host data requested by the guest

With `simh-pseudo` connected to the virtual computer, guest software can request host data at runtime in either
automation mode.

- **Paper tape.** Command 4 attaches the host file named in the CP/M command line to the guest's paper tape reader.
  The guest then reads bytes through the [88-PTR/PTP reader]({{ site.baseurl }}/altair8800/88-ptr-ptp).
- **File names.** Command 29 lists names that match a host wildcard pattern supplied by the guest. Relative patterns
  resolve from emuStudio's working directory.
- **URL text.** Command 30 fetches text from a URL supplied by the guest and returns up to 1,024 characters as bytes.
- **Clock.** Commands 7 and 9 read the host's UTC clock with the guest's ZSDOS or CP/M 3 clock offset, respectively.

See [SIMH pseudo-device commands]({{ site.baseurl }}/altair8800/simh-pseudo) for connections and command formats.

## Running automation

A single command selects the computer, the program, and the mode. The following example runs a program on the MITS
Altair8800 in non-interactive mode with a 5-second CPU execution limit:

    ./emuStudio -cf config/MITSAltair8800.toml --input-file examples/as-8080/reverse.asm auto --no-gui --waitmax 5000

The arguments work as follows:

- `-cf` (or `--computer-file`) loads the computer configuration instead of asking the user to open a computer.
- `--input-file` supplies the source file to compile and load.
- `auto` starts automation. Select a computer with `-cf`, `-cn`, or `-ci`. In interactive mode, you can omit these options and use the chooser.
- `--no-gui` selects non-interactive mode. Without it, automation opens the device GUIs and starts the CPU.
- `--waitmax 5000` limits how long the session waits for the CPU, as described below.

## Controlling the run

Options placed after `auto` control where the CPU starts and how long it runs.

`-p ADDRESS` (or `--program-location ADDRESS`) overrides the starting instruction address. Addresses can use decimal or
a radix prefix such as `0x8000`. Without it, the CPU uses its reset or compiled-program location.

`--waitmax MILLISECONDS` limits the wait for the CPU to stop after it starts. Compilation, plugin startup, and cleanup
take place outside this limit. When the limit expires, emuStudio stops the CPU and reports `TIMED_OUT`. Omit the option
to wait indefinitely.

In interactive mode, click **Stop** once the progress dialog reaches **Running emulation…**. The button is disabled
during compilation and reset. In non-interactive mode, press **Ctrl+C**.

## Results

A run leaves device output, an exit status, and an automation log. After execution, emuStudio waits for the CPU and
plugins to finish their shutdown work before closing the computer.

### Device output

Where device output goes depends on the mode. In interactive mode, devices show output in their windows. In
non-interactive mode, devices write output to files.

Relative file names resolve against the current working directory: the directory from which you start emuStudio, not
the installation directory. Each run overwrites existing output files.

For example, these bundled devices write the following files in non-interactive mode:

|---
| Device | Output | Default file
|-|-|-
| [ADM-3A terminal]({{ site.baseurl }}/altair8800/adm3a-terminal) | Terminal output | `adm3A-terminal.out`, configurable with `outputFileName`
| [VT100 terminal]({{ site.baseurl }}/altair8800/vt100-terminal) | Terminal output | `vt100-terminal.out`, configurable with `outputFileName`
| [Abstract tape]({{ site.baseurl }}/ram/abstract-tape) | Log of symbol writes, one file per tape | Derived from the tape title, with the `.out` extension
| [SSEM CPU]({{ site.baseurl }}/ssem/automation) | Final memory dump and register values | `ssem.out`
|---

Devices not listed here write no automation output. For files that devices read, see [Device input](#device-input).

### Exit status and log

Exit status `0` covers `NORMAL_STOP`, an interactive `BREAKPOINT`, and `TIMED_OUT` when cleanup succeeds.
Execution or cleanup failures return a nonzero status. Scripts that require a normal stop should also check the
`Run result:` entry in `logs/automation.log`, relative to the current working directory. The log records cleanup
failures as well.
