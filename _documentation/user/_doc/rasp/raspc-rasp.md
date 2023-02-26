---
layout: default
title: Compiler "raspc-rasp"
nav_order: 1
parent: RASP
permalink: /rasp/raspc-rasp
---

{% include analytics.html category="RASP" %}

# Compiler "raspc-rasp"

RASP compiler has a very simple assembler-like language, consisting of direct reading/writing from/to registers or
input/output tape. Also, there are three control-flow instructions. Syntax is very similar to RAM machine, just RASP 
doesn't support indirect addressing.

Source code files end with `.rasp` extension; compiler output uses extension `.brasp`.

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

The `INPUT` section contains definitions the content of input tape - one or more lines in the form:

{:.code-example}
```
<input> ITEMS
```

where `ITEMS` is a space-separated list of inputs. Each input is one word - it might be any number or string. Strings
must be in quotes - single (`'`) or double (`"`).

For example, the input section might be:

{:.code-example}
```
    <input> 1 2 3 'hello' 'world!'
```

In this case, there are five inputs: numbers 1,2,3, then word "hello" and the last one is "world!". Note floating-point
numeric values are not supported.

### ORG section

The `ORG` pseudo-instruction sets the address of the following instruction to a specified value.
For example:

{:.code-example}
```
org 5   ; sets next address to 5
read 0
```

By default, if ORG is not specified in the beginning of the program, it is added implicitly as `ORG 20`. It is because
registers in RASP are stored in memory (R0 at address 0, etc.), so this implicit ORG pre-allocates 20 registers.

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

An instructions consists of the operation code, optionally followed by an operand separated with at least one
space (` `), but not with a newline.

Operation code is expressed as an abbreviation of corresponding operation (e.g. `SUB` for SUBtraction). An operand can
be one of three types: constant (`=i`), direct operand (`i`), where `i` specifies the register index on tape and
label, pointing to the address in memory.

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
