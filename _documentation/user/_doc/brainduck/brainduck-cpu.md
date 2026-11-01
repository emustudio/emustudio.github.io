---
layout: default
title: CPU "brainduck-cpu"
nav_order: 4
parent: BrainDuck
permalink: /brainduck/cpu
---

{% include analytics.html category="BrainDuck" %}

# CPU "brainduck-cpu"

The BrainDuck CPU interprets the compiled instructions of the BrainDuck computer, which correspond to the brainfuck
language.

The program which is going to be executed is read from the operating memory, so the CPU must be connected with
memory (`byte-mem`) to work properly.

Connect one I/O device, normally `vt100-terminal`, to run programs that read input or write output.

The CPU status panel appears on the **Debugger** tab in the main window.

The CPU supports breakpoints and jumping to a specific address. Jumping into the middle of a program can leave its
data pointer and loop state inconsistent.

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

**Save & Compile source file** resets the CPU automatically after compilation. If you load a compiled memory image
directly or invoke a compiler outside this workflow, reset the CPU before running it. Otherwise, register `P` can
still point into the new program, and data writes can overwrite its instructions.

Reset scans from the program's start address for the first memory cell containing `0`, then places `P` immediately
after it. In BrainDuck machine code, `0` is the halt instruction that terminates a compiled program.
