---
layout: default
title: Compiler "raspc-rasp"
nav_order: 2
parent: RASP
permalink: /rasp/raspc-rasp
---

{% include analytics.html category="RASP" %}

# Compiler "raspc-rasp"

The RASP language provides direct register access, input/output operations, and three jump instructions. Its syntax
resembles RAM's, but it does not support indirect addressing.

Source code files end with `.rasp` extension; compiler output uses extension `.brasp`.

## Running from the command line

Run the compiler from the emuStudio installation directory:

```
java -cp "compiler/*:memory/*:lib/*" net.emustudio.plugins.compiler.rasp.Runner --output program.brasp program.rasp
```

On Windows, replace the classpath separators `:` with `;`. Options are `--output`/`-o`, `--help`/`-h`, and `--version`/`-v`. Put options before the input filename.
Without `--output`, the compiler uses the input filename with the `.brasp` extension. This compiles a file;
it does not start a virtual computer. Use [automation]({{ site.baseurl }}/application/automation) to compile and run.

## Numeric limits

This implementation uses signed 32-bit integers (`-2147483648` through `2147483647`) for numeric values. Arithmetic
can overflow this range; it does not provide the unbounded integers of the theoretical machine. Integer division
truncates toward zero. Avoid dividing by zero, which stops execution with an error. Register indices must be
non-negative.

## Language syntax

A program written for RASP is composed of three sections, which can be intermixed and repeated in any order, but
the preferred order is as follows:

{:.code-example}
```
INPUT section
ORG section
INSTRUCTIONS section
```

### Input section

The `INPUT` section defines the input tape with one or more lines of the form:

{:.code-example}
```
<input> ITEMS
```

where `ITEMS` is a space-separated list of signed integers. Decimal, hexadecimal (`0x` prefix or `h` suffix),
octal (`o`/`q` suffix), and binary (`b` suffix) forms are supported. Unlike RAM, RASP does not accept string inputs.

```
<input> 1 2 3 -4 0x10
```

These are five input values. Floating-point values are not supported.

### ORG section

The `ORG` pseudo-instruction sets the address of the following instruction to a specified value.
For example:

{:.code-example}
```
org 5   ; sets next address to 5
read 0
```

Without an initial `ORG`, instructions start at address 20. This leaves addresses 0–19 available for registers, including
the accumulator at address 0. Registers and program share memory; writing a register that overlaps the program changes
its instructions or operands.

### Instructions section

There exist many variations of RASP instructions, unfortunately, the syntax is not very unified. The reason might be
that RASP is not a real machine.

Each instruction must be on a separate line, in the following form:

{:.code-example}
```
    [LABEL:] INSTRUCTION [; optional comment]
```

Each instruction position can be optionally labeled with some identifier (`LABEL` field), followed by a colon (`:`)
character. The labels can be then referred to in other instructions.

Comments can be one-line or multi-line. One-line comments begin with a semicolon (`;`), hash sign (`#`),
double-dash (`--`) or double-slash (`//`). A one-line comment continues to the end of the line. Multi-line comments
start with `/*` characters and end with `*/` characters. In-between there can be multiple lines of text, all treated
as comment.

An instruction consists of an operation code and, where required, an operand. Separate them with spaces or tabs on the
same line.

The operation code abbreviates the operation (for example, `SUB` for subtraction). An operand can be a constant (`=i`),
a direct register address (`i`), or a label naming a memory address. Jump instructions require labels.

The following table describes all possible instructions, usable in the RASP simulator:

|---
| Instruction | Constant (`=i`)        | Direct (`i`)              | Label
|-|-|-|-
| `READ`      |                        | _R<sub>i</sub>_ &larr; next input |
| `WRITE`     | output &larr; _i_      | output &larr; _R<sub>i</sub>_          | 
| `LOAD`      | _R<sub>0</sub>_ &larr; _i_    | _R<sub>0</sub>_ &larr; _R<sub>i</sub>_          | 
| `STORE`     | | _R<sub>i</sub>_ &larr; _R<sub>0</sub>_          | 
|---
| `ADD`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _R<sub>i</sub>_ | 
| `SUB`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _R<sub>i</sub>_ | 
| `MUL`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _R<sub>i</sub>_ | 
| `DIV`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _R<sub>i</sub>_ | 
|---
| `JMP`       | | | _IP_ &larr; _label_
| `JZ`        | | | *if* _R<sub>0</sub>_ == 0 *then* _IP_ &larr; _label_ |
| `JGTZ`      | | | *if* _R<sub>0</sub>_ > 0 *then* _IP_ &larr; _label_  |
|---
| `HALT`      | | halts the simulation |
|---


### Code example

For example, this is a valid program:

{:.code-example}
```
; N! (factorial)
; Program reads an integer number from the input tape, calculates its factorial and prints the result
; onto the output tape.

<input> 5

org 5 ; reserve 5 registers

;saves the constant 1 into R2 and R3 registers
load =1
store 2
store 3

;reads a number from the input tape
read 1

;if the number is greater than 0, jump to "ok", otherwise, jump to "finish"
load 1
jgtz ok
jmp finish

;the loop to calculate the factorial value
ok:
load 3
sub 1
jz finish
load 3
add =1
store 3
mul 2
store 2
jmp ok

;print the result
finish:
write 2

halt
```
