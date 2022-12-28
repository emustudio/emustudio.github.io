---
layout: default
title: Disassembler
nav_order: 4
parent: Writing a CPU
permalink: /cpu/disassembler
---

{% include analytics.html category="developer" %}

# Disassembler

Disassembler is not needed for the emulation itself. It is needed for emuStudio to be able to visually show the
instructions. You can create a disassembler by implementing interface [Disassembler][disassembler]{:target="_blank"}
from emuLib. Or you can use [Edigen][edigen]{:target="_blank"}, a disassembler generator for emuStudio.

[Edigen][edigen]{:target="_blank"} works similarly as parser generator: developer writes a specification file.
Then, [Edigen][edigen]{:target="_blank"} (either from the command line or using
[Gradle][edigen-gradle]{:target="_blank"}) generates disassembler and decoder of the source code, using predefined
templates, bundled in [Edigen][edigen]{:target="_blank"}.

Specification files have `.eds` file extension. A [SSEM][ssem]{:target="_blank"} CPU specification file looks as
follows:

{:.code-example}
```
# Decoder section

instruction = "JMP": line(5)     ignore8(8) 000 ignore16(16) |
              "JPR": line(5)     ignore8(8) 100 ignore16(16) |
              "LDN": line(5)     ignore8(8) 010 ignore16(16) |
              "STO": line(5)     ignore8(8) 110 ignore16(16) |
              "SUB": line(5)     ignore8(8) 001 ignore16(16) |
              "CMP": 00000       ignore8(8) 011 ignore16(16) |
              "STP": 00000       ignore8(8) 111 ignore16(16);

line = arg: arg(5);

ignore8 = arg: arg(8);

ignore16 = arg: arg(16);

%%

# Disassembler section

"%s %d" = instruction line(shift_left, shift_left, shift_left, bit_reverse, absolute) ignore8 ignore16;
"%s" = instruction ignore8 ignore16;
```

The specification file might look a bit cryptic at first sight, but it's quite easy. The content is divided into
two sections (_decoder_ and _disassembler_), separated with two `%%` chars on a separate line.

## Decoder section

The decoder section contains rules which are used for parsing the instruction binary codes and assign labels to the
codes.

Decoding always starts with the first rule (in this case, `instruction`).
Each rule has one or more variants. A variant consists of a mixture of constants and subrules.

A constant can be hexadecimal (e.g., `0xF`) or binary (`01`). Constants are used to unambiguously match exactly one
variant for each rule.

A subrule has a name and length in bits -- e.g., `dst_reg(2)`. The bits located at the position of a subrule are passed
to the corresponding rule.

A variant can return a value - either a constant string (`"add"`), or a binary value taken from a subrule (`imm`).

The result of decoding is an associative array in the form {rule: value, ...}.

For example, let us decode the instruction "1111 0100 0000 0011", The second variant of the rule `instruction` is
matched, since `0xF` is 1111. So far, the result is {instruction: "sub"}. The following bits (01) are passed to the
rule `dst_reg`, where the second variant matches, so the result is updated: {instruction: "sub", dst_reg: "Y"}.

Finally, the bits `00 0000 0011` are passed to the rule `immediate`, which just returns the passed binary value.
The final result is {instruction: "sub", dst_reg: "Y", immediate: 3}.

## Disassembler section

The disassembler section specifies the disassembled string formats for particular rules.

More precisely, disassembler part matches a set of rules (on the right side of `=`) to a formatting string (on the left
side).
The first set of rules which is a subset of the result rule-set is selected. The corresponding formatting string is
used,
substituting the formats with concrete values.

In our example, the first rule-set cannot be used, since our result does not contain `src_reg`. However, our result
contains all rules specified in the second rule-set (`instruction dst_reg immediate`), so the disassembled instruction
is "sub Y, 3".

By default, these format specifiers are available:

* `%c` - one character, in the platform's default charset
* `%d` - arbitrarily long signed integer, decimal
* `%f` - a 4-byte of 8-byte floating point number
* `%s` - a string (typically used for string constants returned from variants)
* `%x` - arbitrarily long unsigned integer, hexadecimal, lowercase
* `%X` - arbitrarily long unsigned integer, hexadecimal, uppercase
* `%%` - a percent sign

The rule-set on the right side of `=` can take decoding strategy as a parameter in brackets `()`. The following
decoding strategies are available:

* `bit_reverse` - reverses the bits
* `big_endian` - decodes the bits as they are stored in big-endian format
* `little_endian` - decodes the bits as they are stored in little-endian format
* `absolute` - decodes the bits as stored in 2's complement if they are negative; the negative sign is then thrown away
* `shift_left` - shifts the number to the left by 1 bit. Does it in "big endian" way. Meaning bytes `[0] = 1, [1] = 2`
  will result in `[0] = 2, [1] = 4`
* `shift_right` - shifts the number to the right by 1 bit. Dies it in "big endian" way. Meaning bytes `[0] = 1, [1] = 2`
  will result in `[0] = 0, [1] = 0x81`

The strategies can be combined. Multiple strategies will be applied in the left-to-right order.


[edigen]: https://github.com/emustudio/edigen
[edigen-gradle]: https://github.com/emustudio/edigen-gradle-plugin
[ssem]: https://en.wikipedia.org/wiki/Manchester_Baby
[disassembler]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/Disassembler.html
