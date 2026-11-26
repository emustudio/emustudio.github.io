---
layout: default
title: Debugger inspection
nav_order: 7
parent: emuStudio Application
permalink: /application/debugger-analysis
---

{% include analytics.html category="Application" %}

# Debugger inspection

Open **Emulator → Debugger** to inspect live instructions, set breakpoints, and label addresses. Open
**Emulator → Recording** to capture execution and inspect earlier instructions. Both views share CPU status and watches.

## Browse the instruction listing

Compile or load a program, then stop or pause execution. The listing marks the next instruction and shows disassembly,
opcode bytes, and labels. The CPU plugin determines the columns.

![8080 instruction listing with a breakpoint and numbered navigation controls]({{ site.baseurl }}/assets/application/debugger-demo-instructions.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Breakpoint row**. Bold text marks an instruction with a breakpoint. |
| <span class="circle">2</span> | **Instruction listing**. Select an address to inspect it. |
| <span class="circle">3</span> | **Page controls**. Browse memory or return to the page containing the PC. |
| <span class="circle">4</span> | **Annotation controls**. Use the search field and toolbar to find, add, edit, delete, import, or export labels and ranges. |

1. Select an instruction or use the page controls to move through the listing. The PC stays at the current instruction.
2. Use **Go to the current page** to return to the PC. Use **Jump to address** in the execution toolbar to change the PC.
3. When source mappings are available, double-click an instruction or right-click and choose **Go to source**.

The 8080 and Z80 assemblers can map compiled instructions to source lines, including lines in included files. Recompile
if the source or loaded code has changed. A raw binary image provides disassembly without compiler source mappings.

Use **Fold identical repeats** to collapse consecutive identical instructions. Expand a folded row to inspect its
individual addresses. Labels and breakpoints help preserve boundaries in the listing. Follow observed branch arrows to
explore execution paths as they appear.

See [the memory window]({{ '/altair8800/byte-mem' | relative_url }}) for byte-memory search, bank selection, and editing.

## Set and clear breakpoints

A breakpoint stops the CPU before the instruction at its address. Resume with **Run** to pass that breakpoint once.

1. Pause the CPU and find the instruction.
2. Right-click the row and choose **Set breakpoint**. To enter an address directly, choose **Set breakpoint…** in the
   execution toolbar and then choose **Set**.
3. Run the program. When execution reaches the address, inspect the instruction and CPU status.
4. Right-click the row and choose **Unset breakpoint**, or enter its address in **Set breakpoint…** and choose **Unset**.

For breakpoint behavior in command-line runs, see [Automation]({{ '/application/automation#modes' | relative_url }}).

## Label instructions and data

Annotations attach a label and type to a single address or inclusive range. **Code** marks instructions and **Data**
marks bytes to treat as data in the listing.

1. Select the instruction or address you want to label.
2. Choose **Annotate inspected address**. Set **From**, **To**, **Label**, and **Type**, then choose **Save**.
3. Use the annotation search field to find a label. Select a result to return to its address.

Use **Edit selected annotation** or **Delete selected annotation** to update a range. **Open annotations** imports
a properties file and skips duplicates. **Save annotations** exports ranges, labels, and types for sharing.
Export files use `annotation.N.address`, `annotation.N.end`, `annotation.N.label`, and `annotation.N.kind`.

## Watch registers and memory

Add expressions to **Watches** for values you need while stepping. The panel evaluates them using the selected CPU
and its memory mapping.

![Watches toolbar and table with register and memory expressions]({{ site.baseurl }}/assets/application/debugger-demo-watches.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Add watch**. Open the dialog and enter an expression. |
| <span class="circle">2</span> | **Remove watch**. Delete the selected expression. |
| <span class="circle">3</span> | **Refresh**. Re-evaluate watches at the current stop. |
| <span class="circle">4</span> | **Show watch help**. Check the expression syntax and the CPU's register names. |
| <span class="circle">5</span> | **Expressions and values**. Double-click an expression to edit it. Right-click a value to choose its format. |

1. Choose **Add watch**, enter an expression such as `A`, and choose **Add**.
2. Step the CPU. Check the value and the **changed** indicator.
3. Right-click the value to choose an available format. Hexadecimal is the default. Options can include decimal, octal,
   binary, and ASCII.

| Expression | Example on the 8080 |
|:--|:--|
| `A` or `reg(A)` | Read the accumulator. |
| `mem[0x8000]` | Read one byte at CPU address `0x8000`. |
| `mem16[0x8000]` or `mem16be[0x8000]` | Read a little-endian or big-endian word. |
| `(mem[0x8000] & 1) != 0` | Test whether bit 0 is set. |

Watches refresh on steps and stops, or when you refresh a paused CPU. An invalid expression shows **Inactive** with a reason.

### Keep debugger settings with the computer

emuStudio saves watch expressions, breakpoints, and annotations in the computer configuration under `[debugger]`.
Reopen the same configuration to restore them. Keep a copy of its TOML file if you want to carry those settings
to another installation.

## Record executed instructions

Record a run when you need to see what already happened. The recording contains the instructions captured by the CPU
and any register and memory-access details it provides.

### Capture a run

Use **Start recording** for a recent buffer. Use **New recording** to set a range, choose a different retention policy,
or write the capture to a file.

1. Open **Emulator → Recording**. For a custom capture, choose **New recording** and prepare its settings.
2. Select the prepared recording and choose **Start recording**. With no prepared recording selected, the button
   starts a buffer for the last 1,000 instructions.
3. Use the execution toolbar to run or step. The recording table fills as instructions execute.
4. Choose **Stop recording** to finish the capture. Choose **Save recording** to export a completed capture as
   an `.emutrace` file, or **Open recording** to inspect an existing file.

In **New recording**, choose **First** to stop capture at the limit, **Last** to keep the most recent instructions,
or **Until stopped (to file)** to stream to an `.emutrace` file. Enable **Specific address range** to capture instructions
within an inclusive range. **Pause recording** suspends capture while leaving the CPU controls available.

### Inspect recorded state

![Recording with numbered controls, an instruction table, the page address range, and recorded state]({{ site.baseurl }}/assets/application/debugger-demo-history.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Recording actions**. Create, open, save, start, pause, or stop a recording. |
| <span class="circle">2</span> | **Recording selector and actions**. Select, rename, or remove a recording from the list. |
| <span class="circle">3</span> | **Recorded instructions**. The table shows the address, step, and changes for each recorded instruction. |
| <span class="circle">4</span> | **Recording page**. Use the buttons on the left to browse longer recordings. The right side shows the first and last instruction addresses on the current page. |
| <span class="circle">5</span> | **Recorded state**. Read captured values and follow memory navigation links. |

1. Select a recording, then select an instruction in its table.
2. Read the recorded state and memory accesses below the table. Use **Show unchanged values** to include unchanged
   registers when the recording provides them.
3. Select a memory navigation link and use **Find previous write** to trace an earlier write to that address.

Viewing a recording leaves the live emulator state in place. CPU and memory details vary by computer.
**Edit recording** changes the selected entry's display name. **Delete recording** removes the entry from the list
and keeps any saved file on disk.
