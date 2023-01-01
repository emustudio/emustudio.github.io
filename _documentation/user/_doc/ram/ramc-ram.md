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

## Language syntax

The program written for this compiler consists of two sections:

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

where `ITEMS` is a space-separated list of inputs. Each input is one word - it might be any number or string. By
default, every cell in the input tape is a string, and it is not interpreted as some data type. It is only in a time
when it is used - the instruction which works with the cell defines of which "type" it should be.

For example, the input section might be:

{:.code-example}
```
    <input> 1 2 3 hello world!
```

In this case, there are five inputs: numbers 1,2,3, then word "hello" and the last one is "world!".

### Instructions section

There exist many possible formats or variations of RAM instructions, unfortunately, the syntax is not very unified. I
guess the reason is that RAM is not a real machine, and for the purposes of the algorithm analysis the machine is so
simple that it's description is repeated in almost every paper where it appears.

For this reason, the instructions format or the whole vocabulary might be different from what you expected or used for.
We have to live with it, but the differences are tiny.

Instructions should follow the Input section, but the sections can be mixed. It is just good practice to have input
separated from the code. Each instruction must be on a separate line, in the form:

{:.code-example}
```
    [LABEL:] INSTRUCTION [; optional comment]
```

Each instruction position can be optionally labeled with some identifier (`LABEL` field), followed by a colon (`:`)
character. The labels can be then referred to in other instructions.

Comments begin with a semicolon (`;`) character and continue to the end of the line. There are no multi-line comments.

Instructions consist of the operation code and optional operand, separated with space (` `).

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

For example, this is a valid program:

{:.code-example}
```
; COPY(X,Y)
;
; input:  X -> r1
;         Y -> r2
;
; output: X -> Y
;         Y -> Y

<input> 3 4 world hello

<input> sss
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
