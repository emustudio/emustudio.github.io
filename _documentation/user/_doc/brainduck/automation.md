---
layout: default
title: Automation
nav_order: 6
parent: BrainDuck
permalink: /brainduck/automation
---

# Automation

BrainDuck computer will recognize if automatic emulation is executed.
 
## Non-interactive mode
 
If a `--nogui` flag is set, the input and output will be redirected to files, instead of terminal GUI.

The input file is called `brainduck-terminal.in` and must be placed in the directory from which emuStudio was executed. If the file does not exist, emuStudio will not run.

The output file is called `brainduck-terminal.out` and it will be created automatically or appended when it exists in the location from which emuStudio was executed.

## Be careful of EOLs

Take care of end-of-line characters. Most of brainfuck programs count with Unix-like EOLs, i.e. characters with ASCII code 10. plugin `brainduck-terminal` interprets ENTER key in the interactive mode as Unix-like EOL. In the non-interactive mode, EOL may be of any-like type.

## Example

Command line for starting non-interactive automatic emulation:

    ./emuStudio --auto --config config/BrainDuck.toml --input examples/brainc-brainduck/mandelbrot.b

- computer configuration `config/BrainDuck.toml` will be loaded
- input file for compiler is one of the examples
- (`--auto`) automatic emulation will be performed

This command will show terminal GUI and after the program finishes, emuStudio is closed. The console will contain
additional information about the emulation progress:

```
[INFO] Starting emulation automation...
[INFO] Compiler: BrainDuck Compiler, version 0.40-SNAPSHOT
[INFO] CPU: BrainDuck CPU, version 0.40-SNAPSHOT
[INFO] Memory: BrainDuck memory, version 0.40-SNAPSHOT
[INFO] Memory size: 65536
[INFO] Device: BrainDuck terminal, version 0.40-SNAPSHOT
[INFO] Compiling input file: examples/brainc-brainduck/mandelbrot.b
[INFO] Compiler started working.
[INFO] [Info   ] BrainDuck Compiler, version 0.40-SNAPSHOT
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