---
layout: default
title: RAM
description: "Random Access Machine (RAM) emulator in emuStudio — study algorithmic complexity with this Harvard architecture abstract machine simulator."
nav_order: 8
has_children: true
permalink: /ram/
---

{% include analytics.html category="RAM" %}

# Random Access Machine (RAM)

A Random Access Machine (RAM) is an abstract machine used to study the algorithmic complexity of programs on
register-based computers. It is equivalent to a Turing machine. Like
[Harvard computer architecture][harvard]{:target="_blank"}, it separates program storage from data storage. Instructions
cannot modify the program.

RAM machine consists of several parts: input tape (read-only), output tape (write-only), program memory,
data memory or registers (read/write) and a control unit ("engine"), as can be seen in the following image:

![RAM machine]({{ site.baseurl }}/assets/ram/ram-machine.svg){: width="85%"}

Reading an input symbol advances the input head to the next unread symbol. The head cannot return to a previously read
symbol.

Writing an output symbol advances the output head to the next empty position. The head cannot return to a previously
written symbol.

Data memory - registers tape - represents the random-access memory. It consists of so-called registers, abstract cells
with arbitrary size. These registers are ordered - each one has assigned the index - its position within the tape called
the _address_. The tape head can move arbitrarily up and down - but it has its minimum position. It is the first
register, _R<sub>0</sub>_, called the accumulator. Below there is an unlimited number of higher-positioned registers.

The role of the accumulator is kind of special - it often acts as an implicit operand for many instructions, or implicit
place for storing the result of such instructions.

Program memory is a bounded ordered sequence of registers; each of them is identified by its index within the tape,
called address. Data memory is also ordered sequence of registers, but like the I/O tapes - bounded just from one side.

Since RAM machine is somewhat abstract, it frees the user from thinking about some issues and just assumes that:

- The size of the problem is always small enough to fit in the RAM memory,
- Data used within the computation are always small enough to fit in one register.

The RAM virtual machine in emuStudio consists of the following plugins:

- `ramc-ram`: Compiler of the RAM language, very simple "assembler"-like language
- `ram-cpu`: RAM simulator engine
- `ram-mem`: Program memory
- `abstract-tape`: Device which represents the "tape" used in RAM, other than program memory. The abstract schema
  must define three instances of this device, representing register, input, and output tapes.

Unlike the theoretical model, numeric values in this implementation are limited to signed 32-bit integers. See the
compiler's [numeric limits]({{ site.baseurl }}/ram/ramc-ram#numeric-limits) before using large values.

## RAM in emuStudio

Open the bundled `RandomAccessMachineRAM.toml` configuration to use RAM. Its abstract schema defines the plugins and
their connections. You can inspect or change it in the [schema editor]({{ site.baseurl }}/application/computer-schema):

![RAM abstract schema]({{ site.baseurl }}/assets/ram/ram-schema.png){:style="max-width:561px; width:100%"}

The "->" arrows are in direction of dependency. So for example `ramc-ram` depends on `ram-mem`, because compiled
programs are directly loaded into memory.

The RAM CPU assigns each tape its role at startup.


[harvard]: https://en.wikipedia.org/wiki/Harvard_architecture
[vonneumann]: https://en.wikipedia.org/wiki/Von_Neumann_architecture
