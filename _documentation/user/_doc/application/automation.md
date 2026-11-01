---
layout: default
title: Automation
nav_order: 1
parent: emuStudio Application
permalink: /application/automation
---

{% include analytics.html category="Application" %}

# Automation

Automation loads a computer, optionally compiles a source file, and runs the CPU without using the main window.
It is useful for batch runs, assignments, and programs whose device output is the main result.

In interactive mode, device GUIs are shown automatically when supported. You can interact with them, but the source
editor and debugger are unavailable.

Non-interactive mode (`--no-gui`) opens no GUI windows. Device output and access to host resources depend on each plugin.

Source code supplied with `--input-file` is compiled and loaded before the CPU runs. This option is optional: omit it
to run code already loaded by the computer configuration, such as a ROM image.

More specific information about automation can be found in any section devoted to an emulated computer.

## Example

The example of running automatic emulation is as follows:

    ./emuStudio -cf config/MITSAltair8800.toml --input-file examples/as-8080/reverse.asm auto --no-gui --waitmax 5000

The `-cf` (or `--computer-file`) argument loads specific computer configuration instead of asking the user to open a
computer.

Argument `--input-file` provides the source code to be compiled and loaded into memory before the emulation is executed.
It compiles the file only in case automated emulation is executed (see below).

Command `auto` executes automatic emulation. Select a computer with `-cf`, `-cn`, or `-ci`. If an input file is provided,
it is compiled into memory. Interactive automation opens the device GUIs and starts the CPU.

The `--no-gui` argument sets the non-interactive mode. In this case, emuStudio won't show any GUI windows and
each device determines its headless behavior. Terminals can use files; other devices may run silently or require host
resources (see the involved plugins' documentation).

Argument `--waitmax 5000` waits at most 5 seconds for the running CPU to stop. When the deadline expires, the CPU is
stopped when the virtual computer is closed. A CPU still running at the deadline is logged as `Invalid state (running)`.
This limit does not include compilation or device initialization. Omit it to wait without a deadline.

Use `-p ADDRESS` (or `--program-location ADDRESS`) after `auto` to override the starting instruction address. Addresses
can use decimal or a radix prefix such as `0x8000`. Without an override, the CPU uses its reset/compiled-program location.
Check `logs/automation.log` and the device output to determine whether the run completed normally. Compilation and
debug-script failures return a nonzero exit status.
Other run outcomes, including normal execution timeouts, are recorded in the logs.


## Debug scripts

Use `auto --debug-script FILE` to execute bounded debugger operations after optional compilation and CPU reset. Select
the computer before `auto`; put `--debug-script`, `--no-gui`, and `-p` after it. For example, save this 8080 program as `probe.asm`:

```text
org 0
mvi a, 42h
sta 0100h
hlt
```

Save its experiment as `probe.debug`:

```text
RUN 5 10
ASSERT PC == 5
ASSERT A == 0x42
ASSERT mem[0x100] == 0x42
CAPTURE result.bin
```

Run it from the emuStudio installation directory:

```sh
./emuStudio -cf config/MITSAltair8800.toml -i probe.asm auto --no-gui -p 0 --debug-script probe.debug
```

RUN stops before the instruction at address 5 after at most ten instructions. The assertions check the accumulator and
stored byte; CAPTURE writes the selected logical bank to `result.bin` beside `probe.debug` (64 KiB for the default Altair
memory). A failing assertion returns exit status 1 and identifies the script line in `logs/automation.log`.

| Operation | Behavior |
|---|---|
| `STEP count` | Execute 1–1,000,000 instructions. |
| `RUN address max-instructions` | Step until PC equals the address, with a limit of 1–1,000,000 instructions. If PC already matches, execute none. |
| `ASSERT expression` | Require a nonzero numeric result; use the same expression syntax as watches. |
| `CAPTURE filename` | Save the selected byte-memory bank, including its common region. Relative paths start at the script directory; an existing file is replaced. |

Blank lines and lines starting with `#` are ignored. Addresses and counts accept decimal or `0x` prefixes. A failed
operation, compilation error, unexpected CPU stop, or missing step-completion notification returns a nonzero exit status.
Step completion has a five-second wait. The script runner uses synchronous stepping; `--waitmax` controls normal continuous
automation and does not bound scripts. Use each RUN/STEP instruction limit to bound execution instead.

See [Debugger inspection]({{ '/application/debugger-analysis' | relative_url }}) for expression syntax and memory-bank behavior.
