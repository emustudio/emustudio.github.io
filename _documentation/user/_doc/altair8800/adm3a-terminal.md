---
layout: default
title: Device "adm3a-terminal"
nav_order: 14
parent: MITS Altair8800
permalink: /altair8800/adm3a-terminal
---

{% include analytics.html category="Altair8800" %}

# Terminal LSI ADM-3A

This device emulates the Lear Siegler ADM-3A, introduced in 1976 and marketed as the "Dumb Terminal". Its low price
made it popular with universities and early microcomputer users, including owners of the MITS Altair 8800.
It provided a keyboard and text display connected to a host computer over a serial link; the host ran the programs.

The ADM-3A also has a lasting connection with Unix: Bill Joy used it at the University of California, Berkeley,
when he developed the vi text editor around 1976. In his
[1984 interview](https://archive.org/details/interview-with-bill-joy){:target="_blank"}, Joy recalled that obtaining
ADM-3A terminals prompted work on screen editing.

Its keyboard explains one of vi's most recognizable features. With no separate arrow keys, the ADM-3A had arrows
printed on **H (left), J (down), K (up), and L (right)**. The terminal's corresponding control codes were
`Ctrl+H`, `Ctrl+J`, `Ctrl+K`, and `Ctrl+L`; vi adopted the plain letters `h`, `j`, `k`, and `l` for movement in
command mode, a convention retained by Vim. The `Esc` key sat where `Tab` sits on modern keyboards, within easy
reach for returning to command mode. These details of a 1970s keyboard still shape how people edit code today.

![LSI ADM-3A terminal]({{ site.baseurl }}/assets/altair8800/adm3a.jpg)
(Image borrowed from [Wikipedia][gui]{:target="_blank"})

## Original manuals

- [Lear Siegler ADM-3A User's Reference Manual (DP2880486F, April 1986, PDF)][manual2]{:target="_blank"} — keyboard,
  setup, and control codes.
- [Lear Siegler ADM-3A Maintenance Manual (PDF)][manual1]{:target="_blank"} — operation, circuitry, and schematics.

## Display

Terminal could display 128 ASCII characters (upper-case and lower-case letters, punctuation and numbers).
Original ADM-3 could display only 64 (only capital-letters and some other). For saving very expensive RAM the
terminal offered size 12 rows x 80 columns, with optional extension to 24 rows x 80 columns. The size used in the
emulator is hardcoded to 80 columns x 24 rows.

Besides, the emulator uses "replica" of the original ADM-3A font with anti-aliasing support, double-buffering and
display frequency 60Hz.

GUI can be seen here:

{% include annotated-screenshot.html image="/assets/altair8800/adm3a-gui.png" alt="ADM-3A terminal with the original font, message box, and numbered Clear and Roll Up controls" width=1024 points="1:9.28:96.53|2:34.96:96.53" %}

{: .list}
| <span class="circle">1</span> | **CLEAR**. Clear screen
| <span class="circle">2</span> | **ROLL UP**. Scroll the contents up one line


## Keyboard

Terminal could generate 128 ASCII characters (upper-case, lower-case, punctuation and numbers). Besides, it could
generate special control characters which affected current position of the cursor and were not sent to CPU.

The emulator interprets output bytes 128–255 as IBM code page 437 (CP437). The original font includes all of these
extended characters, including single- and double-line box borders, shading, and blocks. This is an emuStudio
extension; the original ADM-3A hardware used a 7-bit character set.

The terminal can capture control codes (holding `CTRL` plus some key), and special control
codes (`ESC + '=' + [Y] + [X]`).
The special code (`ESC=YX`) sets the cursor position: send the row first, then the column, each encoded as its
zero-based coordinate plus 32. The following subsection lists all possible control and special control key
combinations.

### Control codes

The following table shows control codes (`CTRL` plus some key combinations). The table can be found in original manuals.
The emulator is following it.

|---
| Code | ASCII mnemonic | Function in ADM-3A
|-|-|-
|`CTRL+@`  | `NUL`   |
|`CTRL+A`  | `SOH`   |
|`CTRL+B`  | `STX`   |
|`CTRL+C`  | `ETX`   |
|`CTRL+D`  | `EOT`   |
|`CTRL+E`  | `ENQ`   | Initiates ID message with automatic "Answer Back" option.
|`CTRL+F`  | `ACK`   |
|`CTRL+G`  | `BEL`   | Sounds audible beep in ADM-3A (not in emulator yet :( )
|`CTRL+H`  | `BS`    | Backspace
|`CTRL+I`  | `HT`    |
|`CTRL+J`  | `LF`    | Line feed
|`CTRL+K`  | `VT`    | Upline
|`CTRL+L`  | `FF`    | Forward space
|`CTRL+M`  | `CR`    | Return
|`CTRL+N`  | `SO`    | Unlock keyboard
|`CTRL+O`  | `SI`    | Lock keyboard
|`CTRL+P`  | `DLE`   |
|`CTRL+Q`  | `DC1`   |
|`CTRL+R`  | `DC2`   |
|`CTRL+S`  | `DC3`   |
|`CTRL+T`  | `DC4`   |
|`CTRL+U`  | `NAK`   |
|`CTRL+V`  | `SYN`   |
|`CTRL+W`  | `ETB`   |
|`CTRL+X`  | `CAN`   |
|`CTRL+Y`  | `EM`    |
|`CTRL+Z`  | `SUB`   | Clear screen
|`CTRL+[`  | `ESC`   | Initiate load cursor
|`CTRL+\`  | `FS`    |
|`CTRL+]`  | `GS`    |
|`CTRL+^`  | `RS`    | Home cursor
|---

### Absolute cursor position from the keyboard

Terminal allows to set the absolute cursor position, when in "Cursor control Mode" or using "load cursor" operation.
Emulated terminal does not support the "Cursor control Mode", but "load cursor" is supported.

The "load cursor" operation can be activated by pressing `ESC` key followed by `=` key. Then the terminal expects
another two key presses, one representing the row (Y), and the other the column (X) of the cursor.

X and Y coordinates are translated from the key presses. The following table shows the key-to-coordinate translation
table.

|---
| Key          | Number | Key  | Number | Key  | Number
|-|-|-|-|-|-
|`' '` (space) | 0      |`;`   | 27     |`V`   | 54
|`!`           | 1      |`<`   | 28     |`W`   | 55
|`"`           | 2      |`=`   | 29     |`X`   | 56
|`#`           | 3      |`>`   | 30     |`Y`   | 57
|`$`           | 4      |`?`   | 31     |`Z`   | 58
|`%`           | 5      |`@`   | 32     |`[`   | 59
|`&`           | 6      |`A`   | 33     |`\`   | 60
|`'`           | 7      |`B`   | 34     |`]`   | 61
|`(`           | 8      |`C`   | 35     |`^`   | 62
|`)`           | 9      |`D`   | 36     |`_`   | 63
|`*`           | 10     |`E`   | 37     | `` ` `` (backtick)  | 64
|`+`           | 11     |`F`   | 38     |`a`   | 65
|`,`           | 12     |`G`   | 39     |`b`   | 66
|`-`           | 13     |`H`   | 40     |`c`   | 67
|`.`           | 14     |`I`   | 41     |`d`   | 68                              
|`/`           | 15     |`J`   | 42     |`e`   | 69
|`0`           | 16     |`K`   | 43     |`f`   | 70
|`1`           | 17     |`L`   | 44     |`g`   | 71
|`2`           | 18     |`M`   | 45     |`h`   | 72
|`3`           | 19     |`N`   | 46     |`i`   | 73
|`4`           | 20     |`O`   | 47     |`j`   | 74
|`5`           | 21     |`P`   | 48     |`k`   | 75
|`6`           | 22     |`Q`   | 49     |`l`   | 76
|`7`           | 23     |`R`   | 50     |`m`   | 77
|`8`           | 24     |`S`   | 51     |`n`   | 78
|`9`           | 25     |`T`   | 52     |`o`   | 79 
|`:`           | 26     |`U`   | 53     |      |
|---

## Drawing message boxes

Use [code page 437][cp437]{:target="_blank"} character codes to draw boxes, for example:

```
message:
db 201, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 187, 10, 13
db 186, "Hello world!", 186, 10, 13
db 200, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 188
db 0
```

The example displays:

![Hello in a message box]({{ site.baseurl }}/assets/altair8800/hello.png)

Box borders join across character cells in the original font. When using the 88-SIO serial interface, keep
`clearOutputBit8 = false` so it passes extended character codes to the terminal.

## Terminal Settings

Select `adm3A-terminal` in the device list and click **Show settings...** to open the dialog.
Click **Save** to persist the settings; press **Esc** to discard edits. After editing the configuration file directly,
close and reopen the computer.

The "settings" window is shown in the following image:

{% include annotated-screenshot.html image="/assets/altair8800/adm3a-settings.png" alt="ADM-3A terminal settings with numbered input and output files, input delay, font, half duplex, always on top, and Save controls" width=444 points="1:69.82:15.57|2:69.82:23.35|3:52.93:31.44|4:97.07:61.38|5:37.84:69.16|6:43.92:76.65|7:72.97:92.22" %}

{: .list}
| <span class="circle">1</span> | File name used for reading input (when redirected - in "no GUI" mode)
| <span class="circle">2</span> | File name used for writing output (when redirected - in "no GUI" mode)
| <span class="circle">3</span> | In automatic mode, how long the terminal should wait until it reads next input character from the file (in milliseconds)
| <span class="circle">4</span> | Choose the original or modern font. Both display the same byte-oriented character set: ASCII and the CP437 extension described above. Changing the font does not enable Unicode input.
| <span class="circle">5</span> | Whether every keystroke will also cause to display it. Programs don't always "echo" the characters back to the screen.
| <span class="circle">6</span> | Whether terminal GUI should be always-on-top of other windows
| <span class="circle">7</span> | Save settings and dispose the dialog

Terminal behaves differently when emuStudio is run in automatic with "no GUI" mode. At that moment, input is redirected
to be read from a file (instead of keyboard), and also output is redirected to be written to a file. File names are
configurable in the computer config file (and they are not allowed to point to the same file).
Using redirection in GUI mode (whether in automatic mode or not) is not possible. 

## Configuration file

The following table shows all the possible settings of ADM-3A plugin:

|---
|Name | Default value | Valid values | Description
|-|-|-|-
|`inputFileName`   | `adm3A-terminal.in`  | Path to existing file | File for reading input (when redirected)
|`outputFileName`  | `adm3A-terminal.out` | Path to writable file | File for writing output (when redirected)
|`inputReadDelayMillis`  | 0                    | >= 0 | How long the terminal should wait until it reads next input character from the file (in milliseconds)
|`halfDuplex`      | false                | true / false | Whether every keystroke will also cause to display it
|`alwaysOnTop`     | false                | true / false | Whether terminal GUI should be always-on-top of other windows
|`deviceIndex`     | 0                    | >= 0 | Index of connected device, if this terminal is connected to multiple devices in the schema (nonstandard, advanced use)
|`font`            | `original`           | `original`, `modern` | Terminal font
|---


[manual1]: https://bitsavers.org/pdf/learSiegler/ADM_3/ADM3A_Maint.pdf
[manual2]: https://bitsavers.org/pdf/learSiegler/ADM_3/DP2880486F_ADM3A_UM_Apr86.pdf
[gui]: https://en.wikipedia.org/wiki/ADM-3A#/media/File:Adm3aimage.jpg
[cp437]: https://en.wikipedia.org/wiki/Code_page_437
