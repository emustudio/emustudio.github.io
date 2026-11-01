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

emuStudio is a desktop application for emulating computers. Its source code editor lets you write and compile programs
for the selected computer. A virtual computer combines compiler, CPU, memory, and device plugins in a configuration
that you select at startup.

The command-line interface can load, compile, and run programs, with or without device windows. This workflow is called
**automatic emulation**; each computer guide describes its device behavior.

Logs help diagnose application and plugin problems; see [Logging]({{ site.baseurl }}/application/logging).

## Installation and run

Download and unpack the complete `emuStudio-[VERSION].tar` or `emuStudio-[VERSION].zip` distribution. On Linux,
prefer TAR because it preserves execution permissions. Run the launcher from the unpacked directory.

Before running, [Java 11][java11]{:target="_blank"} or later must be installed. Then, emuStudio can be run by executing
the following script:

- On Linux:

```
> ./emuStudio
```

- On Windows:

```
> emuStudio.bat
```

The distributed launchers support Linux and Windows. macOS operation has not been verified for this development version.
Individual plugins can require additional host resources, such as audio or network access.

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
    Usage: emuStudio automation [-hV] [--[no-]gui] [--debug-script=<debugScript>]
                                [-p=LOCATION] [-w=MILLIS]
    run emulation automation
          --debug-script=<debugScript>
                             run bounded STEP/RUN/ASSERT/CAPTURE operations after
                               compile/reset
          --[no-]gui         show/don't show GUI during automation
      -h, --help             Show this help message and exit.
      -p, --program-location=LOCATION
                             program start location
      -V, --version          Print version information and exit.
      -w, --waitmax=MILLIS   wait at most MILLIS for the running CPU to stop

The wait limit applies to CPU execution and closes the virtual computer when it expires. Compilation and device
initialization are outside this limit. See [automation]({{ site.baseurl }}/application/automation) for timeout behavior,
program start addresses, and interpreting the logs.

[java11]: https://jdk.java.net/archive/
