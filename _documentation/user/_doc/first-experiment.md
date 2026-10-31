---
layout: default
title: First experiment
description: "Run the bundled BrainDuck Hello, World! example, then inspect a single instruction in emuStudio."
nav_order: 0
has_children: false
permalink: /first-experiment/
---

{% include analytics.html category="First experiment" %}

# Run your first program

Run a bundled example that prints **Hello, World!**, then watch one instruction change a memory byte.
You will use **BrainDuck**, a small teaching computer included with emuStudio. You do not need to write code,
build a computer configuration, or download disk images.

Already installed emuStudio? [Start with opening BrainDuck](#2-open-brainduck).
For the full reference, go to the [application guide]({{ site.baseurl }}/application/).

## 1. Install and launch

[Download emuStudio](/download/) and unpack the complete TAR or ZIP archive into a folder you can write to.
It includes the computer configurations, plugins, and examples used here. Install Java 11 or later, then start
emuStudio from the unpacked folder:

- **Linux:** run `./emuStudio`.
- **Windows:** run `emuStudio.bat`.

The **Open virtual computer** dialog appears. If the launcher does not start, check the Java installation and
the [installation instructions](/download/#installation--run) before continuing.

## 2. Open BrainDuck

Select **BrainDuck** in the **Virtual computers** list and click **Open computer**. Use the supplied configuration
without changing its settings. It already connects the compiler, CPU, memory, and terminal.

You should now see the source editor and a **Debugger** tab. If BrainDuck is missing, check that you unpacked
the full distribution and are using its configuration folder; see [Opening a computer]({{ site.baseurl }}/application/opening-computer).

## 3. Compile the example

Choose **File → Open** and open `examples/brainc-brainduck/hello1.b` inside the unpacked emuStudio folder.
The file contains comments followed by lines of `+`, `-`, and `.` instructions. Leave it unchanged.

Click **Save & Compile** on the editor toolbar. Look for **Compile was successful.** in the output below the editor.
The compiled program is loaded into the computer's memory and the CPU is reset to its starting position;
there is no separate load step.

If emuStudio asks you to stop emulation, click **Stop** in the debugger before compiling again. If the example
file is missing, look inside the unpacked distribution's `examples/brainc-brainduck` folder.

## 4. Run and see the result

Switch to **Debugger**. In **Peripheral devices**, select **VT100-terminal** and click **Show device** to open
its window. Keep it visible, return to the debugger, and click **Run**.

The terminal displays:

```text
Hello, World!
```

The program finishes without asking for input. If the terminal stays blank, confirm that you selected BrainDuck,
compiled `hello1.b` successfully, opened its terminal window, and clicked **Run**.

## 5. Inspect one instruction

Return to the editor and click **Save & Compile** again to start with fresh program and data memory.
Return to **Debugger**, but do not click **Run** yet.

In the CPU status panel, find `IP` (the next instruction's address) and `*P` (the value of the current data byte).
They start at `0000` and `00` respectively. Click **Step forward** once: `IP` becomes `0001`, and `*P` becomes `01`.
These values are displayed in hexadecimal.

You have executed the example's first `+` instruction: it increases the current data byte by one. The highlighted
instruction moves forward. The terminal does not print a character yet; a `.` instruction produces output.

Click **Run** when you want the rest of the program to execute. You have now compiled, run, and inspected a program
on an emulated computer.

## Continue exploring

- [BrainDuck instructions]({{ site.baseurl }}/brainduck/compiler#language-syntax) explain the small language used by this example.
- [BrainDuck CPU status]({{ site.baseurl }}/brainduck/cpu#status-panel) explains the remaining registers and indicators.
- [The application guide]({{ site.baseurl }}/application/) covers the editor, debugger, and other workflows.
- [The full user introduction]({{ site.baseurl }}/introduction/) introduces the other real and abstract computers.

This guide follows the current development documentation. If a published release has different controls, use the
documentation bundled with that release.
