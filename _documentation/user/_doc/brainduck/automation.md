---
layout: default
title: Automation
nav_order: 2
parent: BrainDuck
permalink: /brainduck/automation
---

{% include analytics.html category="BrainDuck" %}

# Automation

BrainDuck computer is capable of running automatic emulation. Automation can operate in the
interactive or non-interactive mode.

## Non-interactive mode

If a `--no-gui` flag is set, the input and output will be redirected to files, instead of terminal GUI.

Default input file is called `vt100-terminal.in` and must be placed in the directory from which emuStudio was executed.
A missing input file produces a warning. Output-only programs can still run; programs requesting more input than the
file supplies wait for input and need a timeout or a manual stop.

Default output file is called `vt100-terminal.out` and it will be created automatically or overwritten when it exists in
the location from which emuStudio was executed.

The input/output file names are configurable, please refer to [VT100 terminal documentation]({{ site.baseurl }}/brainduck/terminal#configuration-file).

## Be careful of EOLs

Take care of end-of-line characters. Most of brainfuck programs count with Unix-like EOLs, i.e. characters with ASCII
code 10. plugin `vt100-terminal` interprets ENTER key in the interactive mode as Unix-like EOL. In the
non-interactive mode, EOL may be of any-like type.

## Example

Command line for starting non-interactive automatic emulation:

    ./emuStudio -cn "BrainDuck" -i examples/brainc-brainduck/mandelbrot.b auto --no-gui

- computer configuration named "BrainDuck", file `config/BrainDuck.toml`, will be loaded
- input file for compiler is one of the examples
- (`auto`) automatic emulation will be executed

This command runs without terminal windows and closes emuStudio after the program finishes. The console will contain
additional information about the emulation progress:

{:.code-example}
```
[WARN] Input file vt100-terminal.in does not exist
[INFO] Starting emulation automation...
[INFO] Emulating computer: BrainDuck
[INFO] Compiling input file: examples/brainc-brainduck/mandelbrot.b
[INFO] Compiler started working.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Emulation completed
```
