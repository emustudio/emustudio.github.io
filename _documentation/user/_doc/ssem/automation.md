---
layout: default
title: Automation
nav_order: 2
parent: SSEM
permalink: /ssem/automation
---

{% include analytics.html category="SSEM" %}

# Automation

SSEM computer will recognize if automatic emulation is executed. In the case of non-interactive mode (`--no-gui`),
the memory final "snapshot" along with additional information is written to a file named `ssem.out`.

The file is overwritten after each emulation "stop".

## Example

The emulator automation can be run as follows:

    ./emuStudio -cf config/SSEMBaby.toml --input-file examples/as-ssem/addition.ssem auto --no-gui

- computer configuration `config/SSEMBaby.toml` will be loaded
- input file for compiler is one of the standard examples
- (`auto`) automatic emulation will be executed
- (`--no-gui`) non-interactive mode will be set

The console reports compilation and execution progress:

{:.code-example}

```
[INFO] Starting emulation automation...
[INFO] Emulating computer: SSEM (Baby)
[INFO] Compiling input file: examples/as-ssem/addition.ssem
[INFO] Compiler started working.
[INFO] Compilation finished.
[INFO] Resetting CPU...
[INFO] Running emulation...
[INFO] Normal stop
[INFO] Emulation completed
```

The addition example computes `5 + 3`. The file `ssem.out` starts with the final accumulator and byte control address,
followed by a 32-line memory snapshot:

{:.code-example}
```
ACC=0x8
CI=0x18
```

The result is also stored in memory line 31. `CI=0x18` corresponds to line 6, containing the stop instruction.
