---
layout: default
title: Compiler "ramc-ram"
nav_order: 2
parent: RAM
permalink: /ram/ramc-ram
---

{% include analytics.html category="RAM" %}

# Compiler "ramc-ram"

The RAM language provides direct and indirect register access, input/output operations, and three jump instructions.

Source code files end with `.ram` extension; compiler output uses extension `.bram`.

## Running from the command line

Run the compiler from the emuStudio installation directory:

```
java -cp "compiler/*:memory/*:lib/*" net.emustudio.plugins.compiler.ram.Runner --output program.bram program.ram
```

On Windows, replace the classpath separators `:` with `;`. Options are `--output`/`-o`, `--help`/`-h`, and `--version`/`-v`. Put options before the input filename.
Without `--output`, the compiler uses the input filename with the `.bram` extension. This compiles a file;
it does not start a virtual computer. Use [automation]({{ site.baseurl }}/application/automation) to compile and run.

## Numeric limits

This implementation uses signed 32-bit integers (`-2147483648` through `2147483647`) for numeric values. Arithmetic
can overflow this range; it does not provide the unbounded integers of the theoretical machine. Integer division
truncates toward zero. Avoid dividing by zero, which stops execution with an error. Register indices must be
non-negative.

## Language syntax

A program written for RAM consists of two sections, which can be intermixed and repeated in any order, but
the preferred order is as follows:

{:.code-example}
```
INPUT section
INSTRUCTIONS section
```

### Input section

The `INPUT` section defines the input tape with one or more lines of the form:

{:.code-example}
```
<input> ITEMS
```

`ITEMS` is a space-separated list of integers or strings. Quote strings with single (`'`) or double (`"`) quotes.
Integers support decimal, hexadecimal (`0x` prefix or `h` suffix), octal (`o`/`q` suffix), and binary (`b` suffix) notation.

For example, the input section might be:

{:.code-example}
```
    <input> 1 2 3 'hello' 'world!'
```

This defines five inputs: `1`, `2`, `3`, `hello`, and `world!`. Floating-point values are not supported.

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

An instruction consists of an operation code and, where required, an operand. Separate them with spaces or tabs on the
same line.

Operation code is expressed as an abbreviation of corresponding operation (e.g. `SUB` for SUBtraction). An operand can
be one of three types: constant (`=i`), direct operand (`i`), where `i` specifies the register index on tape and
indirect operand (`*i`), where the address of operand specified is stored in register _R<sub>i</sub>_.

The following table describes all possible instructions, usable in the RAM simulator:

|---
| Instruction | Constant (`=i`)        | Direct (`i`)              | Indirect (`*i`)
|-|-|-|-
| `READ`      | | _R<sub>i</sub>_ &larr; next input | _M[R<sub>i</sub>]_ &larr; next input |
| `WRITE`     | output &larr; _i_          | output &larr; _R<sub>i</sub>_          | output &larr; _M[R<sub>i</sub>]_
| `LOAD`      | _R<sub>0</sub>_ &larr; _i_          | _R<sub>0</sub>_ &larr; _R<sub>i</sub>_          | _R<sub>0</sub>_ &larr; _M[R<sub>i</sub>]_
| `STORE`     | | _R<sub>i</sub>_ &larr; _R<sub>0</sub>_          | _M[R<sub>i</sub>]_ &larr; _R<sub>0</sub>_
|---
| `ADD`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ + _M[R<sub>i</sub>]_
| `SUB`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ - _M[R<sub>i</sub>]_
| `MUL`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ * _M[R<sub>i</sub>]_
| `DIV`       | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _i_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _R<sub>i</sub>_ | _R<sub>0</sub>_ &larr; _R<sub>0</sub>_ / _M[R<sub>i</sub>]_
|---
| `JMP label` | | _IP_ &larr; address of _label_ |
| `JZ label` | | *if* _R<sub>0</sub>_ == 0 *then* _IP_ &larr; address of _label_ |
| `JGTZ label` | | *if* _R<sub>0</sub>_ > 0 *then* _IP_ &larr; address of _label_ |
|---
| `HALT`      | | halts the simulation |
|---

Jump instructions take a label, rather than a numeric register index. The compiler resolves it to a program address.

### Code example

For example, this is a valid program:

{:.code-example}
```
; Copy R(Y) to R(X)
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
