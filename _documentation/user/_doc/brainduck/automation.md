---
layout: default
title: Automation
nav_order: 7
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
If the file does not exist, emuStudio will not run.

Default output file is called `vt100-terminal.out` and it will be created automatically or appended when it exists in
the location from which emuStudio was executed.

The input/output file names are configurable, please refer to [VT100 terminal documentation]({{ site.baseurl }}/brainduck/vt100-terminal#configuration-file).

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

This command will show terminal GUI and after the program finishes, emuStudio is closed. The console will contain
additional information about the emulation progress:

{:.code-example}
```
[INFO] Starting emulation automation...
[INFO] Compiler: BrainDuck Compiler, version 0.41
[INFO] CPU: BrainDuck CPU, version 0.41
[INFO] Memory: Byte-cell based operating memory, version 0.41
[INFO] Memory size: 65536
[INFO] Device: VT100 Terminal, version 0.41
[INFO] Compiling input file: examples/brainc-brainduck/mandelbrot.b
[INFO] Compiler started working.
[INFO] [Info   ] BrainDuck Compiler, version 0.41
[INFO] [Info   ] Compile was successful. Output: /home/vbmacher/emuStudio/examples/brainc-brainduck/mandelbrot.hex
[INFO] [Info   ] Compiled file was loaded into operating memory.
[INFO] Compilation finished.
[INFO] Program start address: 0000h
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 2CBCh
[INFO] Emulation completed
```
