---
layout: default
title: Terminal "vt100-terminal"
nav_order: 5
parent: BrainDuck
permalink: /brainduck/terminal
---

{% include analytics.html category="BrainDuck" %}

# Terminal `vt100-terminal`

VT100 terminal is probably one of the most popular terminal ever, created by DEC in 1978. It has many functions, activated
by ASCII control sequences which became de facto a standard - ANSI X3.64 (ISO/IEC 6429). These control sequences are
emulated today by majority of modern terminals (as we like to call "command line prompts"). 

![VT100-terminal]({{ site.baseurl }}/assets/brainduck/DEC_VT100_terminal.jpg)
(Autor: Jason Scott – Flickr: IMG_9976, CC BY 2.0, [available here][vt100-image]{:target="_blank"})

VT100-terminal plugin for emuStudio implements a substantial portion of the VT100/ANSI escape-sequence set, following the
[DEC ANSI parser model][dec-parser]{:target="_blank"}. Supported features include:

- Full VT100/ANSI state-machine parser for escape sequences
- 16-color ANSI palette (8 standard + 8 bright colors) for foreground and background
- Text attributes: bold, dim/faint, italic, underline, blink, inverse, hidden, strikethrough
- Cursor movement (up, down, forward, backward, absolute positioning)
- Erase operations (display, line, character)
- Insert/delete operations (lines and characters)
- Save/restore cursor position (including graphic rendition)
- Scroll up/down with configurable scrolling region (DECSTBM)
- Configurable display size (columns × rows)
- Keyboard input; binary codes can be entered with special dialog
- Automation support (file-based I/O for headless mode)

NOTE: The plugin can also be used with MITS Altair8800. See [VT100 terminal for Altair8800]({{ site.baseurl }}/altair8800/vt100-terminal) for details.
{: .info}

## Graphical User Interface (GUI)

In the following screenshot, VT100-terminal window is shown:

![VT100-terminal window]({{ site.baseurl }}/assets/brainduck/vt100-terminal.png)

It's easy and simple. BrainDuck CPU as it interprets `.` (dot) instructions, it sends the output to this terminal, which
displays it on the screen.

Input cannot be entered anytime. In brainfuck, the input is requested through `,` instruction. Only when CPU
encounters `,` (comma) instruction, the user is asked to enter input. This situation is marked with a red icon in the
bottom-left corner:

![Input is enabled in VT100-terminal window]({{ site.baseurl }}/assets/brainduck/vt100-terminal-input.png)

Next to the icon, there is a blue "ASC" button. This button can be used for entering binary values as input. A special
little dialog will appear asking the user to enter space-separated numbers, representing ASCII codes of the input.

The display renders at approximately 60 Hz with double-buffering to avoid flicker. A block cursor tracks the current
write position.

## Display

Default display size is **80 columns × 24 rows**, configurable via settings. The display manages a character buffer
(video memory) and a parallel attribute buffer of the same size. Each cell carries its own video attribute
(foreground color, background color, and style flags).

The display supports scrolling — it rolls up when the cursor moves past the bottom row, and rolls down on reverse index
at the top row.

## Control codes

The following table shows C0 control codes handled by the terminal:

|---
| Code | ASCII mnemonic | Function
|-|-|-
| `0x05` | `ENQ` | Sends answerback message
| `0x07` | `BEL` | Bell (no audible beep yet)
| `0x08` | `BS`  | Backspace — moves cursor one position to the left
| `0x09` | `HT`  | Horizontal tabulation — moves cursor forward by 4 positions
| `0x0A` | `LF`  | Line feed — moves cursor down one row and performs carriage return
| `0x0B` | `VT`  | Vertical tabulation — same as line feed
| `0x0C` | `FF`  | Form feed — same as line feed
| `0x0D` | `CR`  | Carriage return — moves cursor to the beginning of current line
| `0x0E` | `SO`  | Shift out (Lock shift G1) — recognized but no action
| `0x0F` | `SI`  | Shift in (Lock shift G0) — recognized but no action
| `0x11` | `DC1` | Device control 1 (XON) — recognized but no action
| `0x13` | `DC3` | Device control 3 (XOFF) — recognized but no action
| `0x18` | `CAN` | Cancel — aborts current escape sequence
| `0x1A` | `SUB` | Substitute — aborts current escape sequence, displays `¿`
| `0x1B` | `ESC` | Escape — begins an escape sequence
|---

### C1 control codes (8-bit)

|---
| Code | Name | Function
|-|-|-
| `0x84` | IND  | Index — moves cursor down, scrolls if at bottom
| `0x85` | NEL  | Next line — moves cursor down (scrolls if needed) and performs carriage return
| `0x88` | HTS  | Horizontal tab set
| `0x8D` | RI   | Reverse index — moves cursor up, scrolls down if at top
|---

## Escape sequences

The following escape sequences are recognized (triggered by `ESC` followed by a character):

|---
| Sequence | Name | Function
|-|-|-
| `ESC D` | IND (Index) | Moves cursor down one row; scrolls display up if at bottom row
| `ESC M` | RI (Reverse Index) | Moves cursor up one row; scrolls display down if at top row
| `ESC E` | NEL (Next Line) | Moves cursor down (scrolls if needed) and performs carriage return
| `ESC 7` | DECSC (Save Cursor) | Saves current cursor position and graphic rendition
| `ESC 8` | DECRC (Restore Cursor) | Restores previously saved cursor position and graphic rendition
|---

## CSI (Control Sequence Introducer) sequences

CSI sequences are introduced by `ESC [` (or the 8-bit code `0x9B`), followed by optional parameters separated by
semicolons, and a final character that identifies the function.

### Cursor movement

|---
| Sequence | Name | Function
|-|-|-
| `CSI n A` | CUU (Cursor Up) | Moves cursor up by `n` rows (default 1)
| `CSI n B` | CUD (Cursor Down) | Moves cursor down by `n` rows (default 1)
| `CSI n C` | CUF (Cursor Forward) | Moves cursor forward by `n` columns (default 1)
| `CSI n D` | CUB (Cursor Backward) | Moves cursor backward by `n` columns (default 1)
| `CSI row ; col H` | CUP (Cursor Position) | Moves cursor to row and column (default 1;1 = top-left)
| `CSI row ; col f` | HVP (Horizontal and Vertical Position) | Same as CUP
|---

### Erase operations

|---
| Sequence | Name | Function
|-|-|-
| `CSI 0 J` | ED (Erase in Display) | Erase from cursor to end of screen
| `CSI 1 J` | ED | Erase from beginning of screen to cursor
| `CSI 2 J` | ED | Erase entire screen
| `CSI 0 K` | EL (Erase in Line) | Erase from cursor to end of line
| `CSI 1 K` | EL | Erase from beginning of line to cursor
| `CSI 2 K` | EL | Erase entire line
| `CSI n X` | ECH (Erase Character) | Erase `n` characters from cursor position (default 1)
|---

### Insert and delete operations

|---
| Sequence | Name | Function
|-|-|-
| `CSI n L` | IL (Insert Line) | Inserts `n` blank lines at cursor row (default 1); lines below shift down
| `CSI n M` | DL (Delete Line) | Deletes `n` lines at cursor row (default 1); lines below shift up
| `CSI n @` | ICH (Insert Character) | Inserts `n` blank characters at cursor position (default 1); characters to the right shift
| `CSI n P` | DCH (Delete Character) | Deletes `n` characters at cursor position (default 1); characters to the right shift left
|---

### Scrolling region

|---
| Sequence | Name | Function
|-|-|-
| `CSI Pt ; Pb r` | DECSTBM (Set Top and Bottom Margins) | Sets the scrolling region from row `Pt` (top, default 1) to row `Pb` (bottom, default last row). Rows are 1-based. Cursor moves to home position after this command. Scroll, insert/delete line, and line-feed operations are confined to the scrolling region.
|---

### Select Graphic Rendition (SGR)

SGR sequences set text attributes and colors. Introduced by `CSI` followed by one or more parameters separated by
semicolons, and terminated by `m`. Multiple parameters can be combined in a single sequence, for example
`CSI 1;31;42 m` sets bold, red foreground, and green background.

#### Text attributes

|---
| Code | Function | Reset code
|-|-|-
| `0`  | Reset all attributes to default | —
| `1`  | Bold (also maps standard foreground color to its bright variant) | `22`
| `2`  | Dim / faint (halves the foreground color intensity) | `22`
| `3`  | Italic | `23`
| `4`  | Underline | `24`
| `5`  | Blink (slow) | `25`
| `6`  | Blink (rapid) — treated same as slow | `25`
| `7`  | Inverse / reverse video (swaps foreground and background) | `27`
| `8`  | Hidden / invisible | `28`
| `9`  | Strikethrough | `29`
|---

#### Foreground colors

|---
| Code | Color | Bright variant code | Bright color
|-|-|-|-
| `30` | Black   | `90`  | Dark gray
| `31` | Red     | `91`  | Bright red
| `32` | Green   | `92`  | Bright green
| `33` | Yellow  | `93`  | Bright yellow
| `34` | Blue    | `94`  | Bright blue
| `35` | Magenta | `95`  | Bright magenta
| `36` | Cyan    | `96`  | Bright cyan
| `37` | White (light gray) | `97` | Bright white
| `39` | Default foreground | — | —
|---

#### Background colors

|---
| Code | Color | Bright variant code | Bright color
|-|-|-|-
| `40` | Black   | `100` | Dark gray
| `41` | Red     | `101` | Bright red
| `42` | Green   | `102` | Bright green
| `43` | Yellow  | `103` | Bright yellow
| `44` | Blue    | `104` | Bright blue
| `45` | Magenta | `105` | Bright magenta
| `46` | Cyan    | `106` | Bright cyan
| `47` | White (light gray) | `107` | Bright white
| `49` | Default background | — | —
|---

#### Extended colors

The terminal supports extended color selection using the `38;5;n` (foreground) and `48;5;n` (background) sequences,
where `n` is a color index. Only the first 16 color indices (0–15) are supported, mapping to the standard and bright
ANSI colors listed above. Color indices 16–255 are silently ignored. Truecolor sequences (`38;2;r;g;b` and
`48;2;r;g;b`) are parsed but not rendered.

### Color palette

The following 16 colors are available:

|---
| Index | Name | RGB
|-|-|-
| 0  | Black        | (0, 0, 0)
| 1  | Red          | (170, 0, 0)
| 2  | Green        | (0, 170, 0)
| 3  | Yellow       | (170, 170, 0)
| 4  | Blue         | (0, 0, 170)
| 5  | Magenta      | (170, 0, 170)
| 6  | Cyan         | (0, 170, 170)
| 7  | White        | (170, 170, 170)
| 8  | Bright black (dark gray) | (85, 85, 85)
| 9  | Bright red   | (255, 85, 85)
| 10 | Bright green | (85, 255, 85)
| 11 | Bright yellow | (255, 255, 85)
| 12 | Bright blue  | (85, 85, 255)
| 13 | Bright magenta | (255, 85, 255)
| 14 | Bright cyan  | (85, 255, 255)
| 15 | Bright white | (255, 255, 255)
|---

## Keyboard

The terminal captures key events from the terminal window and sends ASCII bytes to the connected CPU or device.
Keys with character codes above `0xFF` are ignored.

When the CPU is waiting for input, a red status icon appears in the bottom-left corner of the terminal window. An "ASC"
button next to it allows entering raw ASCII codes via a dialog — useful for sending control characters or binary values
that are not easily typed on the host keyboard.

## VT100-terminal Settings

The following screenshot shows settings dialog of the terminal:

![VT100-terminal settings]({{ site.baseurl }}/assets/brainduck/vt100-terminal-settings.png)

{: .list}
| <span class="circle">1</span> | Set number of terminal columns. The "Set default" button sets columns to the default value.
| <span class="circle">2</span> | Set number of terminal rows. The "Set default" button sets rows to the default value.
| <span class="circle">3</span> | Set input file name, which will be used in "No GUI" mode instead of keyboard.
| <span class="circle">4</span> | Set output file name, which will be used in "No GUI" mode instead of display.
| <span class="circle">5</span> | Set input read delay (in milliseconds) when reading input file in "No GUI" mode. Can be used for slowing down emulation.
| <span class="circle">6</span> | Saves the settings, and closes the dialog.

## Automation / headless mode

Terminal behaves differently when emuStudio is run in automatic "No GUI" mode. At that moment, input is redirected
to be read from a file (instead of keyboard), and output is redirected to be written to a file. File names are
configurable in the settings. Input and output file names are not allowed to point to the same file.

## Configuration file

The following table shows all the possible settings of VT100-terminal plugin:

|---
|Name | Default value | Valid values | Description
|-|-|-|-
|`inputFileName`       | `vt100-terminal.in`  | Path to existing file | File for reading input (when redirected)
|`outputFileName`      | `vt100-terminal.out` | Path to existing file | File for writing output (when redirected)
|`inputReadDelayMillis`| 0                    | >= 0 | How long the terminal should wait until it reads next input character from the file (in milliseconds)
|`columns`             | 80                   | > 0  | Number of terminal columns 
|`rows`                | 24                   | > 0  | Number of terminal rows
|---

## Known limitations

- DCS (Device Control String) and OSC (Operating System Command) sequences are parsed but have no effect.
- Bell (`BEL`) does not produce audible sound.
- Truecolor and 256-color palette indices above 15 are not supported.
- Shift Out / Shift In do not switch character sets.


[vt100-image]: https://commons.wikimedia.org/w/index.php?curid=29457452
[dec-parser]: https://vt100.net/emu/dec_ansi_parser
