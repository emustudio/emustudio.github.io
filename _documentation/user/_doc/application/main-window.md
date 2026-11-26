---
layout: default
title: Main window
nav_order: 5
parent: emuStudio Application
permalink: /application/main-window
---

{% include analytics.html category="Application" %}

# Main window

Use **Source code editor** to write and compile a program. Use **Emulator** to run it, inspect the CPU and memory, or
open the computer's peripheral devices.

## Write and compile a program

The editor keeps each open file in its own tab. The toolbar provides file, undo, search, and compilation commands.
Use **File** and **Edit** for the full command lists, and **Project** to view the computer schema or compiler settings.

![Source editor with a compiled 8080 program and its compiler output]({{ site.baseurl }}/assets/application/source-code-editor.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Editor toolbar**. Open and save files, find text, compile the active file, and adjust font zoom. |
| <span class="circle">2</span> | **File tabs**. Switch between open files. An asterisk marks an unsaved change. |
| <span class="circle">3</span> | **Source view**. Edit the active file with syntax highlighting and line numbers. |
| <span class="circle">4</span> | **Compiler output**. Check messages after compilation. Drag the divider to resize this pane, or click a divider arrow to collapse or restore it. |

1. Open a file that the selected computer's compiler supports.
2. Save modified include files so the compiler reads their current contents from disk. Stop the emulator if it is running.
3. Choose **Save & Compile source file**. Check the output pane for the result and any reported source locations.
4. On success, switch to **Emulator**. The compiler has loaded its output and emuStudio has reset the CPU.

The 8080 and Z80 assemblers write the addresses they generate. The BrainDuck, RAM, RASP and SSEM compilers clear
their program memory before loading successful output. The compiler may also produce a file on disk.

See [Source editing]({{ '/application/source-editing' | relative_url }}) for tabs, shortcuts and refactoring.

## Run and inspect the computer

The **Emulator** tab puts execution controls above the workspace. **Debugger** shows live instructions and
**Recording** shows captured execution. CPU status, **Watches**, and **Peripheral devices** sit to the right.

![Emulator workspace with the execution toolbar, instruction listing, status, watches, and devices]({{ site.baseurl }}/assets/application/debugger-workspace.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Execution toolbar**. Reset, run, pause, step, set the PC or a breakpoint, and open operating memory. |
| <span class="circle">2</span> | **Debugger and Recording**. Switch between live disassembly and captured execution. |
| <span class="circle">3</span> | **Instruction listing**. Inspect instructions, breakpoints, labels, and observed branches. |
| <span class="circle">4</span> | **CPU status**. Read registers, flags, and execution state. Each CPU supplies its own panel. |
| <span class="circle">5</span> | **Watches**. Evaluate expressions when execution stops or pauses. |
| <span class="circle">6</span> | **Peripheral devices**. Select a device, then choose **Show device…** or **Show settings…** when available. |

Drag a divider to resize the panels on either side. Click a divider arrow to collapse the panel it points toward.
Click the remaining arrow to restore the panel. See [Debugger inspection]({{ '/application/debugger-analysis' | relative_url }})
for breakpoints, annotations, watches, and recordings.

### Use the execution toolbar

Choose **Run** for continuous execution, **Run timed…** to advance at a set interval, or **Step** to execute one
instruction. Pause execution to inspect the next instruction and the current CPU state.

![Execution toolbar with numbered controls]({{ site.baseurl }}/assets/application/emulator-debugger-toolbar.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Reset**. Reset the CPU, memory, and devices. |
| <span class="circle">2</span> | **Jump to beginning**. Set the program counter to address zero. |
| <span class="circle">3</span> | **Move program counter backward**. Set the PC to the debugger's estimated previous instruction. Registers and memory retain their current values. |
| <span class="circle">4</span> | **Stop**. End the current run. |
| <span class="circle">5</span> | **Pause**. Suspend a continuous or timed run. |
| <span class="circle">6</span> | **Run**. Start or resume execution from the current PC. |
| <span class="circle">7</span> | **Run timed…**. Enter the interval between instructions in milliseconds. |
| <span class="circle">8</span> | **Step**. Execute one instruction. |
| <span class="circle">9</span> | **Jump to address**. Enter the address of the next instruction to execute. |
| <span class="circle">10</span> | **Set breakpoint…**. Set or unset a breakpoint at an address. |
| <span class="circle">11</span> | **Show operating memory**. Open the memory plugin's window. |

{: .warning}
Load boot images and apply memory patches after **Reset**. A subsequent reset can replace memory contents according to
the computer configuration.
