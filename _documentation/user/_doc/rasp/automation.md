---
layout: default
title: Automation
nav_order: 4
parent: RASP
permalink: /rasp/automation
---

{% include analytics.html category="RASP" %}

# Automation

RASP computer will recognize if automatic emulation is executed. In the case of non-interactive mode (`--nogui`),
each abstract tape is redirected to a file. The format of the files is described in
[abstract tape documentation]({{site.baseurl}}/ram/abstract-tape).

## Example

Command line for starting non-interactive automatic emulation:

    ./emuStudio -cf config/RandomAccessStoredProgramRASP.toml --input-file examples/raspc-rasp/factorial.rasp auto --no-gui

- configuration `config/RandomAccessStoredProgramRASP.toml` will be loaded
- input file for compiler is one of the standard examples
- (`auto`) automatic emulation will be executed
- (`--no-gui`) non-interactive mode will be set

After the run, the following output on the stdout can be expected:

{:.code-example}
```
[INFO] Starting logging symbols changes to a file: input_tape.out
[INFO] Starting logging symbols changes to a file: output_tape.out
[INFO] Starting emulation automation...
[INFO] Emulating computer: Random-Access Stored Program (RASP)
[INFO] Compiler: RASP Machine Assembler, version 0.41
[INFO] CPU: Random Access Stored Program (RASP), version 0.41
[INFO] Memory: RASP Memory, version 0.41
[INFO] Memory size: 0
[INFO] Device: Input tape, version 0.41
[INFO] Device: Output tape, version 0.41
[INFO] Compiling input file: examples/raspc-rasp/factorial.rasp
[INFO] Compiler started working.
[INFO] [INFO   ] RASP Machine Assembler, version 0.41
[INFO] [INFO   ] Compile was successful.
	Output: /home/emuStudio/examples/raspc-rasp/factorial.brasp
	Program starts at 0x0014
[INFO] [INFO   ] Compiled file was loaded into program memory.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 0x0037
[INFO] Emulation completed
```

Then, in the current working directory, there will be created three new files:

- `input_tape.out`: contains all input tape symbols
- `output_tape.out`: contains all output tape symbols

Content of each file is a human-readable text file, but also parseable by computer. Every row has format:

    position symbol

where `position` is zero-based index of a symbol on particular tape, and `symbol` is the symbol on that position.
Abstract tapes of RASP machine are left-bounded, therefore all positions start at 0.
