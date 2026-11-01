---
layout: default
title: Automation
nav_order: 1
parent: RASP
permalink: /rasp/automation
---

{% include analytics.html category="RASP" %}

# Automation

In headless automatic emulation (`auto --no-gui`), each abstract tape logs symbol writes to a file. The format is described in
[abstract tape documentation]({{site.baseurl}}/ram/abstract-tape).

## Example

The bundled factorial source expects an input value, but does not define an input tape. Copy
`examples/raspc-rasp/factorial.rasp` to `factorial-input.rasp` in the installation directory, then add this line before
`org 5`:

```
<input> 5
```

Run the prepared file from the installation directory:

    ./emuStudio -cf config/RandomAccessStoredProgramRASP.toml --input-file factorial-input.rasp auto --no-gui

- configuration `config/RandomAccessStoredProgramRASP.toml` will be loaded
- the input file is the factorial example with its input tape defined
- (`auto`) automatic emulation will be executed
- (`--no-gui`) non-interactive mode will be set

The console reports progress similar to the following (plugin details and paths depend on the installation):

{:.code-example}
```
[INFO] Starting emulation automation...
[INFO] Emulating computer: Random-Access Stored Program (RASP)
[INFO] Compiling input file: factorial-input.rasp
[INFO] Compiler started working.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Starting logging symbols changes to a file: input_tape.out
[INFO] Starting logging symbols changes to a file: output_tape.out
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Emulation completed
```

The run creates two files in the current working directory:

- `input_tape.out`: records input symbols loaded during reset
- `output_tape.out`: records output symbols written by the program

With input `5`, `output_tape.out` contains `5! = 120` at position 0:

```
0 120
```

Each file is a text log. Every row has the format:

    position symbol

`position` is the zero-based symbol position on the tape, and `symbol` is the value written there. A position can occur
more than once in a log. RASP tapes are left-bounded, so positions start at 0.
