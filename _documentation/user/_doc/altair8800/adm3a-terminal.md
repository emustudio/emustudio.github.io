---
layout: default
title: Device adm3a-terminal
nav_order: 8
parent: MITS Altair8800
permalink: /altair8800/adm3a-terminal
---

{% include analytics.html category="Altair8800" %}

# Terminal LSI ADM-3A

Emulation of famous terminal from Lear Siegler, Inc. - ADM-3A. It had a nickname 'Dumb Terminal'. In the time (1974),
due to its cheapness and speed capabilities required in that time, it became de facto standard in the industry.
Often it was used in connection with MITS Altair 8800 computer, so the decision of which terminal to emulate was clear.

Maintenance manual can be downloaded at [this link][manual1]{:target="_blank"}, operator's manual
[here][manual2]{:target="_blank"}.

![LSI ADM-3A terminal]({{ site.baseurl }}/assets/altair8800/adm3a.jpg)
(Image borrowed from [Wikipedia][gui]{:target="_blank"})

## Display

Terminal could display 128 ASCII characters (upper-case and lower-case letters, punctuation and numbers).
Original ADM-3 could display only 64 (only capital-letters and some other). For saving very expensive RAM the
terminal offered size 12 rows x 80 columns, with optional extension to 24 rows x 80 columns. The size used in the
emulator is hardcoded to 80 columns x 24 rows.

Besides, the emulator uses "replica" of the original ADM-3A font with anti-aliasing support, double-buffering and
display frequency 60Hz.

GUI can be seen here:

![GUI of adm3a-terminal]({{ site.baseurl }}/assets/altair8800/adm3a-gui.png)

- *1*: Clear screen
- *2*: Roll one line down

## Keyboard

Terminal could generate 128 ASCII characters (upper-case, lower-case, punctuation and numbers). Besides, it could
generate special control characters which affected current position of the cursor and were not sent to CPU.

Emulated device allows to generate almost everything what you can get from your host keyboard. It is only the font
which characters it can display. Original font contains only 255 characters, modern font contains all unicode
characters.

The terminal can capture control codes (holding `CTRL` plus some key), and special control
codes (`ESC + '=' + [X] + [Y]`).
The special code (`ESC=XY`) sets the new cursor position, where `[X]` is a key translated to X position and `[Y]` a key
translated into Y position of a cursor. The following subsection lists all possible control and special control key
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
|`CTRL+P`  | `OLE`   |
|`CTRL+Q`  | `DCI`   |
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
|`CTRL+x`  | `FS`    |
|`CTRL+]`  | `GS`    |
|`CTRL+^`  | `RS`    | Home cursor
|---

### Absolute cursor position from the keyboard

Terminal allows to set the absolute cursor position, when in "Cursor control Mode" or using "load cursor" operation.
Emulated terminal does not support the "Cursor control Mode", but "load cursor" is supported.

The "load cursor" operation can be activated by pressing `ESC` key followed by `=` key. Then the terminal expects
another two key presses, one representing X, and the other one the Y position of the cursor.

X and Y coordinates are translated from the key presses. The following table shows the key-to-coordinate translation
table.

|---
| Key | Number | Key | Number
|-|-|-|-
|`' '` (space) | 0 |`H`   | 40   
|`!`   | 1 |`I`   | 41   
|`"`   | 2 |`J`   | 42   
|`#`   | 3 |`K`   | 43   
|`$`   | 4 |`L`   | 44   
|`%`   | 5 |`M`   | 45   
|`&`   | 6 |`N`   | 46   
|`'`   | 7 |`O`   | 47   
|`(`   | 8 |`P`   | 48   
|`)`   | 9 |`Q`   | 49   
|`*`   | 10 |`R`   | 50   
|`+`   | 11 |`S`   | 51   
|`,`   | 12 |`T`   | 52   
|`-`   | 13 |`U`   | 53   
|`.`   | 14 |`V`   | 54   
|`/`   | 15 |`W`   | 55   
|`0`   | 16 |`X`   | 56   
|`1`   | 17 |`Y`   | 57   
|`2`   | 18 |`Z`   | 58   
|`3`   | 19 |`[`   | 59   
|`4`   | 20 |`\`   | 60   
|`5`   | 21 |`]`   | 61   
|`6`   | 22 |`^`   | 62   
|`7`   | 23 |`_`   | 63   
|`8`   | 24 | `` ` `` (backtick)  | 64   
|`9`   | 25 |`a`   | 65   
|`:`   | 26 |`b`   | 66   
|`;`   | 27 |`c`   | 67   
|`<`   | 28 |`d`   | 68   
|`=`   | 29 |`e`   | 69   
|`>`   | 30 |`f`   | 70   
|`?`   | 31 |`g`   | 71   
|`@`   | 32 |`h`   | 72   
|`A`   | 33 |`i`   | 73   
|`B`   | 34 |`j`   | 74   
|`C`   | 35 |`k`   | 75   
|`D`   | 36 |`l`   | 76   
|`E`   | 37 |`m`   | 77   
|`F`   | 38 |`n`   | 78   
|`G`   | 39 |`o`   | 79   
|---

## Terminal Settings

It is possible to configure the terminal either from GUI or manually modifying configuration settings. Modification of
settings requires restarting emuStudio.

The "settings" window is shown in the following image:

![Settings window of ADM-3A terminal]({{ site.baseurl }}/assets/altair8800/adm3a-settings.png)

- *1*: File name used for reading input (when redirected - in "no GUI" mode)
- *2*: File name used for writing output (when redirected - in "no GUI" mode)
- *3*: In automatic mode, how long the terminal should wait until it reads next input character from the file
  (in milliseconds)
- *4*: Set terminal font. Original font has reduced character range to 256 characters; modern one supports full unicode.
- *5*: Whether every keystroke will also cause to display it. Programs don't always "echo" the characters back
  to the screen.
- *6*: Whether terminal GUI should be always-on-top of other windows
- *7*: Save settings and dispose the dialog

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
|`outputFileName`  | `adm3A-terminal.out` | Path to existing file | File for writing output (when redirected)
|`inputReadDelay`  | 0 | > 0 | How long the terminal should wait until it reads next input character from the file (in milliseconds)
|`antiAliasing`    | false | true / false | Whether the display should use anti-aliasing.
|`halfDuplex`      | false | true / false | Whether every keystroke will also cause to display it.
|---


[manual1]: http://www.mirrorservice.org/sites/www.bitsavers.org/pdf/learSiegler/ADM3A_Maint.pdf
[manual2]: http://maben.homeip.net/static/s100/learSiegler/terminal/Lear%20Siegler%20ADM3A%20operators%20manual.pdf
[gui]: https://en.wikipedia.org/wiki/ADM-3A#/media/File:Adm3aimage.jpg
