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
user to interact with the emulated computer. If any automation events are configured, they are executed.

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

## Tape automation

The [Audio Tape Player]({{ site.baseurl }}/zxspectrum48k/audiotape-player) supports automation events that can
automatically load and play tape files. This is especially useful in non-interactive mode for running test suites
or loading software without user interaction.

### Configuring tape automation events

Automation events are stored in the `audiotape-player` plugin settings under the `automationEvents` key. Each event
is serialized as `TYPE:parameter`:

|---
| Event | Serialized format | Description
|-|-|-
| Load tape | `LOAD_TAPE:/path/to/file.tap` | Load a tape file into the deck
| Play tape | `PLAY:` | Start playback and wait until the tape finishes
| Stop tape | `STOP:` | Stop the currently playing tape
| Reset tape | `RESET:` | Stop and unload the current tape
| Unload tape | `UNLOAD:` | Stop playback and unload the tape
| Delay | `DELAY:5` | Wait for the specified number of seconds
|---

### Example tape automation configuration

To configure tape automation events in the configuration file, add the `automationEvents` array to the
`audiotape-player` settings:

{:.code-example}
```toml
[[DEVICE]]
    path = "audiotape-player.jar"
    name = "audiotape-player"
    type = "DEVICE"

    [DEVICE.settings]
        automationEvents = [
            "LOAD_TAPE:/path/to/game.tap",
            "DELAY:3",
            "PLAY:"
        ]
```

When running with the `auto` flag, the automation events are executed sequentially after emulation reset. The `PLAY`
event blocks until the tape finishes playing, so subsequent events wait for playback completion.

## Example

The following command runs the ZX Spectrum 48K emulator in interactive automation mode with a beeper example:

    ./emuStudio -cf config/ZxSpectrum48K.toml --input-file examples/zx-spectrum/twinkle_beeper.asm auto

- computer configuration "ZX Spectrum 48K" (file `config/ZxSpectrum48K.toml`) will be loaded
- input file for compiler is the beeper example
- (`auto`) automatic emulation will be executed (interactive mode — display and devices will be shown)

For non-interactive mode:

    ./emuStudio -cf config/ZxSpectrum48K.toml --input-file examples/zx-spectrum/twinkle_beeper.asm auto --no-gui
