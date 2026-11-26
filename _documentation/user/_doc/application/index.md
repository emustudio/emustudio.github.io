---
layout: default
title: emuStudio Application
description: "emuStudio application guide — how to use the emulation platform, source code editor, debugger, and virtual computer designer."
nav_order: 2
has_children: true
permalink: /application/
---

{% include analytics.html category="Application" %}

# emuStudio Application

Install emuStudio, open a virtual computer, and use its source editor and emulator. Each computer supplies its own compiler, CPU, memory, and peripheral devices.

Use [Automation]({{ '/application/automation' | relative_url }}) to load, compile, and run from the command line.
See [Logging]({{ '/application/logging' | relative_url }}) for startup and plugin diagnostics.

## Install and launch emuStudio

1. Download and unpack the complete distribution. Prefer TAR on Linux to preserve execution permissions.
2. Install Java.
3. Run the launcher from the unpacked directory. Run `./emuStudio` on Linux or `emuStudio.bat` on Windows.
4. Select a computer when the chooser opens. The [first experiment]({{ '/first-experiment/' | relative_url }}) walks
   through compiling and running a program.

## Command-line arguments

emuStudio accepts several command line arguments. Their description is accessible with `--help` argument:

    $ ./emuStudio --help
    Usage: emuStudio [-hV] [-cl] [--config-dir=DIR] [-i=FILE] [--plugins-dir=DIR]
                     [-cn=NAME | -cf=FILE | -ci=INDEX] [COMMAND]
    Universal emulation platform and framework
          -cl, --computers-list
                              list all existing virtual computers
          --config-dir=DIR    configuration base directory
      -h, --help              Show this help message and exit.
      -i, --input-file=FILE   input file name (source code)
          --plugins-dir=DIR   plugin base directory
      -V, --version           Print version information and exit.
    Virtual computer
          -cf, --computer-file=FILE
                              virtual computer configuration file
          -ci, --computer-index=INDEX
                              virtual computer index (see -cl for options)
          -cn, --computer-name=NAME
                              virtual computer name (see -cl for options)
    Commands:
      automation, auto  run emulation automation

`--config-dir DIR` and `--plugins-dir DIR` select the configuration and plugin roots. See
[configuration and plugin roots]({{ site.baseurl }}/application/configuration-file#configuration-and-plugin-roots)
for environment variables and path resolution.

Automation command has its own usage:

    $ ./emuStudio auto --help
    Usage: emuStudio automation [-hV] [--[no-]gui] [-p=LOCATION] [-w=MILLIS]
    run emulation automation
          --[no-]gui         show/don't show GUI during automation
      -h, --help             Show this help message and exit.
      -p, --program-location=LOCATION
                             program start location
      -V, --version          Print version information and exit.
      -w, --waitmax=MILLIS   wait at most MILLIS for the running CPU to stop

The wait limit applies to CPU execution. When it expires, emuStudio stops the CPU, waits for plugin cleanup, and closes
the computer. See [automation]({{ site.baseurl }}/application/automation) for timeout behavior,
program start addresses, and interpreting the logs.
