---
layout: default
title: Automation
nav_order: 10
parent: MITS Altair8800
permalink: /altair8800/automation
---

# Automation

MITS Altair8800 computer will recognize if automatic emulation is executed. The automation can operate in the interactive
or non-interactive mode.

In case of the non-interactive mode (`--nogui` flag set in the command line), the input and output of the terminal ADM-3A will be redirected to files, instead of terminal GUI. The input/output file names are configurable, please refer to
[ADM-3A terminal documentation]({{ site.baseurl }}/altair8800/adm3a-terminal#configuration-file). 

## Example

In this example we will run a non-interactive automatic emulation. Input for the terminal will be stored in a file
`adm3A-terminal.in`. The content of the file must be prepared in the advance, e.g.:

{:.code-example}
```
Hello, world!

```

NOTE: Do not forget to keep the last EOL character!

The following command will emulate the computer and run "reverse text" program on it:

    ./emuStudio --auto --nogui --config config/MITSAltair8800.toml --input examples/as-8080/reverse.asm

- computer configuration `config/MITSAltair8800.toml` will be loaded
- input file for compiler is one of the examples
- (`--auto`) automatic emulation will be performed    
- (`--nogui`) non-interactive mode will be set

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
[INFO] Loading virtual computer: config/MITSAltair8800.toml
[INFO] [device=LSI ADM-3A Terminal] Device was attached to 88-SIO
[INFO] Processing input file: 'adm3A-terminal.in'; delay of chars read (ms): 0
[INFO] Starting emulation automation...
[INFO] Compiler: Intel 8080 Assembler, version 0.40-SNAPSHOT
[INFO] CPU: Intel 8080 CPU, version 0.40-SNAPSHOT
[INFO] Memory: Standard operating memory, version 0.40-SNAPSHOT
[INFO] Memory size: 65536
[INFO] Device: MITS 88-DISK device, version 0.40-SNAPSHOT
[INFO] Device: MITS 88-SIO serial board, version 0.40-SNAPSHOT
[INFO] Device: LSI ADM-3A terminal, version 0.40-SNAPSHOT
[INFO] Compiling input file: examples/as-8080/reverse.asm
[INFO] Compiler started working.
[INFO] [Info   ] Intel 8080 Assembler, version 0.40-SNAPSHOT
[INFO] [Info   ] Compilation was successful.
 Output file: /home/vbmacher/emuStudio/examples/as-8080/reverse.hex
[INFO] [Info   ] Compiled file was loaded into memory.
[INFO] Compilation finished.
[INFO] Program start address: 03E8h
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 041Ch
[INFO] Emulation completed
```
