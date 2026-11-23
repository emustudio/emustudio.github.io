---
layout: default
title: First experiment
description: "Run Hello world! on the Intel 8080 MITS Altair 8800 and step through the first instruction in emuStudio 0.41."
nav_order: 0
has_children: false
permalink: /first-experiment/
---

{% include analytics.html category="First experiment" %}

# Run your first program

Run an Intel 8080 assembly program on the **MITS Altair 8800** in emuStudio 0.41. It draws a box around
**Hello world!** on the terminal. Then step through the first instruction to see where the message is stored.

Already installed emuStudio? [Start with opening the Altair](#2-open-the-altair).

## 1. Install and launch

[Download emuStudio 0.41](/download/) and unpack its TAR or ZIP archive into a folder you can write to.
It includes the computer configuration and plugins used here. Install Java 11 or later, then start
emuStudio from the unpacked folder:

- **Linux:** run `./emuStudio`.
- **Windows:** run `emuStudio.bat`.

The **Open virtual computer** dialog appears. If the launcher does not start, check the Java installation and
the [installation instructions](/download/#installation--run) before continuing.

## 2. Open the Altair

Select **MITS Altair8800** in the list and click **Open computer**. This configuration includes the Intel 8080
CPU, its assembler, and the ADM-3A terminal. Use the default settings.

![Computer chooser with MITS Altair8800 selected and 8080-cpu in its schema]({{ site.baseurl }}/assets/altair8800/quickstart/open-altair.png){:width="821" height="425" loading="lazy" style="max-width: 100%; height: auto;"}

You should now see the **Source code editor** and **Emulator** tabs. If the Altair configuration is missing,
check that you unpacked the full distribution. See [Opening a computer]({{ site.baseurl }}/application/opening-computer).

## 3. Compile the example

Download [hello-world-8080.asm]({{ site.baseurl }}/assets/altair8800/hello-world-8080.asm){:download="hello-world-8080.asm"}
and save it in a folder you can write to. Choose **File → Open...** in emuStudio and open the downloaded file.

Click **Save & Compile source file** on the editor toolbar. Look for **Compile was successful.** in the output below the editor.
The compiled program is loaded into the computer's memory and the CPU is reset to its starting position;
there is no separate load step.

![hello-world-8080.asm open in the editor with Compile was successful in the output pane]({{ site.baseurl }}/assets/altair8800/quickstart/compile.png){:width="960" height="660" loading="lazy" style="max-width: 100%; height: auto;"}

If emuStudio asks you to stop emulation, use **Stop emulation** on the **Emulator** tab before compiling again.

## 4. Run and see the result

Switch to **Emulator**. In **Peripheral devices**, select **LSI ADM-3A terminal** and click **Show device...**.
If the terminal covers the toolbar, move its window aside. Click **Run emulation** on the **Emulator** toolbar.

The terminal displays **Hello world!** in a box, then the program halts.

![ADM-3A terminal displaying Hello world! in a box]({{ site.baseurl }}/assets/altair8800/quickstart/hello-world.png){:width="1024" height="836" loading="lazy" style="max-width: 100%; height: auto;"}

If the terminal stays blank, confirm that you opened **MITS Altair8800**, compiled `hello-world-8080.asm`
successfully, and clicked **Run emulation**.

## 5. Inspect one instruction

Return to the **hello-world-8080.asm** tab and click **Save & Compile source file** again. Switch to **Emulator**.
In the **Status** panel, find the program counter, `PC`, at `0000`.

Click **Step forward** once. The first instruction, `LXI H, message`, puts the address of the message in
the `HL` register pair. `HL` shows `0010` and `PC` advances to `0003`. The values are hexadecimal.

![Emulator after one step with HL at 0010 and PC at 0003 in the Status panel]({{ site.baseurl }}/assets/altair8800/quickstart/single-step.png){:width="960" height="660" loading="lazy" style="max-width: 100%; height: auto;"}

To print the message again, click the terminal’s broom icon (**Clear screen**), then click **Run emulation**
on the **Emulator** toolbar.

## Continue exploring

These guides follow current development and may show newer controls.

- [MITS Altair 8800]({{ site.baseurl }}/altair8800/) describes the virtual computer and its devices.
- [Intel 8080 CPU]({{ site.baseurl }}/altair8800/8080-cpu) describes the processor and its status window.
- [ADM-3A message boxes]({{ site.baseurl }}/altair8800/adm3a-terminal#drawing-message-boxes) shows the example's output.
- [The application guide]({{ site.baseurl }}/application/) covers the editor, debugger, and other workflows.
- [The full user introduction]({{ site.baseurl }}/introduction/) introduces the other real and abstract computers.
