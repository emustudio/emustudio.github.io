---
layout: default
title: Compiler "ramc-ram"
nav_order: 2
parent: RAM
permalink: /ram/ramc-ram
---

{% include analytics.html category="RAM" %}

# Compiler "ramc-ram"

RAM has a very simple assembler-like language, consisting of direct and indirect reading/writing from/to registers or
input/output tape. Also, there are three control-flow instructions. 

Source code files end with `.ram` extension; compiler output uses extension `.bram`.

## Language syntax

A program written for RAM consists of two sections, which can be intermixed and repeated in any order, but
the preferred order is as follows:

{:.code-example}
```
INPUT section
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

### Instructions section

There exist many variations of RAM instructions, unfortunately, the syntax is not very unified. The reason might be
that RAM is not a real machine.

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
indirect operand (`*i`), where the address of operand specified is stored in register _R<sub>i</sub>_.

The following table describes all possible instructions, usable in the RAM simulator:

|---
| Instruction | Constant (`=i`)        | Direct (`i`)              | Indirect (`*i`)
|-|-|-|-
| `READ`      | | _R<sub>i</sub>_ &larr; next input |
| `WRITE`     | output &larr; _i_          | output &larr; _R<sub>i</sub>_          | output &larr; _M[R<sub>i</sub>]_
| `LOAD`      | _R<sub>0</sub>_ &larr; _i_          | _R<sub>0</sub>_ &larr; _R<sub>i</sub>_          | _R<sub>0</sub>_ &larr; _M[R<sub>i</sub>]_
| `STORE`     | | _R<sub>i</sub>_ &larr; _R<sub>0</sub>_          | _M[R<sub>i</sub>]_ &larr; _R<sub>0</sub>_
|---
| `ADD`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _M[R<sub>i</sub>]_
| `SUB`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _M[R<sub>i</sub>]_
| `MUL`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _M[R<sub>i</sub>]_
| `DIV`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _M[R<sub>i</sub>]_
|---
| `JMP`       | | _IP_ &larr; _i_               |
| `JZ`        | | *if* _R<sub>0</sub>_ == 0 *then* _IP_ &larr; _i_ |
| `JGTZ`      | | *if* _R<sub>0</sub>_ > 0 *then* _IP_ &larr; _i_  |
|---
| `HALT`      | | halts the simulation |
|---

The table describes also the behavior of each instruction. The compiler does not care about the behavior, but about the
syntax of the instructions, which is also incorporated in the table.

### Code example

For example, this is a valid program:

{:.code-example}
```
; Copy R(X) to R(Y)
;
; input tape:
;   destination register: X
;   source register: Y
;
; output:
;   R(X) = R(Y)
;   R(Y) = R(Y)


<input> 3 4 'hello' 'world'

; load X,Y
read 1
read 2

; load r.X, r.Y
read *1
read *2

; copy
load *2
store *1

halt
```
