---
layout: default
title: Automation
nav_order: 1
parent: emuStudio Application
permalink: /application/automation
---

{% include analytics.html category="Application" %}

# Automation

Automation runs an emulated computer without the main window. emuStudio loads a computer, optionally compiles a source
file, and runs the CPU until it stops. Use it for batch runs, checking school assignments, and programs whose device
output is the main result.

This page explains the two automation modes, where input comes from, and how to start, limit, and evaluate a run.
The documentation of each emulated computer describes its automation specifics.

## Modes

Automation runs in one of two modes: interactive and non-interactive. They differ in whether device windows appear.

In **interactive mode**, emuStudio shows device GUIs automatically when the devices support them. You can interact with
them, but the source editor and debugger are unavailable.

In **non-interactive mode** (`--no-gui` option), emuStudio opens no GUI windows. Devices read input from files and write
output to files instead, as described in [Device input](#device-input) and [Device output](#device-output). Other
devices run silently or may still require host resources, such as audio output. See the documentation of the involved
plugins.

Non-interactive runs ignore breakpoints and log this in `logs/automation.log` when the CPU starts. Saved breakpoints
remain available for interactive runs.

## Input

A run takes input from two sources: the program the CPU executes and the files that devices read. The command line
supplies only the program; devices read files named in their settings.

### Program source

The CPU runs either a source file you supply or code already loaded by the computer configuration.

With `--input-file` option, emuStudio compiles the source file and loads it into memory before the CPU runs. The file is
compiled only when automation runs.

Without `--input-file` option, the CPU runs code loaded by the computer configuration, such as a ROM image.

### Device input

Where device input comes from depends on the mode. In interactive mode, you type into device windows and attach files
there. In non-interactive mode, devices read input only from files named in their settings, so prepare these files
before the run.

Relative file names resolve against the current working directory, as for [device output](#device-output).

The bundled devices read the following files:

|---
| Device | Input | Source | Mode
|-|-|-|-
| [ADM-3A terminal]({{ site.baseurl }}/altair8800/adm3a-terminal) | Keyboard input | `adm3A-terminal.in`, configurable with `inputFileName` | Non-interactive
| [VT100 terminal]({{ site.baseurl }}/altair8800/vt100-terminal) | Keyboard input | `vt100-terminal.in`, configurable with `inputFileName` | Non-interactive
| [Byte memory]({{ site.baseurl }}/altair8800/byte-mem) | Memory images | `imageName`(i) settings | Both
| [88-DCDD]({{ site.baseurl }}/altair8800/88-dcdd) | Floppy disk images | `image0` … `image15` with `imageMounted0` … `imageMounted15` | Both
| [88-HDSK]({{ site.baseurl }}/altair8800/88-hdsk) | Hard disk images | `image0` … `image15` | Both
| Abstract tape ([RAM]({{ site.baseurl }}/ram/ramc-ram), [RASP]({{ site.baseurl }}/rasp/raspc-rasp)) | Input tape content | `<input>` lines in the source file | Both
|---

Some devices accept input only through their windows, so they receive none in non-interactive mode. The
[88-PTR/PTP]({{ site.baseurl }}/altair8800/88-ptr-ptp) reader can still attach a tape when guest software issues
[SIMH pseudo-device commands]({{ site.baseurl }}/altair8800/simh-pseudo). The ZX Spectrum
[Audio Tape Player]({{ site.baseurl }}/zxspectrum48k/audiotape-player) does not start stored tape events.

## Running automation

A single command selects the computer, the program, and the mode. The following example runs a program on the MITS
Altair8800 in non-interactive mode and waits at most 5 seconds:

    ./emuStudio -cf config/MITSAltair8800.toml --input-file examples/as-8080/reverse.asm auto --no-gui --waitmax 5000

The arguments work as follows:

- `-cf` (or `--computer-file`) loads the computer configuration instead of asking the user to open a computer.
- `--input-file` supplies the source file to compile and load.
- `auto` starts automation. It requires a computer selected with `-cf`, `-cn`, or `-ci`.
- `--no-gui` selects non-interactive mode. Without it, automation opens the device GUIs and starts the CPU.
- `--waitmax 5000` limits how long the session waits for the CPU, as described below.

## Controlling the run

Options placed after `auto` control where the CPU starts and how long the session waits. You can also cancel a session
at any time.

`-p ADDRESS` (or `--program-location ADDRESS`) overrides the starting instruction address. Addresses can use decimal or
a radix prefix such as `0x8000`. Without it, the CPU uses its reset or compiled-program location.

`--waitmax MILLISECONDS` sets a deadline for CPU execution. When the deadline expires, emuStudio asks the CPU to stop and
the session reports `TIMED_OUT`. Without it, the session waits with no deadline.

To cancel a session, click **Stop** in the progress dialog in interactive mode, or press **Ctrl+C** in non-interactive
mode.

## Results

A run leaves its results in three places: device output, the exit status, and the automation log. When the CPU stops,
the session waits for participating devices to stop and then collects their output.

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

The exit status tells whether the run succeeded; the log explains why it ended.

A failed run returns a nonzero exit status. `logs/automation.log`, relative to the current working directory, records
the final run reason and any output or cleanup failures.
