---
layout: default
title: First experiment
description: "Run Hello world! on the Intel 8080 MITS Altair 8800 and step through its first instruction."
nav_order: 0
has_children: false
permalink: /first-experiment/
---

{% include analytics.html category="First experiment" %}

# Run your first program

Compile an 8080 program, print **Hello world!** on the Altair terminal, and step through the first instruction to
find the message address.

Already installed emuStudio? [Start with opening the Altair](#2-open-the-altair).

## 1. Install and launch

1. [Download emuStudio](/download/) and unpack the full distribution into a folder you can write to.
2. Install Java.
3. Start emuStudio from the extracted folder. Run `./emuStudio` on Linux or `emuStudio.bat` on Windows.

When the **Open virtual computer** dialog appears, continue to the next step. If the launcher does not start, check the Java installation and
the [installation instructions](/download/#installation--run) before continuing.

## 2. Open the Altair

Select **MITS Altair8800** in the list and click **Open computer**. This configuration includes the Intel 8080
CPU, its assembler, and the ADM-3A terminal. Use the default settings.

![Computer chooser with MITS Altair8800 selected and 8080-cpu in its schema]({{ site.baseurl }}/assets/altair8800/quickstart/open-altair.png)

You should now see the **Source code editor** and **Emulator** tabs. If the Altair configuration is missing,
check that you unpacked the full distribution. See [Opening a computer]({{ site.baseurl }}/application/opening-computer).

## 3. Compile the example

1. Download [hello-world-8080.asm]({{ site.baseurl }}/assets/altair8800/hello-world-8080.asm){:download="hello-world-8080.asm"}
   and save it in a folder you can write to.
2. Choose **File → Open…** and open the downloaded file.
3. Choose **Save & Compile source file**. When the output shows **Compile was successful.**, the program is in memory
   and the CPU is at its starting address.

![hello-world-8080.asm open in the editor with Compile was successful in the output pane]({{ site.baseurl }}/assets/altair8800/quickstart/compile.png)

The program starts at address `0000` and uses the `HL` register pair to read a zero-terminated message byte by byte.
It sends each byte to output port `11h`, which the default 88-SIO routes to the ADM-3A terminal; the message bytes
form the box and greeting. When the program reaches the terminating zero, it halts.

If emuStudio asks you to stop emulation, use **Stop emulation** on the **Emulator** tab before compiling again.

## 4. Run and see the result

1. Switch to **Emulator**. In **Peripheral devices**, select **LSI ADM-3A terminal** and choose **Show device…**.
2. Move the terminal aside if it covers the toolbar, then choose **Run**.

The terminal displays **Hello world!** in a box, then the program halts.

![ADM-3A terminal displaying Hello world! in a box]({{ site.baseurl }}/assets/altair8800/quickstart/hello-world.png){:width="1024" height="836" loading="lazy" style="max-width: 100%; height: auto;"}

If the terminal stays blank, confirm that you opened **MITS Altair8800**, compiled `hello-world-8080.asm`
successfully, and clicked **Run emulation**.

## 5. Inspect one instruction

1. Return to **hello-world-8080.asm** and choose **Save & Compile source file** again.
2. Switch to **Emulator**. Find the program counter, `PC`, at `0000` in CPU status.
3. Choose **Step** once. The instruction `LXI H, message` loads the message address into `HL`. Check that `HL`
   shows `0010` and `PC` advances to `0003`. Both values are hexadecimal.

![Emulator after one step with HL at 0010 and PC at 0003 in CPU status]({{ site.baseurl }}/assets/altair8800/quickstart/single-step.png)

To print the message again, choose **CLEAR** in the terminal, then **Run** on the **Emulator** toolbar.

## Continue exploring

- [MITS Altair 8800]({{ site.baseurl }}/altair8800/) describes the virtual computer and its devices.
- [Intel 8080 CPU]({{ site.baseurl }}/altair8800/8080-cpu) describes the processor and its status window.
- [ADM-3A message boxes]({{ site.baseurl }}/altair8800/adm3a-terminal#drawing-message-boxes) shows the example's output.
- [The application guide]({{ site.baseurl }}/application/) covers the editor, debugger, and other workflows.
- [The full user introduction]({{ site.baseurl }}/introduction/) introduces the other real and abstract computers.
