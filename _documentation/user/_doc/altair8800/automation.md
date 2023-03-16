---
layout: default
title: Automation
nav_order: 11
parent: MITS Altair8800
permalink: /altair8800/automation
---

{% include analytics.html category="Altair8800" %}

# Automation

MITS Altair8800 computer is capable of running automatic emulation. Automation can operate in the
interactive or non-interactive mode.

In case of the non-interactive mode (`--no-gui` flag set in the command line), the input and output of the terminal
ADM-3A will be redirected to files, instead of terminal GUI. The input/output file names are configurable, please refer
to [ADM-3A terminal documentation]({{ site.baseurl }}/altair8800/adm3a-terminal#configuration-file).

## Example

In this example we will run a non-interactive automatic emulation. Input for the terminal will be stored in a default
file name `adm3A-terminal.in`. The content of the file must be prepared in the advance, e.g.:

{:.code-example}
```
Hello, world!

```

NOTE: Do not forget to keep the last EOL character!

The following command will emulate the computer and run "reverse text" program on it:

    ./emuStudio -cf config/MITSAltair8800.toml --input-file examples/as-8080/reverse.asm auto --no-gui

- computer configuration "MITS Altair8800" (file `config/MITSAltair8800.toml`) will be loaded
- input file for compiler is one of the examples
- (`--auto`) automatic emulation will be executed
- (`--no-gui`) non-interactive mode will be set

After the program finishes, emuStudio is closed. The program output will be in the file `adm3A-terminal.out`:

{:.code-example}
```
Reversed text ...
Enter text: Hello, world!
!dlrow ,olleH
```

Console will contain additional information about the emulation progress:

{:.code-example}
```
[INFO] [88-SIO, device=LSI ADM-3A terminal] Device was attached
[INFO] Starting emulation automation...
[INFO] Emulating computer: MITS Altair8800
[INFO] Compiler: Intel 8080 Assembler, version 0.41
[INFO] CPU: Intel 8080 CPU, version 0.41
[INFO] Memory: Byte-cell based operating memory, version 0.41
[INFO] Memory size: 65536
[INFO] Device: MITS 88-DCDD, version 0.41
[INFO] Device: MITS 88-SIO, version 0.41
[INFO] Device: LSI ADM-3A terminal, version 0.41
[INFO] Compiling input file: examples/as-8080/reverse.asm
[INFO] Compiler started working.
[INFO] [INFO   ] Intel 8080 Assembler, version 0.41
[INFO] [INFO   ] Compile was successful.
	Output: /home/vbmacher/tmp/emuStudio-release/examples/as-8080/reverse.hex
	Program starts at 0x03E8
[INFO] [INFO   ] Compiled file was loaded into memory.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 041Ch
[INFO] Emulation completed
```
