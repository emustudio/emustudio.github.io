---
layout: default
title: BrainDuck
description: "BrainDuck (Brainfuck) emulator in emuStudio — a Turing-complete abstract computer with minimalistic 8-instruction programming language."
nav_order: 7
has_children: true
permalink: /brainduck/
---

{% include analytics.html category="BrainDuck" %}

# BrainDuck

BrainDuck is an abstract computer for running [brainfuck][brainfuck]{:target="_blank"} programs in emuStudio.
[Urban Müller][miller]{:target="_blank"} designed brainfuck around eight instructions and a data pointer. BrainDuck
compiles those instructions into machine code and adds `;` as an explicit halt instruction.

BrainDuck architecture is just a name for virtual computer in emuStudio, and consists of these plugins:

- `brainc-brainduck`: Compiler for the eight brainfuck instructions and `;` (halt)
- `brainduck-cpu`: Brainfuck emulator acting like CPU with two registers
- `byte-mem`: Virtual operating memory which holds both compiled brainfuck program and data
- `vt100-terminal`: Virtual terminal for displaying the output and requesting for input.

BrainDuck is implemented as a [von Neumann][vonneumann]{:target="_blank"} computer: program and data share the same memory.

As implementing a brainfuck interpreter, one must deal with several [portability issues][portability]{:target="_blank"},
which include:

- Memory cell size (`byte`)
- Memory size (number of memory cells) (by default 65536 when using `byte-mem`)
- End-of-line code (0x0A is simulating both CRLF, 0x0D is just CR)
- End-of-file behavior (no EOF byte is appended in headless mode; input waits after the file's queued bytes are exhausted)

## BrainDuck for emuStudio

Open the bundled **BrainDuck** computer to use the configuration below. To create a custom variant, draw and save its
connections in the [schema editor]({{ site.baseurl }}/application/computer-schema):

![BrainDuck abstract schema]({{ site.baseurl}}/assets/brainduck/brainduck-schema.png){:style="max-width:426px; width:100%"}

Arrows are in a direction of dependency. So for example `brainc-brainduck` depends on `byte-mem`, because
compiled programs are directly loaded into memory.

Between `brainduck-cpu` and `vt100-terminal` exists bidirectional dependency, because input gained from a terminal
is passed to the CPU, and output is pushed from CPU to the terminal.

The `brainduck-cpu` plugin also depends on `byte-mem`, which stores both the program and its data.

[brainfuck]: http://en.wikipedia.org/wiki/Brainfuck
[miller]: http://esolangs.org/wiki/Urban_M%C3%BCller
[vonneumann]: http://en.wikipedia.org/wiki/Von_Neumann_architecture
[portability]: http://en.wikipedia.org/wiki/Brainfuck#Portability_issues
