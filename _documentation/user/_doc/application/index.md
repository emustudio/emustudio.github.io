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

emuStudio is a desktop application which allows emulation of various computers. Besides emulation, it contains source
code editor, which can be used to write and then compile programs then to be instantly emulated. Virtual computers, as
the emulators are called, are represented by plugins of various type (compiler, memory, CPU and device), combined in a
computer configuration. The computer configuration can be opened during startup.

The application has also command-line interface, which allows executing automatic "load-compile-emulate" workflow,
possibly without graphical interface. This workflow is called "automatic emulation" and has its specifics, discussed per
virtual computer.

A logger is used by emuStudio which helps debugging of the application and plugins.

## Installation and run

At first, please download emuStudio distribution. It is either a TAR or ZIP file in the form `emuStudio-[VERSION].zip`.
For Linux, a TAR variant will be more suitable since it preserves file attributes and execution
permissions. Unpack the file where you want to have emuStudio installed.

Before running, [Java 11][java11]{:target="_blank"} or later must be installed. Then, emuStudio can be run by executing
the following script:

- On Linux
```
> ./emuStudio
```

- On Windows:
```
> emuStudio.bat
```

NOTE: Currently supported are Linux and Windows. Mac is NOT supported, but it might work to some extent.

## Command-line arguments

emuStudio accepts several command line arguments. Their description is accessible with `--help` argument:

    $ ./emuStudio --help
    Usage: emuStudio [-hV] [-cl] [--config-dir=DIR] [-i=FILE] [--plugins-dir=DIR]
                     [-cn=NAME | -cf=FILE | -ci=INDEX] [COMMAND]
    Universal emulation platform and framework
          -cl, --computers-list
                              list all existing virtual computers
          --config-dir=DIR    configuration base directory
          --plugins-dir=DIR   plugin base directory
      -h, --help              Show this help message and exit.
      -i, --input-file=FILE   input file name (source code)
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
      -w, --waitmax=MILLIS   wait at most MILLIS for the CPU to stop
                               (stop the CPU afterwards)



[java11]: https://jdk.java.net/archive/
