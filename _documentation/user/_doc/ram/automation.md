---
layout: default
title: Automation
nav_order: 6
parent: RAM
permalink: /ram/automation
---

{% include analytics.html category="RAM" %}

# Automation

RAM computer will recognize if automatic emulation is executed. In the case of non-interactive mode (`--nogui`),
each abstract tape is redirected to a file. The format of the files is described in [abstract tape documentation]({{ site.baseurl}}/ram/abstract-tape).

## Example

Command line for starting non-interactive automatic emulation:

    ./emuStudio --config config/RandomAccessMachineRAM.toml --input examples/ramc-ram/factorial.ram --auto --nogui

- configuration `config/RandomAccessMachineRAM.toml` will be loaded
- input file for compiler is one of the examples
- (`--auto`) automatic emulation will be performed
- (`--nogui`) non-interactive mode will be set

After the run, the following output on the stdout can be expected:

{:.code-example}
```
[INFO] Loading virtual computer: config/RandomAccessMachineRAM.toml
[INFO] Being verbose. Writing to file:registers_(storage_tape).out
[INFO] Being verbose. Writing to file:input_tape.out
[INFO] Being verbose. Writing to file:output_tape.out
[INFO] Starting emulation automation...
[INFO] Compiler: RAM Compiler, version 0.40-SNAPSHOT
[INFO] CPU: Random Access Machine (RAM), version 0.40-SNAPSHOT
[INFO] Memory: RAM Program Tape, version 0.40-SNAPSHOT
[INFO] Memory size: 0
[INFO] Device: Registers (storage tape), version 0.40-SNAPSHOT
[INFO] Device: Input tape, version 0.40-SNAPSHOT
[INFO] Device: Output tape, version 0.40-SNAPSHOT
[INFO] Compiling input file: examples/ramc-ram/factorial.ram
[INFO] Compiler started working.
[INFO] [Info   ] RAM Compiler, version 0.40-SNAPSHOT
[INFO] [Info   ] Compile was successful.
[INFO] [Info   ] Compiled file was loaded into program memory.
[INFO] [Info   ] Compilation was saved to the file: /home/vbmacher/emuStudio/examples/ramc-ram/factorial.bram
[INFO] Compilation finished.
[INFO] Program start address: 0000h
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 0011h
[INFO] Emulation completed
```

Then, in the current working directory, there will be created three new files:

- `input_tape.out`
- `registers_(storage_tape).out`
- `output_tape.out`
