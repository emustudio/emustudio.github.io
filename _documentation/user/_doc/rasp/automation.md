---
layout: default
title: Automation
nav_order: 4
parent: RASP
permalink: /rasp/automation
---

# Automation

RASP computer will recognize if automatic emulation is executed. In the case of non-interactive mode (`--nogui`),
each abstract tape is redirected to a file. The format of the files is described in [abstract tape documentation]({{ site.baseurl}}/ram/abstract-tape).

## Example

Command line for starting non-interactive automatic emulation:

    ./emuStudio --config config/RandomAccessStoredProgramRASP.toml --input examples/ramspc-rasp/instr_modif.rasp --auto --nogui

- configuration `config/RandomAccessStoredProgramRASP.toml` will be loaded
- input file for compiler is one of the examples
- (`--auto`) automatic emulation will be performed
- (`--nogui`) non-interactive mode will be set

After the run, the following output on the stdout can be expected:

```
[INFO] Loading virtual computer: config/RandomAccessStoredProgramRASP.toml
[INFO] Being verbose. Writing to file:input_tape.out
[INFO] Being verbose. Writing to file:output_tape.out
[INFO] Starting emulation automation...
[INFO] Compiler: RASP Assembler, version 0.40-SNAPSHOT
[INFO] CPU: Random Access Stored Program (RASP) machine, version 0.40-SNAPSHOT
[INFO] Memory: RASP Memory, version 0.40-SNAPSHOT
[INFO] Memory size: 0
[INFO] Device: Input tape, version 0.40-SNAPSHOT
[INFO] Device: Output tape, version 0.40-SNAPSHOT
[INFO] Compiling input file: examples/raspc-rasp/instr_modif.rasp
[INFO] Compiler started working.
[INFO] [Info   ] Compilation was successful.
[INFO] [Info   ] Program was loaded into program memory
[INFO] Compilation finished.
[INFO] Program start address: 0005h
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 0017h
[INFO] Emulation completed
```

Then, in the current working directory, there will be created two new files:

- `input_tape.out`
- `output_tape.out`
