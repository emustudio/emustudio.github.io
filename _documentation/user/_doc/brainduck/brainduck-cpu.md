---
layout: default
title: CPU brainduck-cpu
nav_order: 3
parent: BrainDuck
permalink: /brainduck/cpu
---

{% include analytics.html category="BrainDuck" %}

# CPU "brainduck-cpu"

BrainDuck CPU is used as a part of BrainDuck computer, which acts as the interpreter of BrainDuck instructions. Those
instructions correspond with brainfuck language.

The program which is going to be executed is read from the operating memory, so the CPU must be connected with
memory (`byte-mem`) to work properly.

Also, optionally (but commonly) it should be connected with I/O device (`vt100-terminal`), so input/output can be
received/send from/to the device. Only one device can be used.

The CPU provides a basic user interface in the form of the status panel, which is visible in the emulator panel in the
main window.

Breakpoints are supported, so as "jump" to a specific location (which might be dangerous to use).

## Status panel

In the following image, you can see the status panel of `brainduck-cpu`.

![BrainDuck CPU status panel]({{ site.baseurl }}/assets/brainduck/status-panel.png)

It is split into three parts. Within the 'Internal status' part, there is shown content of registers `IP` and `P`.
Register `IP` does not have a counterpart in brainfuck. IP stands for "instruction pointer". The content is pointing at
the next instruction being executed. Register `P` is commonly known from brainfuck. It is a pointer to data.

There is the measured execution time, which is reset when the user starts the program and stopped when either the
program stops or the user stops it.

Loop level shows the depth level of brainfuck loop the program is in. For example, if instruction pointer points into
the middle of the program `[[-]]`, to the `-` instruction, the loop level is 2.

## Running brainfuck programs

It is very important to reset the CPU after each source code compilation. The reason is that after compilation
register `P` is not changed. It therefore might point somewhere into compiled code in the memory. If the program was
executed, changes in data would corrupt the program itself.

Resetting CPU would move the `P` register after the first occurrence of a memory cell with value `0`. The value `0` in
BrainDuck CPU represents halt instruction, which corresponds to EOF in brainfuck.
