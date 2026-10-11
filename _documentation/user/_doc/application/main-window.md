---
layout: default
title: Main window
nav_order: 5
parent: emuStudio Application
permalink: /application/main-window
---

{% include analytics.html category="Application" %}

# Main window

After opening a computer, the main window provides a source code editor and an **Emulator** tab. The editor tab shows
the active source filename, or **Source code editor** when no file is selected.

The **File** and **Edit** menus provide file and text operations. **Project** contains compilation, a view of the
computer schema, and compiler settings. **Help** contains information about emuStudio. The application's
[theme setting]({{ site.baseurl }}/application/configuration-file) controls the appearance of windows and controls.

## Source code editor

![Source editor showing reverse.asm and successful compilation output for the Intel 8080 assembler]({{ site.baseurl }}/assets/application/source-code-editor.png){: style="max-width: 1094px; width: 100%;" }

Write programs in the editor and compile them with the computer's compiler plugin. The compiler determines the input
language and must produce code compatible with the selected CPU.

The toolbar provides **New**, **Open**, **Save**, undo/redo, cut/copy/paste, find, replace, and **Save & Compile**.
Compilation messages appear in the pane below the editor. Drag the divider to adjust its height.

The source code editor supports the following features:

- bundled **JetBrains Mono NL** font
- line numbering and syntax highlighting
- undo/redo
- inline search/replace, selection search, and find/replace across files
- cut/copy/paste text
- multiple carets, rectangular editing, folding, bookmarks, and split views
- text transformations, editing macros, navigation history, and compiler-supported rename and extraction
- whitespace and indentation settings, token colors, and syntax selection per file
- <kbd>Ctrl</kbd> + mouse wheel changes font size

See [Source editing]({{ site.baseurl }}/application/source-editing) for commands, shortcuts, and compiler-supported
refactoring.

### Working with multiple files

Each source file opens in its own tab. **New** creates an untitled tab; **Open** selects an already open file or opens
another tab. A `*` after the tab name marks unsaved changes. Click the small **×** on a file's tab to close it, or use
**File → Close tab** / **Ctrl+W** for the active tab. Save, Save As, search, and compilation act on the focused source
view, including in a split. Closing a modified tab or leaving the computer prompts you to save or discard its changes,
or cancel closing. Closing the last tab creates a fresh untitled tab.
Saved files that remain open are restored when you reopen that virtual computer.

Hold <kbd>Ctrl</kbd> and click an include filename identified by the compiler to open it in a tab. The 8080 and Z80
assemblers support quoted include paths. Save the containing source file first: relative include paths are resolved
from its directory. Hovering over a missing file shows its path in a tooltip.

### Compilation

Click **Save & Compile** to save and compile the selected source file. Save other modified tabs first so included files
are read from their current contents on disk. The compiler output pane shows compilation messages and points to source
positions supplied by the compiler. Stop running emulation before compiling.

Compiled code can produce a binary file (for example a HEX file) and is loaded into operating memory by the compiler.
**Save & Compile** resets the memory plugin before invoking the compiler and resets the CPU afterwards. Memory contents
then depend on the memory plugin's reset behavior and the compiler: the 8080 and Z80 assemblers write generated
addresses, while BrainDuck, RAM, RASP and SSEM compilers clear their program memory before loading successful output.

## Emulator tab

The following example shows the MITS Altair8800 computer with its Intel 8080 CPU and peripheral devices:

![Emulator tab with the 8080 debugger, CPU status and Altair peripheral device list]({{ site.baseurl }}/assets/application/emulator-tab.png){: style="max-width: 1094px; width: 100%;" }

The **Debugger** on the left disassembles memory into instructions. **Peripheral devices** below it lists the computer's
devices. Select a device and click **Show device**, or double-click it, to open its GUI when supported. **Show settings**
opens that device's settings when available.

The **Status** panel on the right is supplied by the CPU plugin. This 8080 example shows registers, flags, CPU frequency,
and execution state. Other CPUs provide different controls. Drag the dividers to resize the debugger, device list,
and status panel.

### Debugger window

Use the debugger toolbar to run, pause, and step through a program while inspecting instructions and CPU state.
The instruction table and page controls are hidden during continuous execution and become available when it pauses
or stops.

Double-click an instruction with source information to open its source file at the corresponding line. The 8080 and
Z80 assemblers attach this information when compiling into memory. The file opens in an editor tab, including when it
is an included source file. Writing to an annotated address invalidates its source information, even while running;
annotations at other addresses remain available. Erasing memory removes all source positions. Saved byte-memory images
can restore positions from their `.meta` sidecars; a raw image without annotations cannot provide this navigation.

#### Debugger toolbar

The toolbar controls are numbered from left to right. Hover over a button to see its tooltip. Controls are enabled
according to the CPU's execution state and the plugins' capabilities.

{: .list .control-list}
| <span class="circle">1</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=2 y=2 %} | **Reset**. Reset the CPU, memory, and devices.
| <span class="circle">2</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=41 y=2 %} | **Jump to beginning**. Set the next instruction address to `0`; this does not reset CPU registers or memory.
| <span class="circle">3</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=73 y=2 %} | **Step back**. Move the instruction pointer to the debugger's estimated previous instruction. This does not undo execution or restore registers and memory.
| <span class="circle">4</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=105 y=2 %} | **Stop**. Stop running or paused emulation.
| <span class="circle">5</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=137 y=2 %} | **Pause**. Pause continuous or timed execution.
| <span class="circle">6</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=169 y=2 %} | **Run**. Start or resume execution from the current instruction address.
| <span class="circle">7</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=201 y=2 %} | **Timed run**. Enter the interval between instructions, in milliseconds, then run one instruction at each interval.
| <span class="circle">8</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=233 y=2 %} | **Step forward**. Execute one instruction.
| <span class="circle">9</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=272 y=2 %} | **Jump to address**. Enter the address of the next instruction to execute.
| <span class="circle">10</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=311 y=2 %} | **Breakpoint**. Set or remove a breakpoint at an address. A supported CPU pauses when it reaches that address; it must implement breakpoint support.
| <span class="circle">11</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=350 y=2 %} | **Show operating memory**. Open the memory plugin's window when available.

#### List of instructions

The instruction table shows a page of disassembled memory. Its columns come from the CPU plugin. In the 8080 example,
they show a breakpoint checkbox, address, instruction, and opcode bytes. The red row marks the next instruction.
Click a breakpoint checkbox to toggle it when supported.

The number of visible rows follows the space available in the window. To change memory contents, use the memory
plugin's window or compile another program; the instruction and opcode cells are read-only.

For CPUs with instructions of different lengths, decoding from the middle of an instruction can produce misleading
results. Memory can also contain data rather than code. The debugger estimates preceding instruction boundaries;
use a known program address when a listing looks incorrect.

#### Browsing instructions

The page controls below the table browse memory without changing the CPU's instruction pointer. Use **Current page**
to return to the next instruction after browsing elsewhere.

{: .list .control-list}
| <span class="circle">1</span> {% include control-icon.html image="/assets/application/debugger-pages.png" x=0 y=0 %} | **First page**. Start the listing at address `0`.
| <span class="circle">2</span> {% include control-icon.html image="/assets/application/debugger-pages.png" x=28 y=0 %} | **Seek backward**. Enter the number of pages to move back.
| <span class="circle">3</span> {% include control-icon.html image="/assets/application/debugger-pages.png" x=56 y=0 %} | **Previous page**. Move back one page.
| <span class="circle">4</span> {% include control-icon.html image="/assets/application/debugger-pages.png" x=84 y=0 %} | **Current page**. Show the CPU's current instruction location.
| <span class="circle">5</span> {% include control-icon.html image="/assets/application/debugger-pages.png" x=112 y=0 %} | **Next page**. Move forward one page.
| <span class="circle">6</span> {% include control-icon.html image="/assets/application/debugger-pages.png" x=140 y=0 %} | **Seek forward**. Enter the number of pages to move forward.
