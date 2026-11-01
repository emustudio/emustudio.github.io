---
layout: default
title: Example code
nav_order: 1
parent: BrainDuck
permalink: /brainduck/examples
---

{% include analytics.html category="BrainDuck" %}

# Example code

Start with the programs in `examples/brainc-brainduck/` in your emuStudio installation, then explore the external
collections below. BrainDuck runs brainfuck programs through its compiler, CPU, memory, and VT100 terminal.

## Run a bundled example

1. Open the **BrainDuck** virtual computer.
2. Open `examples/brainc-brainduck/hello1.b` in the source editor.
3. Click **Save & Compile source file** to load the program into memory and reset the CPU.
4. Open the VT100 terminal window, switch to **Debugger**, and click **Run**.

The terminal displays `Hello, World!`. This program needs no input. Use **Step forward** to follow individual
instructions, or see [First experiment]({{ site.baseurl }}/first-experiment) for a guided walkthrough.

The [bundled source directory][bundled]{:target="_blank"} contains these examples:

| Program | What to try |
|:--|:--|
| `hello1.b`, `hello2.b` | Compare two ways to print a greeting: changing one cell and using several cells with loops. |
| `print_three.b` | Enter three characters; the program echoes each one and stops after the third. |
| `print_reverse.b` | Enter a line ending in LF (ASCII 10); the program prints its characters in reverse order. |
| `print_string.b` | Enter bytes followed by a zero byte; the program then prints the stored text. Use the terminal's **ASCII input** dialog to enter zero. |
| `fibo.b` | Follow a Fibonacci calculation and its decimal-output routine. |
| `factor.b` | Enter a positive decimal integer followed by LF to factor it. |
| `hanoi.b` | Watch a Towers of Hanoi demonstration in the VT100 terminal. |
| `mandelbrot.b` | Draw a Mandelbrot set using a terminal of at least **130 columns by 50 rows**. |

Recompile before a fresh run to clear old data. BrainDuck cells hold bytes, so arithmetic wraps between 0 and 255.
The bundled `fact.b` assumes wider integer cells and overflows when calculating `6!`; use it to study the code rather
than to check large factorials. See the [compiler guide]({{ site.baseurl }}/brainduck/compiler) for the language rules.

## Small programs to single-step

### Print one letter

Save this as `letter-a.b`, compile it, and run it:

```text
++++++++[>++++++++<-]>+.
```

The program prints `A` (ASCII 65). It sets the first cell to 8, then transfers eight increments to the next cell
on each loop iteration. The second cell reaches 64; the final `+.` increments it to 65 and prints it.

### Read and echo three characters

Save this as `echo-three.b`:

```text
,.,.,.
```

Each `,` reads one byte, and each `.` writes it. In the GUI, enter a character when the terminal's input indicator
turns red. Entering `A`, `B`, and `C` produces `ABC`, then the program stops. See the
[terminal guide]({{ site.baseurl }}/brainduck/terminal) for keyboard and numeric byte input.

## Run without windows

Run `hello1.b` from the installation directory:

```sh
./emuStudio -cn "BrainDuck" -i examples/brainc-brainduck/hello1.b auto --no-gui --waitmax 5000
```

On Windows, use `.\emuStudio.bat` in place of `./emuStudio`. Read the greeting in `vt100-terminal.out`, which is
created or overwritten in the working directory. A warning about a missing `vt100-terminal.in` does not prevent
this output-only program from finishing. `--waitmax 5000` limits the emulation wait to five seconds; larger programs
may need a longer limit.

For `echo-three.b`, put exactly the bytes `ABC` in `vt100-terminal.in`, then run the command with `-i echo-three.b`.
The output file should contain `ABC`. File input preserves the supplied bytes, including line endings. Once the
input is exhausted, another `,` waits for more data; reaching the end of the file does not supply a zero byte.
See [automation]({{ site.baseurl }}/brainduck/automation) for input timing and file redirection.

## More program sources

- [Daniel B. Cristofani's program collection][cristofani]{:target="_blank"}. Try `sierpinski.b` for an ASCII triangle,
  `squares.b` for square numbers, or `fib.b` for a stream of Fibonacci numbers. The collection also includes sorting,
  games, interpreters, and notes on program data layouts.
- [Get good at brainfuck][tutorial]{:target="_blank"}. Cristofani explains his programs in detail, including Fibonacci
  numbers, a random-number generator, factorials, and Conway's Game of Life. Start here to learn how the programs
  arrange and move data.
- [fabianishere/brainfuck examples][fabianishere]{:target="_blank"}. A broad collection with greetings, byte-copying
  programs, ROT13, Hanoi, and directories for mathematics, sorting, ASCII art, and interpreters.
- [The Brainfuck Archive's program directory][archive]{:target="_blank"}. Historical source files such as
  `hello_world.b`, `mandelbrot.b`, `rot13.b`, and `triangle.bf`, alongside commented listings and larger experiments.
- [pablojorge/brainfuck programs][pablojorge]{:target="_blank"}. A smaller collection with `hello.bf`, `primes.bf`,
  `sierpinski.bf`, `rot13.bf`, and interpreter examples.

These are sources to explore; their presence in a collection does not establish compatibility with BrainDuck.
Check the program's input, memory, and cell-size requirements before running it.

## Adapt external programs

- **Copy the program's source, keeping its original file and attribution.** Save a working copy as `.b` and compile
  it in BrainDuck. A source file from another interpreter is not a compiled emuStudio memory image.
- **Check comments before compiling.** In `brainc-brainduck`, the first non-instruction character other than whitespace
  starts a comment through the end of that line. For example, `label ++++.` compiles no instructions, while
  `++++. # print a byte` retains the code before `#`. Move instructions before prose or onto separate lines. Also
  check punctuation at the start of prose: `;` is BrainDuck's halt instruction.
- **Match the cell size and memory layout.** Cells wrap modulo 256. The bundled computer has 65,536 bytes shared by
  code and data, rather than a separate tape of that many data cells. Moving left of the initial data cell can overwrite
  program instructions. Programs requiring wider cells or an unbounded tape need changes.
- **Supply the expected terminator.** Use LF (10) for a newline-terminated program, or an actual zero byte for a
  zero-terminated one. A loop such as `,[.,]` will wait at the end of a headless input file unless the input includes
  its terminating zero byte. Use a timeout when trying an unfamiliar input-driven program.
- **Check brackets and output expectations.** Keep every `[` paired with `]`; the compiler does not validate pairing.
  Some examples run indefinitely and need a manual stop. For animated or graphical output, use the VT100 window and
  the terminal dimensions requested by the source.

[bundled]: https://github.com/emustudio/emuStudio/tree/develop/plugins/compiler/brainc-brainduck/src/main/examples
[cristofani]: https://brainfuck.org/
[tutorial]: https://brainfuck.org/ggab.html
[fabianishere]: https://github.com/fabianishere/brainfuck/tree/master/examples
[archive]: https://esoteric.sange.fi/brainfuck/bf-source/prog/
[pablojorge]: https://github.com/pablojorge/brainfuck/tree/master/programs
