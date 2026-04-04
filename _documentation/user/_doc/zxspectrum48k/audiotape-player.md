---
layout: default
title: Device "audiotape-player"
nav_order: 6
parent: ZX Spectrum 48K
permalink: /zxspectrum48k/audiotape-player
---

{% include analytics.html category="ZXSpectrum48K" %}

# Audio Tape Player

The `audiotape-player` plugin emulates a cassette tape deck connected to the ZX Spectrum. It allows loading tape image
files in TAP and TZX formats and playing them back into the emulated ZX Spectrum, as if the user were loading software
from a real cassette tape.

The tape player connects to the ZX Spectrum bus and writes data signals that the ULA reads through the EAR input
(bit 6 of port `0xFE`). During playback, the familiar loading sounds are audible through the beeper at a reduced volume.

## Supported formats

|---
| Format | Description
|-|-
| `.tap` | TAP format — a simple concatenation of data blocks as they would appear on tape. Each block is preceded by a 2-byte length field. Widely used and straightforward.
| `.tzx` | TZX format — a more advanced format supporting standard speed data blocks, turbo speed blocks, pure tone pulses, pulse sequences, and other tape features. TZX support is partial (work in progress).
|---

## GUI overview

The tape player window can be opened from the device list when the emulation is running:

![Audio Tape Player]({{ site.baseurl }}/assets/zxspectrum48k/audiotape-player.png)

The window is divided into two panels:

### Available tapes (left panel)

The left panel allows browsing for tape files on the filesystem:

- **Directory selector** — use the folder icon button to browse and select a directory containing tape files
- **Tape list** — displays all `.tap` and `.tzx` files found in the selected directory
- **Refresh** — refreshes the file list from the selected directory
- **Load** — loads the selected tape file into the tape deck (inserts the tape)

### Audio tape (right panel)

The right panel shows the currently loaded tape and playback controls:

- **File name** — shows the name of the currently loaded tape file
- **Status** — shows the current state of the tape (UNLOADED, STOPPED, PLAYING, CLOSED)
- **Events log** — displays information about tape blocks and pulses during playback
- **Play** — starts playback of the loaded tape
- **Stop** — stops the currently playing tape
- **Eject** — removes the loaded tape from the deck

## Usage

To load software from tape into the ZX Spectrum:

1. Open the Audio Tape Player from the device list
2. Browse to a directory containing tape files using the folder icon
3. Select a tape file from the list and click **Load**
4. In the ZX Spectrum, type `LOAD ""` and press ENTER (or use the appropriate BASIC command for the software)
5. Click **Play** in the tape player
6. The software will load from the tape — you should hear the loading sounds through the beeper

The tape will automatically stop when all blocks have been played back.

## Where to find tape files

ZX Spectrum software in TAP and TZX format can be found at various online archives:

- [Speccy.cz][speccy]{:target="_blank"} — Czech ZX Spectrum archive
- [World of Spectrum][wos]{:target="_blank"} — comprehensive ZX Spectrum archive
- [Planet Emu][planetemu]{:target="_blank"} — ZX Spectrum tape images


[speccy]: https://cs.speccy.cz/
[wos]: https://worldofspectrum.org/
[planetemu]: https://www.planetemu.net/roms/sinclair-zx-spectrum-demos-tap


