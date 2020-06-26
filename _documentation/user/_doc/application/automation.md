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
It is useful for example in school enabling automatic processing of assignments, or when working on custom projects
and we are curious just about the emulator or the emulation output. 

Automatic emulation can be interactive, or non-interactive. In the case of interactive emulation, during the process all
device GUIs are shown automatically, allowing the user to interact with the emulated computer. The user however has no
access to the source code, debugger, or memory content.

Non-interactive mode of the automatic emulation is even more "quiet" - it does not show any GUIs. The output of the emulation
is usually redirected to one or more files. The specific behavior is plugin-based.

Automatic emulation requires source code to be present. The source code is called the "input". It will be compiled
before the emulation is executed.

More specific information about automation can be found in any section devoted to an emulated computer.

## Example

The example of running automatic emulation is as follows:

    ./emuStudio --auto --nogui --config config/MITSAltair8800.toml --input example.asm --waitmax 5000

Argument `--auto` turns on the automatic emulation. If no other argument is provided, emuStudio will start as usual by asking to open a virtual computer. But after this step it will run the emulation with the settings as they appear in the computer configuration file (no source code compilation is performed).

The `--nogui` argument sets the non-interactive mode. In this case, we must provide a virtual computer in the command line (using `--config` argument).

The `--config` argument loads specific computer configuration automatically, instead of asking the user to open a computer.

Argument `--input` provides the source code to be compiled and loaded into memory before the emulation is executed.

Argument `--waitmax 5000` tells emuStudio that the emulation should not last for more than 5 seconds. If it didn't finish up to this deadline, it is forcibly stopped and marked as failed.

## Analyzing the results

An important part of the analysis of the result of the automatic emulation is the log saying what happened. By default, each run of automatic emulation creates (overwrites) a log located in `logs/automation.log` file.

The log file is in plaintext format and contains messages which appeared in the log during the emulation.
The log file format can be customized, see [Logging]({{ site.baseurl }}/application/logging) section for more details. 
