---
layout: default
title: Compiler "brainc-brainduck"
nav_order: 3
parent: BrainDuck
permalink: /brainduck/compiler
---

{% include analytics.html category="BrainDuck" %}

# Compiler "brainc-brainduck"

BrainDuck compiler is used as a part of BrainDuck computer, which acts as a translator of *brainfuck* "human-readable"
language into binary form, used by BrainDuck CPU. Those instructions and their binary codes have no relation with
brainfuck itself, therefore the computer is not called *brainfuck computer*, because it is **not** brainfuck. But it
does not mean you cannot write and run brainfuck programs in it :)

At first, each compiler, including BrainDuck compiler, provides a lexical analyzer for help with tokenizing the source
code, used in syntax highlighting. Secondly, the compiler *compiles* the source code into other (usually binary) form
which is then understood by CPU.

Compilation takes part by user request (clicking on 'compile' icon in the main window). After compilation is successful,
the compiler usually loads the translated program into operating memory and saves the translation into a file. So it is
with BrainDuck compiler. Files have `.hex` extension (format is called [Intel HEX][intelhex]{:target="_blank"}).

## Running from the command line

From the emuStudio installation directory, compile a source file without starting emulation:

```
java -cp "compiler/*:lib/*" net.emustudio.plugins.compiler.brainduck.Runner --output program.hex program.b
```

On Windows, use `;` instead of `:` between classpath entries. Options are `--output`/`-o`, `--help`/`-h`, and
`--version`/`-v`, before the input filename. Without `--output`, the result uses the input filename with a `.hex`
extension. To compile and run, use [BrainDuck automation]({{ site.baseurl }}/brainduck/automation).

## Language Syntax

The language of BrainDuck compiler is almost identical to the original brainfuck. However, brainfuck interpreter is not
specified well-enough, so there are open questions on how to treat with some special situations, which are described
below.

Generally, the language knows eight instructions. They are best described when they are compared with C language
equivalent. Brainfuck uses only a single data pointer called `P`, pointing to bounded memory. The boundary is specified
in the shared `byte-mem` plugin.

NOTE: BrainDuck architecture conforms to the true von-Neumann model, instead of classic Harvard-style interpreters. It
means that program memory and data memory are not separated. The data pointer is therefore not initialized to 0 as
programmers might expect and potentially there can be written brainfuck programs with self-modifications.

|---
|Brainfuck instruction | C language equivalent
|-|-
| `>`                    | `P++`
| `<`                    | `P--`
| `+`                    | `++*P`
| `-`                    | `--*P`
| `,`                    | `*P = getchar()`
| `.`                    | `putchar(*P);`
| `[`                    | `while (*P) {`
| `]`                    | `}`
|---

The compiler is supplied with many example programs written in brainfuck.

## Additional details

Specification of brainfuck language or interpreter implementation is not complete. There are left some details which
might be solved differently in different implementations. In this version of BrainDuck implementation in emuStudio, the
details are hardcoded, as described below.

### Comments

The compiler considers a comment being everything that is not a brainfuck instruction. From the first occurrence of the
unknown character, everything to the end of the line is treated as a comment. Exceptions are whitespaces, tabulators,
and newlines. This practically means that it is impossible to write brainfuck program with syntax errors.
Bracket pairing is a separate runtime concern: the compiler does not check that each `[` has a matching `]`.

In the following example, everything starting with `#` is treated as a comment, up to the end of the line.

    ++++[-] # Useless program in brainfuck. [-] clears the content of the memory cell.

### Cell size

A memory cell has 8-bits (cells are bytes).

### Memory size

Memory size is defined in `byte-mem` plugin. In this version of emuStudio, it is 65536 bytes.

### End-of-line code

EOL is defined in `vt100-terminal` plugin. In the current version of emuStudio, it is a Newline character with ASCII
code 10.

### End-of-file behavior

The file keyboard queues the bytes in the input file and does not append an EOF byte. Once the queue is exhausted,
a BrainDuck input instruction waits for another byte. A missing file behaves the same way. For unattended programs
that may request too much input, use automation with `--waitmax`.

[intelhex]: http://en.wikipedia.org/wiki/Intel_HEX
