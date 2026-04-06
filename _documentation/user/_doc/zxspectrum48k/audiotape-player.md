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
| `.tzx` | TZX format — a more advanced format that can describe various tape encoding schemes. Most block types are supported (see [Supported TZX blocks](#supported-tzx-blocks) below).
|---

## GUI overview

The tape player window can be opened from the device list when the emulation is running:

![Audio Tape Player]({{ site.baseurl }}/assets/zxspectrum48k/audiotape-player.png)

The window is divided into two panels separated by a resizable split pane.

### Available tapes (left panel)

The left panel allows browsing for tape files on the filesystem:

{: .list}
| <span class="circle">1</span> | **Directory selector** — use the folder icon button to browse and select a directory containing tape files. Previously selected directories are remembered in the dropdown for quick switching.
| <span class="circle">2</span> | **Refresh** — refreshes the file list from the selected directory
| <span class="circle">3</span> | **Load** — loads the selected tape file into the tape deck (inserts the tape)

### Audio tape (right panel)

The right panel shows the currently loaded tape, playback controls, and an event log:

{: .list}
| <span class="circle">4</span> | **Events log** — a table showing detailed information about tape blocks and pulses during playback. Allows to select multiple rows and then with Ctrl+C to copy them to the clipboard.
| <span class="circle">5</span> | **Play** — starts playback of the loaded tape
| <span class="circle">6</span> | **Stop** — stops the currently playing tape (the tape remains loaded)
| <span class="circle">7</span> | **Eject** — stops playback and removes the loaded tape from the deck
| <span class="circle">8</span> | **Copy** — copies selected rows from the events table to the clipboard (also available via `Ctrl+C`)
| <span class="circle">9</span> | **Save** — saves the full event log to a file. Supported file formats are tab-separated values (`.tsv`) and plain text (`.txt`)


The panel header shows:
- **File name** — shows the name of the currently loaded tape file (or "N/A" if no tape is loaded)
- **Status** — shows the current state of the tape:

|---
| State | Description
|-|-
| `UNLOADED` | No tape is loaded in the deck
| `STOPPED` | A tape is loaded and ready to play (or playback has finished)
| `PLAYING` | The tape is currently being played back
| `CLOSED` | The plugin has been destroyed (terminal state)
|---

- **Events log** — a table showing detailed information about tape blocks and pulses during playback. The table has
  four columns:

|---
| Column | Description
|-|-
| T-state | The CPU T-state at which the event occurred
| Length | Pulse length in T-states (0 for non-pulse events)
| Event | Event type (see [Event types](#event-types) below)
| Details | Additional information about the event
|---

### Event types

During playback, the events log displays the following event types:

|---
| Event | Description
|-|-
| `PAUSE` | Pause/silence between blocks or initial pause before tape data begins
| `PILOT` | Leader tone pulse — a series of identical pulses used for synchronisation. Header blocks use 8063 pilot pulses, data blocks use 3223. Also used for turbo speed blocks with custom timing.
| `SYNC1` | First sync pulse (667 T-states for standard speed) marking the transition from leader tone to data
| `SYNC2` | Second sync pulse (735 T-states for standard speed)
| `SYNC3` | End-of-block sync pulse (954 T-states)
| `FLAG` | Block flag byte — `0x00` for header blocks, `0xFF` for data blocks
| `PROGRAM` | Header describes a BASIC program (with filename, auto-start line, and program length)
| `NUMBER ARRAY` | Header describes a number array variable
| `STRING ARRAY` | Header describes a string array variable
| `MEMORY BLOCK` | Header describes a code/memory block (with filename and start address)
| `DATA` | Raw data bytes being transmitted (standard speed)
| `CHECKSUM` | Block checksum byte
| `TURBO DATA` | Data bytes from a turbo speed data block (TZX block `0x11`)
| `PURE TONE` | Pure tone — a sequence of equal-length pulses (TZX block `0x12`)
| `PULSE SEQ` | Pulse sequence — a series of pulses with varying lengths (TZX block `0x13`)
| `PURE DATA` | Pure data block — data without pilot tone or sync pulses (TZX block `0x14`)
| `DIRECT REC` | Direct recording — raw sample data (TZX block `0x15`)
| `CSW REC` | CSW recording block (TZX block `0x18`, not yet fully supported)
| `GEN DATA` | Generalized data block (TZX block `0x19`, not yet fully supported)
| `STOP TAPE` | Stop the tape and wait for user to resume (pause duration = 0)
| `GROUP` | Group start marker with group name (TZX block `0x21`)
| `GROUP END` | Group end marker (TZX block `0x22`)
| `STOP 48K` | Stop the tape if in 48K mode (TZX block `0x2A`)
| `SIGNAL` | Set signal level (TZX block `0x2B`)
| `TEXT` | Text description embedded in the tape file (TZX block `0x30`)
| `MESSAGE` | Message block with display time (TZX block `0x31`)
| `ARCHIVE` | Archive information — title, author, publisher, etc. (TZX block `0x32`)
| `HARDWARE` | Hardware type information (TZX block `0x33`)
| `CUSTOM` | Custom info block (TZX block `0x35`)
| `GLUE` | Glue block — used to merge multiple TZX files (TZX block `0x5A`)
|---

## Usage

To load software from tape into the ZX Spectrum:

1. Open the Audio Tape Player from the device list
2. Browse to a directory containing tape files using the folder icon
3. Select a tape file from the list and click **Load**
4. In the ZX Spectrum, type `LOAD ""` and press ENTER (or use the appropriate BASIC command for the software)
5. Click **Play** in the tape player
6. The software will load from the tape — you should hear the loading sounds through the beeper

The tape will automatically stop when all blocks have been played back.

{: .info}
> The emulation reset will stop and eject any currently loaded tape.

## Tape signal encoding

The audio tape player reproduces the standard ZX Spectrum tape encoding. Each tape block is transmitted as a series
of square-wave pulses with specific timings (measured in Z80 T-states at 3.5 MHz):

|---
| Signal component | Pulse length (T-states) | Notes
|-|-|-
| Leader (pilot) tone | 2168 | 8063 pulses for header, 3223 for data blocks
| Sync pulse 1 | 667 | Marks start of data
| Sync pulse 2 | 735 | Follows sync 1
| Data bit 0 | 855 | Two pulses per zero bit
| Data bit 1 | 1710 | Two pulses per one bit
| End-of-block sync | 954 | Marks end of block
| Inter-block pause | ~2 seconds | Silence between blocks
|---

Each data byte is transmitted MSB-first. Every bit is represented by two consecutive pulses of equal length — short
pulses (855 T-states) for a zero bit, long pulses (1710 T-states) for a one bit.

A standard tape block consists of:
1. **Leader tone** — a long series of identical pulses for synchronisation
2. **Sync pulses** — two short pulses marking the start of data
3. **Flag byte** — `0x00` for header blocks, `0xFF` for data blocks
4. **Data** — the block content
5. **Checksum** — XOR of the flag byte and all data bytes

## Supported TZX blocks

The following TZX block types are supported:

|---
| Block ID | Name | Status
|-|-|-
| `0x10` | Standard Speed Data Block | ✅ Fully supported
| `0x11` | Turbo Speed Data Block | ✅ Fully supported
| `0x12` | Pure Tone | ✅ Fully supported
| `0x13` | Pulse Sequence | ✅ Fully supported
| `0x14` | Pure Data Block | ✅ Fully supported
| `0x15` | Direct Recording | ✅ Fully supported
| `0x18` | CSW Recording | ⚠️ Parsed but not yet fully decoded
| `0x19` | Generalized Data Block | ⚠️ Parsed but not yet fully decoded
| `0x20` | Pause / Stop the Tape | ✅ Fully supported
| `0x21` | Group Start | ✅ Fully supported
| `0x22` | Group End | ✅ Fully supported
| `0x23` | Jump to Block | ✅ Fully supported
| `0x24` | Loop Start | ✅ Fully supported
| `0x25` | Loop End | ✅ Fully supported
| `0x26` | Call Sequence | ✅ Fully supported
| `0x27` | Return from Sequence | ✅ Fully supported
| `0x28` | Select Block | ❌ Not supported (skipped with warning)
| `0x2A` | Stop the Tape if in 48K Mode | ✅ Fully supported
| `0x2B` | Set Signal Level | ✅ Fully supported
| `0x30` | Text Description | ✅ Fully supported
| `0x31` | Message Block | ✅ Fully supported
| `0x32` | Archive Info | ✅ Fully supported
| `0x33` | Hardware Type | ✅ Fully supported
| `0x35` | Custom Info Block | ✅ Fully supported
| `0x5A` | Glue Block | ✅ Fully supported
|---

{: .info}
> The Select Block (`0x28`) requires interactive user input to choose a tape path and is currently not supported.
> CSW Recording (`0x18`) and Generalized Data Block (`0x19`) are parsed and logged but their audio data is not yet
> played back.

## Where to find tape files

ZX Spectrum software in TAP and TZX format can be found at various online archives:

- [Speccy.cz][speccy]{:target="_blank"} — Czech ZX Spectrum archive
- [World of Spectrum][wos]{:target="_blank"} — comprehensive ZX Spectrum archive
- [Planet Emu][planetemu]{:target="_blank"} — ZX Spectrum tape images


[speccy]: https://cs.speccy.cz/
[wos]: https://worldofspectrum.org/
[planetemu]: https://www.planetemu.net/roms/sinclair-zx-spectrum-demos-tap
