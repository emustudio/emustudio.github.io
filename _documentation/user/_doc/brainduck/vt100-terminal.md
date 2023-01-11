---
layout: default
title: Terminal vt100-terminal
nav_order: 5
parent: BrainDuck
permalink: /brainduck/terminal
---

{% include analytics.html category="BrainDuck" %}

# Terminal `vt100-terminal`

VT100 terminal is used as a part of BrainDuck computer, which acts as an interactive console, or generally
interactive input/output provider. It was written with the support of GUI, but can be used also in emulation automation,
in which case it loads input from the file and output to another file.

Supported features are:

- monospace font, unlimited width and height, white background
- blinking cursor simulation
- keyboard input; binary codes can be entered with special dialog
- terminal interprets some special characters like 0x8 (backspace), 0x9 (tab), 0xA (LF), and 0x10 (CR)

## Graphical User Interface (GUI)

In the following image, BrainDuck terminal window is shown:

![BrainDuck terminal window]({{ site.baseurl }}/assets/brainduck/brainduck-terminal.png)

It's easy and simple. BrainDuck CPU as it interprets `.` (dot) instructions, it sends the output to this terminal and it
is displayed on the screen.

Input cannot be entered anytime. In brainfuck, the input is requested through `,` instruction. Only when CPU
encounters `,` (comma) instruction, the user is asked to enter input. This situation is marked with a green icon in the
bottom-left corner:

![Input is enabled in BrainDuck terminal window]({{ site.baseurl }}/assets/brainduck/brainduck-terminal-input.png)

Next to the icon, there is a blue "ASC" button. This button can be used for entering binary values as input. A special
little dialog will appear asking the user to enter space-separated numbers, representing ASCII codes of the input.

NOTE: The terminal does not display characters with ASCII codes less than 32. Only some special characters are
interpreted: 0x8 (backspace), 0x9 (tab), 0xA (LF), and 0x10 (CR)
