---
layout: default
title: Automation
nav_order: 5
parent: SSEM
permalink: /ssem/automation
---

{% include analytics.html category="SSEM" %}

# Automation

SSEM computer will recognize if automatic emulation is executed. In the case of non-interactive mode (`--nogui`),
the memory final "snapshot" along with additional information is written to a file named `ssem.out`.

The file is overwritten after each emulation "stop".

## Example

The emulator automation can be run as follows:

    ./emuStudio --config config/SSEMBaby.toml --nogui --auto --input examples/as-ssem/noodle-timer.ssem

- computer configuration `config/SSEMBaby.toml` will be loaded
- input file for compiler is one of the examples
- (`--auto`) automatic emulation will be performed
- (`--nogui`) non-interactive mode will be set

The console will contain information about emulation progress:

{:.code-example}
```
[INFO] Loading virtual computer: config/SSEMBaby.toml
[INFO] Starting emulation automation...
[INFO] Compiler: SSEM Assembler, version 0.41
[INFO] CPU: SSEM CPU, version 0.41
[INFO] Memory: SSEM memory (Williams-Kilburn Tube), version 0.41
[INFO] Memory size: 128
[INFO] Device: SSEM CRT display, version 0.41
[INFO] Compiling input file: examples/as-ssem/noodle-timer.ssem
[INFO] Compiler started working.
[INFO] [Info   ] SSEM Assembler, version 0.41
[INFO] [Info   ] Compile was successful (program starts at 0000). Output: /home/vbmacher/emuStudio/examples/as-ssem/noodle-timer.bin
[INFO] Compilation finished.
[INFO] Program start address: 0000h
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Instruction location = 005Ch
[INFO] Emulation completed
```

the emulation will run without user interaction, and file `ssem.out` will be created with the following content:

{:.code-example}
```
ACC=0x3bfffe2
CI=0x58

   L L L L L 5 6 7 8 9 0 1 2 I I I 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
00                                                                 
01             * * * * *       *   * * * * * * * * * * * * * * * * 
02     * * *       *         * *               * * * *             
03     * * *       *           *               * * * *             
04 *   * * *       *             *             * * * *             
05                           * *           * * * * * * * *         
06 * * * * *     * * *         *               * * * *             
07 * *   * *       *             *             * * * *             
08                 *           * *             * * * *             
09   *   * *     * * *                 * * * * * * * * * * * *     
10 *   *                       *               * * * *             
11 * *   * *   *       *         *             * * * *             
12     * * *   * *   * *     * *               * * * *             
13     * * *   *   *   *       *           * * * * * * * *         
14 *   *       *       *     * *               * * * *             
15 *                           *               * * * *             
16 * *   * *   * * * * *         *             * * * *             
17     * * *   * * * *       * *       * * * * * * * * * * * *     
18     * * *   * * * * *       *               * * * *             
19 *                         * *               * * * *             
20   * * * *   * * * *           *             * * * *             
21             *       *       * *         * * * * * * * *         
22             * * * *       * * *             * * * *             
23             *     *                         * * * *             
24             *       *                       * * * *             
25                                 * * * * * * * * * * * * * * * * 
26   * *                                                           
27 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
28             *         * * *   *                                 
29                                             *       * * * * * * 
30   * * * *   * * * * *       *   * * * * * *         * * * * * * 
31         *   * *   * *                                         * 
```
