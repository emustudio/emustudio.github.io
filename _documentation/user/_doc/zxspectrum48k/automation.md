---
layout: default
title: Automation
nav_order: 8
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/automation
---

{% include analytics.html category="ZXSpectrum48K" %}

# Automation

ZX Spectrum 48K computer is capable of running automatic emulation. Automation can operate in the interactive or
non-interactive mode.

In the interactive mode, the ZX Spectrum display window and audio tape player are shown automatically, allowing the
user to interact with the emulated computer.

In the non-interactive mode (`--no-gui` flag set in the command line), no GUI windows are shown. The emulation runs
"headless" — there is no display output, no keyboard input, and no audio. This mode is useful for automated testing
or batch processing.

## Configuration file

The ZX Spectrum 48K configuration file is `config/ZxSpectrum48K.toml`. The key settings are:

### Memory (`byte-mem`) settings

The most important setting is loading the 48K ROM image at startup. This is configured in the `[MEMORY.settings]`
section:

|---
| Setting | Description
|-|-
| `imageName0` | Path to the 16 KB ROM file (e.g. `examples/zxspectrum-48k/48.rom`)
| `imageAddress0` | Load address for the ROM (must be `0`)
| `imageBank0` | Memory bank (must be `0`)
|---

### CPU (`z80-cpu`) settings

|---
| Setting | Default | Description
|-|-|-
| `frequency_khz` | 3500 | CPU clock frequency in kHz (3500 = 3.5 MHz, the standard ZX Spectrum clock)
|---

### Example configuration

{:.code-example}
```toml
name = "ZX Spectrum 48K"

[MEMORY]
    path = "byte-mem.jar"
    name = "byte-mem"
    type = "MEMORY"

    [MEMORY.settings]
        banksCount = 0
        imageName0 = "examples/zxspectrum-48k/48.rom"
        imageAddress0 = 0
        imageBank0 = 0
        commonBoundary = 0

[COMPILER]
    path = "as-z80.jar"
    name = "as-z80"
    type = "COMPILER"

[CPU]
    path = "z80-cpu.jar"
    name = "z80-cpu"
    type = "CPU"

    [CPU.settings]
        frequency_khz = 3500

[[DEVICE]]
    path = "zxspectrum-ula.jar"
    name = "zxspectrum-ula"
    type = "DEVICE"

[[DEVICE]]
    path = "audiotape-player.jar"
    name = "audiotape-player"
    type = "DEVICE"

[[DEVICE]]
    path = "zxspectrum-bus.jar"
    name = "zxspectrum-bus"
    type = "DEVICE"
```

NOTE: The connections between plugins are also defined in the configuration file but are omitted here for brevity.
The bus plugin must be connected to the CPU, memory, ULA, and audio tape player.

## Example

The following command runs the ZX Spectrum 48K emulator in interactive automation mode with a beeper example:

    ./emuStudio -cf config/ZxSpectrum48K.toml --input-file examples/zx-spectrum/twinkle_beeper.asm auto

- computer configuration "ZX Spectrum 48K" (file `config/ZxSpectrum48K.toml`) will be loaded
- input file for compiler is the beeper example
- (`auto`) automatic emulation will be executed (interactive mode — display and devices will be shown)

For non-interactive mode:

    ./emuStudio -cf config/ZxSpectrum48K.toml --input-file examples/zx-spectrum/twinkle_beeper.asm auto --no-gui

Console will contain information about the emulation progress:

{:.code-example}
```
[INFO] Starting emulation automation...
[INFO] Emulating computer: ZX Spectrum 48K
[INFO] Compiler: Zilog Z80 Assembler, version 0.42
[INFO] CPU: Zilog Z80 CPU, version 0.42
[INFO] Memory: Byte-cell based operating memory, version 0.42
[INFO] Device: ZX Spectrum Bus, version 0.42
[INFO] Device: ZX Spectrum48K ULA, version 0.42
[INFO] Device: Audio Tape Player, version 0.42
[INFO] Compiling input file: examples/zx-spectrum/twinkle_beeper.asm
[INFO] Compiler started working.
[INFO] [INFO   ] Zilog Z80 Assembler, version 0.42
[INFO] [INFO   ] Compile was successful.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Running emulation...
```


