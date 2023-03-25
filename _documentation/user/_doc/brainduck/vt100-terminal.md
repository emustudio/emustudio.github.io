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
by ASCII control sequences which became de facto a standard. Even today those control sequences are emulated by many modern
terminals (as we like to call "command line prompts"). 

![VT100-terminal]({{ site.baseurl }}/assets/brainduck/DEC_VT100_terminal.jpg)
(Autor: Jason Scott – Flickr: IMG_9976, CC BY 2.0, [available here][vt100-image]{:target="_blank"})

VT100-terminal plugin for emuStudio is currently very slim emulator recognizing only some control codes and does not emulate
all VT100 features. Supported features are:

- some VT100 control codes emulation
- resizable display at runtime
- keyboard input; binary codes can be entered with special dialog

## Graphical User Interface (GUI)

In the following screenshot, VT100-terminal window is shown:

![VT100-terminal window]({{ site.baseurl }}/assets/brainduck/vt100-terminal.png)

It's easy and simple. BrainDuck CPU as it interprets `.` (dot) instructions, it sends the output to this terminal, which
displays it on the screen.

Input cannot be entered anytime. In brainfuck, the input is requested through `,` instruction. Only when CPU
encounters `,` (comma) instruction, the user is asked to enter input. This situation is marked with a green icon in the
bottom-left corner:

![Input is enabled in VT100-terminal window]({{ site.baseurl }}/assets/brainduck/vt100-terminal-input.png)

Next to the icon, there is a blue "ASC" button. This button can be used for entering binary values as input. A special
little dialog will appear asking the user to enter space-separated numbers, representing ASCII codes of the input.

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

## Configuration file

The following table shows all the possible settings of VT100-terminal plugin:

|---
|Name | Default value | Valid values | Description
|-|-|-|-
|`inputFileName`   | `vt100-terminal.in`  | Path to existing file | File for reading input (when redirected)
|`outputFileName`  | `vt100-terminal.out` | Path to existing file | File for writing output (when redirected)
|`inputReadDelay`  | 0                    | >= 0 | How long the terminal should wait until it reads next input character from the file (in milliseconds)
|`columns`         | 80                   | > 0  | Number of terminal columns 
|`rows`            | 24                   | > 0  | Number of terminal rows
|---



[vt100-image]: https://commons.wikimedia.org/w/index.php?curid=29457452
