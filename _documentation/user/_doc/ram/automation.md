---
layout: default
title: Automation
nav_order: 1
parent: RAM
permalink: /ram/automation
---

{% include analytics.html category="RAM" %}

# Automation

RAM computer will recognize if automatic emulation is executed. In the case of non-interactive mode (`--no-gui`),
each abstract tape is redirected to a file. The format of the files is described in
[abstract tape documentation]({{site.baseurl}}/ram/abstract-tape).

## Example

Command line for starting non-interactive automatic emulation:

    ./emuStudio -cf config/RandomAccessMachineRAM.toml --input-file examples/ramc-ram/factorial.ram auto --no-gui

- computer `config/RandomAccessMachineRAM.toml` will be loaded
- input file for compiler is one of the standard examples
- (`auto`) automatic emulation will be executed
- (`--no-gui`) non-interactive mode will be set

{: .info}
> If startup reports `Plugin class count does not match plugin configuration count`, the application's plugin loader
> failed to create multiple tape instances. Compilation and emulation have not started. The
> [standalone compiler]({{ site.baseurl }}/ram/ramc-ram#running-from-the-command-line) can still compile your program.

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

Then, in the current working directory, there will be created three new files:

- `input_tape.out`: contains all input tape symbols
- `storage.out`: contains log of register tape changes during emulation
- `output_tape.out`: contains all output tape symbols

Content of each file is a human-readable text file, but also parseable by computer. Every row has format:

    position symbol

where `position` is zero-based index of a symbol on particular tape, and `symbol` is the symbol on that position.
Abstract tapes of RAM machine are left-bounded, therefore all positions start at 0.
