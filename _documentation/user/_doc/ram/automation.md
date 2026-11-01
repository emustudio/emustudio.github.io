---
layout: default
title: Automation
nav_order: 1
parent: RAM
permalink: /ram/automation
---

{% include analytics.html category="RAM" %}

# Automation

In headless automatic emulation (`auto --no-gui`), each abstract tape logs symbol writes to a file. The format is described in
[abstract tape documentation]({{site.baseurl}}/ram/abstract-tape).

## Example

Run the bundled factorial example from the emuStudio installation directory:

    ./emuStudio -cf config/RandomAccessMachineRAM.toml --input-file examples/ramc-ram/factorial.ram auto --no-gui

- computer `config/RandomAccessMachineRAM.toml` will be loaded
- input file for compiler is one of the standard examples
- (`auto`) automatic emulation will be executed
- (`--no-gui`) non-interactive mode will be set

The console reports progress similar to the following (plugin details and paths depend on the installation):

{:.code-example}

```
[INFO] Starting emulation automation...
[INFO] Emulating computer: Random Access Machine (RAM)
[INFO] Compiling input file: examples/ramc-ram/factorial.ram
[INFO] Compiler started working.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Starting logging symbols changes to a file: storage.out
[INFO] Starting logging symbols changes to a file: input_tape.out
[INFO] Starting logging symbols changes to a file: output_tape.out
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Emulation completed
```

The run creates three files in the current working directory:

- `input_tape.out`: records input symbols loaded during reset
- `storage.out`: contains log of register tape changes during emulation
- `output_tape.out`: records output symbols written by the program

The bundled example supplies input `8`. Its `output_tape.out` contains `8! = 40320` at position 0:

```
0 40320
```

Each file is a text log. Every row has the format:

    position symbol

`position` is the zero-based symbol position on the tape, and `symbol` is the value written there. A position can occur
more than once in the log, especially in `storage.out`. RAM tapes are left-bounded, so positions start at 0.
