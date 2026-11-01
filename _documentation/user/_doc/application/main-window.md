---
layout: default
title: Main window
nav_order: 5
parent: emuStudio Application
permalink: /application/main-window
---

{% include analytics.html category="Application" %}

# Main window

After opening a computer, the main window provides a source code editor and a **Debugger** tab. The editor tab shows
the active source filename, or **Source code editor** when no file is selected.

The **File** and **Edit** menus provide file and text operations. **Project** contains compilation, a view of the
computer schema, and compiler settings. **Help** contains information about emuStudio. The application's
[theme setting]({{ site.baseurl }}/application/configuration-file) controls the appearance of windows and controls.

## Source code editor

![Source editor showing reverse.asm and successful compilation output for the Intel 8080 assembler]({{ site.baseurl }}/assets/application/source-code-editor.png){: style="max-width: 1094px; width: 100%;" }

Write programs in the editor and compile them with the computer's compiler plugin. The compiler determines the input
language and must produce code compatible with the selected CPU.

The toolbar provides **New**, **Open**, **Save**, undo/redo, cut/copy/paste, find, replace, and **Save & Compile source file**.
Compilation messages appear in the pane below the editor. Drag the divider to adjust its height.

The source code editor supports the following features:

- bundled **JetBrains Mono NL** font
- line numbering and syntax highlighting
- undo/redo
- inline search/replace, selection search, and find/replace across files
- cut/copy/paste text
- multiple carets, rectangular editing, folding, bookmarks, and split views
- text transformations, editing macros, navigation history, and compiler-supported rename and extraction
- whitespace and indentation settings and token colors
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

Click **Save & Compile source file** to save and compile the selected source file. Save other modified tabs first so included files
are read from their current contents on disk. The compiler output pane shows compilation messages and points to source
positions supplied by the compiler. Stop running emulation before compiling.

Compiled code can produce a binary file (for example a HEX file) and is loaded into operating memory by the compiler.
**Save & Compile source file** resets the memory plugin before invoking the compiler and resets the CPU afterwards.
Memory contents
then depend on the memory plugin's reset behavior and the compiler: the 8080 and Z80 assemblers write generated
addresses, while BrainDuck, RAM, RASP and SSEM compilers clear their program memory before loading successful output.

## Debugger tab

![Debugger workspace with Instructions selected and CPU status, watches, and devices on the right]({{ site.baseurl }}/assets/application/debugger-workspace.png){: style="max-width: 1280px; width: 100%;" }

The left workspace has **Instructions**, **Memory**, **Annotations**, **Breakpoints**, **References** and **History**
tabs. **Instructions** disassembles memory using the CPU plugin; switch tabs to search or compare bytes, annotate
addresses, manage breakpoint rules, follow references, or inspect recorded instructions.

The right column holds the CPU plugin's status/register panel, expression watches, and **Peripheral devices**, in that
order. Select a device and click **Show device**, or double-click it, to open its GUI when supported. **Show settings**
opens that device's settings when available. Drag the dividers to resize the workspace and sections of the right column.
Each CPU supplies its own registers, flags, execution-state display and other status controls.

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
| <span class="circle">1</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=0 y=0 %} | **Run**. Start or resume execution from the current instruction address.
| <span class="circle">2</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=32 y=0 %} | **Pause**. Pause continuous or timed execution.
| <span class="circle">3</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=64 y=0 %} | **Stop**. Stop running or paused emulation.
| <span class="circle">4</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=96 y=0 %} | **Timed run**. Enter the interval between instructions, in milliseconds, then run one instruction at each interval.
| <span class="circle">5</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=128 y=0 %} | **Step forward**. Execute one instruction.
| <span class="circle">6</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=166 y=0 %} | **Reset**. Reset the CPU, memory, and devices.
| <span class="circle">7</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=198 y=0 %} | **Jump to beginning**. Set the next instruction address to `0`; this does not reset CPU registers or memory.
| <span class="circle">8</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=230 y=0 %} | **Move PC Back**. Move the instruction pointer to the debugger’s estimated previous instruction. This does not undo execution or restore registers, memory, or devices.
| <span class="circle">9</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=262 y=0 %} | **Jump to address**. Enter the address of the next instruction to execute.
| <span class="circle">10</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=300 y=0 %} | **Set breakpoint / inspect address...**. Open **Set breakpoint** to set or unset an address breakpoint, or choose **Inspect only** to view its live bytes. **Keep inspection while stepping** retains a breakpoint’s inspected address. Use the **Breakpoints** tab for named rules and watchpoints. Pause before editing.
| <span class="circle">11</span> {% include control-icon.html image="/assets/application/emulator-debugger-toolbar.png" x=332 y=0 %} | **Show operating memory**. Open the memory plugin’s window when available.

#### Inspection pane

Pause the CPU to inspect memory, search for bytes, integers or text, compare captures, and edit labels, comments,
bookmarks or breakpoints. Select **References** for static flow and incoming references, or **History** for recorded
instructions. Watches remain beside CPU status while switching between inspection tabs. Available features depend on
the CPU and memory plugins. All bundled CPUs provide recording; exposed registers and memory-access detail vary by CPU.

Selecting an instruction updates the inspection address. Browsing changes neither the program counter nor the CPU’s
selected memory bank. A breakpoint hit opens **Memory** at its address; **Keep inspection while stepping** retains that
selection across subsequent steps. History records recent execution, saves continuous recordings, and opens saved recordings
for inspection without restoring the live machine.
See [Debugger inspection]({{ '/application/debugger-analysis' | relative_url }}) for workflows, persistence and metadata export.

#### List of instructions

The instruction table shows a page of disassembled memory. Its columns come from the CPU plugin. In the 8080 example,
they show a breakpoint control, address, instruction, and opcode bytes, followed by user labels and comments. The red
row marks the next instruction. Click the breakpoint control to cycle through off, enabled, and enabled with inspection
kept while stepping. A further click removes it. Hover over the control to see its current state.

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
