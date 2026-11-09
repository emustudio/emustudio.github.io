---
layout: default
title: Instruction decoder
nav_order: 4
parent: Writing a CPU
permalink: /cpu/disassembler
---

{% include analytics.html category="developer" %}

# Instruction decoder

A decoder supplies captured instruction facts for debugger listings and recording. Implement emuLib's
[Decoder][decoder]{:target="_blank"} interface directly, or generate an implementation with
[Edigen][edigen]{:target="_blank"}.

[Edigen][edigen]{:target="_blank"} works similarly as parser generator: developer writes a specification file.
Then, [Edigen][edigen]{:target="_blank"} (either from the command line or using
[Gradle][edigen-gradle]{:target="_blank"}) generates one decoder, including private instruction formatting,
using a template bundled in [Edigen][edigen]{:target="_blank"}.

Specification files have `.eds` file extension. Let's have a look at the following sample CPU specification file:

{:.code-example}
```
# decoder
root instruction, data;

instruction =
    "add": 0xE dst_reg(2) src_reg(2) |
    "sub": 0xF dst_reg(2) immediate(10);

data =
    data: data(32);

src_reg, dst_reg =
    "X": 00 |
    "Y": 01;

%%

# disassembler
"%s %s, %s" = instruction dst_reg src_reg;
"%s %s, %d" = instruction dst_reg immediate;
"%x"        = data;
```

The specification file might look a bit cryptic at first sight, but it's quite easy. The content is divided into two
sections (_decoder_ and _disassembler_), separated with two `%%` chars on a separate line.

## Decoded instruction

Expose `CPU.getDecoder()` and decode each instruction once:

```java
DecodedInstruction instruction = cpu.getDecoder().decode(address);
int length = instruction.length();
String mnemonic = instruction.mnemonic();
String encoding = instruction.encoding();
```

`DecodedInstruction` has four accessors: `address()`, `length()`, `mnemonic()`, and `encoding()`.
Length counts addressable memory cells, not necessarily bytes. RAM uses object cells; RASP uses integer cells.
The text describes captured input and never rereads live memory. There is no public Edigen rule payload or
separate disassembler interface.

Invalid encodings fail decoding with `InvalidInstructionException`; inaccessible or truncated memory is a read failure.
Listing recovery may show an undecodable cell and advance one cell. A decode result does not predict execution.

## Observed instruction flow

Flow comes from runtime observations through `Debugging`, not the decoder or `.eds` specification. After a semantic
step, the CPU reports the captured instruction and actual next address. The host accumulates these observed transitions
until CPU reset. Unexecuted paths remain unknown; mnemonic text and opcode patterns are never used to infer edges.

The actual next address already reflects the outcome of branches, calls, returns, indirect transfers, and CPU address
wrapping. Instruction length only describes occupied cells. It is not an execution successor, and there is no
`sequentialAddress()` accessor.

Edigen syntax remains unchanged: decoding rules and rendering formats only. Handwritten decoders expose the same four
instruction accessors. See [Optional machine debugging]({{ '/cpu/debugging' | relative_url }}) for runtime observations.

### CPU memory wiring and graph lifetime

The CPU plugin supplies the decoder and its memory wiring. Instruction text and lengths use
that logical address space. Read each address through the connected memory context. The connected plugins implement
address mapping; decoding preserves that wiring. Runtime next addresses come from the executed machine state.

Memory edits, annotations, source changes, and continuing execution do not erase the observed graph. CPU reset clears
the graph while preserving annotations. Captured instruction facts describe the bytes or cells observed at that step;
they are not a frozen live-memory image. Listing refresh still validates its own memory view independently.

## Decoder section

```
Rule               instruction =
  Variant              "add":
    Constant             0xE
    Subrule              dst_reg(2)
    Subrule              src_reg(2) |
  Variant              "sub":
    Constant             0xF
    Subrule              dst_reg(2)
    Subrule              immediate(10) ;

Rule               data =
  Variant              data:
    Subrule              data(32) ;

Rule               src_reg, dst_reg =
  Variant              "X":
    Constant             00 |
  Variant              "Y":
    Constant             01 ;
```

Decoder part consists of a set of **rules**. It starts with declaration of root rules, which are tried to be matched
in defined order. In our case, the first rule will be `instruction` and if that is not matched, the other rule `data`
will be tried.

After root-rules declaration, rule definitions follow. Rule definition ends with a semicolon `;`.

A **rule** is composed of one or more **variants**, split with pipe `|`. A variant can optionally start with a name -
in quotes, followed by a colon `:`. The variant name can be referenced in disassembler part by rule name. Optionally,
the variant can return a binary value taken from a *subrule* - again by referencing its name without quotes, followed
by a colon `:`. What follows after colon is a mixture of **constants** or **subrules**.

A **constant** can be hexadecimal (e.g., `0xF`) or binary (`01`). Constants are used to perform unambiguous match of
exactly one variant for each rule.

A **subrule** is a reference to another rule (which might or might not be explicitly defined). Subrule starts with
a name (without quotes), followed by optional pre-pattern enclosed in square brackets, and optionally length in bits -
e.g., `dst_reg[1](2)`. This means that `dst_reg` will match two bits only if the two-bit sequence starts with binary 1.

The generator internally tracks recognized values in the form `{rule: value, ...}`; these values are private and
are not exposed through `DecodedInstruction`.

For example, let us decode the instruction `1111 0100 0000 0011`, The second variant of the rule `instruction` is
matched, since `0xF` is `1111`. So far, the result is `{instruction: "sub"}`. The following bits (`01`) are passed to
the rule `dst_reg`, where the second variant matches, so the result is updated: `{instruction: "sub", dst_reg: "Y"}`.

Finally, the bits `00 0000 0011` are passed to the rule `immediate`, which just returns the passed binary value.
The final result is `{instruction: "sub", dst_reg: "Y", immediate: 3}`.

## Disassembler section

The disassembler maps a set of rules on the right side of `=` to a format string on the left. It selects the format
whose rule set exactly matches the decoded result's keys, then substitutes the corresponding values.

In our example, the first rule-set cannot be used, since our result does not contain `src_reg`. However, our result
contains all rules specified in the second rule-set (`instruction dst_reg immediate`), so the disassembled instruction
is `"sub Y, 3"`.

By default, these format specifiers are available:
* `%c` - one character, in the platform's default charset
* `%d` - signed integer in decimal (the default formatter stores numeric values in a 32-bit `int`)
* `%f` - a 4-byte floating point number; the default numeric storage does not preserve a full 8-byte value
* `%s` - a string (typically used for string constants returned from variants)
* `%x` - 32-bit integer bit pattern, hexadecimal, lowercase
* `%X` - 32-bit integer bit pattern, hexadecimal, uppercase
* `%%` - a percent sign

The default formatter consumes these two-character specifiers. It does not support Java formatter width or padding
flags such as `%02x`.

The rule-set on the right side of `=` can take decoding strategy as a parameter in brackets `()`. The following decoding
strategies are available:

* `bit_reverse` - reverses the bits
* `reverse_bytes` - reverses the byte order (an endianness swap)
* `absolute` - decodes the bits as stored in 2's complement if they are negative; the negative sign is then thrown away
* `shift_left` - shifts the number to the left by 1 bit. Does it in "big endian" way. Meaning bytes `[0] = 1, [1] = 2`
  will result in `[0] = 2, [1] = 4`
* `shift_right` - shifts the number to the right by 1 bit. Does it in "big endian" way. Meaning bytes `[0] = 1, [1] = 2`
  will result in `[0] = 0, [1] = 0x81`

The strategies can be combined. Multiple strategies will be applied in the left-to-right order.
Unknown strategy names fail generation. See the [EDS language reference][eds-language]{:target="_blank"} for the full syntax.

## Gradle integration

The current emuStudio CPU plugins use `edigen-gradle-plugin` to generate sources during Java compilation:

{:.code-example}
```groovy
plugins {
    id 'net.emustudio.edigen-gradle-plugin' version '1.6.0-SNAPSHOT'
}

edigen {
    decoderName = 'example.cpu.DecoderImpl'
}
```

Put the specification in `src/main/edigen/cpu.eds`, or set `specification` in the `edigen` block. `generateSources`
writes the decoder Java file under `build/generated-sources/edigen/` by default and registers that directory with the Java
source set. A separate `compileJava.dependsOn` declaration is unnecessary. In emuStudio, the snapshot plugin resolves
through the repositories already declared in `settings.gradle`.

Keep generated output separate from handwritten sources. The task tracks its files with ownership metadata; it refuses
to overwrite an unowned destination file and removes obsolete owned files after a class rename. When upgrading from a
version without that metadata, clean the old generated output once (`clean` covers the default directories). See the
[plugin reference][edigen-gradle]{:target="_blank"} for templates, output locations, and local Edigen development.

## Formatting in rule names

This feature allows to specify formatting directly in variant names. This capability is enabled only in case a default
decoder template is used. An example follows (partial Z80 CPU decoder):

```
root instruction;

# http://www.z80.info/decoding.htm
instruction =
  "nop":         00 000 000                       |  # x=0, y=0, z=0
  "ex af, af'":  00 001 000                       |  # x=0, y=1, z=0
  "djnz %X":     00 010 000 imm8                  |  # x=0, y=2, z=0
  "jr %X":       00 011 000 imm8                  |  # x=0, y=3, z=0
  "jr %s, %X":   00 1 cc_jr(2) 000 imm8           |  # x=0, y=4..7, z=0
  "ld %s, %X":   00 rp(2) 0 001 imm16             |  # x=0, p=rp, q=0, z=1
  "add hl, %s":  00 rp(2) 1 001                   |  # x=0, p=rp, q=1, z=1
  "ld (bc), a":  00 000 010                       |  # x=0, p=0, q=0, z=2
  "ld (de), a":  00 010 010                       |  # x=0, p=1, q=0, z=2
  ...

cc_jr =
  "nz": 00 |
  "z":  01 |
  "nc": 10 |
  "c":  11 ;

rp =
  "bc": 00 |
  "de": 01 |
  "hl": 10 |
  "sp": 11 ;

imm8 = imm8: imm8(8);
imm16 = imm16: imm16(16);

%%

"%s" = instruction cc_jr imm8;
"%s" = instruction rp imm16;
"%s" = instruction rp;
"%s" = instruction imm8;
```

In this case, the disassembler will recognize formatting symbolics in the variant names, and recursively replaces the
original disassembler format symbols with the actual values.

So in the example, format `"%s" = instruction cc_jr imm8;` matches rule `"jr %s, %X":   00 1 cc_jr(2) 000 imm8`.
This format has three arguments: `instruction`, `cc_jr` and `imm8`. So, the disassembler will:

1. Replace format `"%s"` with argument `instruction`, which is a rule returning string `"jr %s, %X"`.
2. Now the format `"jr %s, %X"` is recursively replacing first found format symbol (`%s`) with the next argument,
   which is result of `cc_jr` (if bits in `cc_jr` are e.g. `10`, then the result would be `nc`). So the new
   value of the format will now be: `"jr nc, %X"`.
3. Lastly, the value of `imm8` is to be a replacement for last `%X`. The `imm8` is returning 8-bit number,
   the actual value of the binary match (e.g. for value `00100000` the `%X` would convert it to hexadecimal value
   0x20). Now the format results in: `jr nc, 20`

*NOTE*: If you do not want formatting to be interpreted, just prepend another `%` to the unwanted format syntax, e.g.
for `%X` just do `%%X`.


[edigen]: https://github.com/emustudio/edigen
[eds-language]: https://github.com/emustudio/edigen/blob/development/docs/_eds-language.adoc
[edigen-gradle]: https://github.com/emustudio/edigen-gradle-plugin
[ssem]: https://en.wikipedia.org/wiki/Manchester_Baby
[decoder]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/Decoder.html
