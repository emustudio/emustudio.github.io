---
layout: default
title: Debugger inspection
nav_order: 8
parent: emuStudio Application
permalink: /application/debugger-analysis
---

# Debugger inspection

![8080 program paused at 0100, with instruction labels, CPU registers and memory watches]({{ site.baseurl }}/assets/application/debugger-demo-instructions.png)

Open **Debugger** after compiling or loading a program. Pause to inspect or edit state. Selecting an instruction changes
the inspected address; the PC stays put. Drag dividers to resize the workspace.
8080/Z80 support registers, watchpoints and recording; other CPUs depend on their plugins.

<details markdown="1">
<summary>8080 example used in these screenshots</summary>

Compile this program with **MITS Altair8800**. It writes `41 42` at `8000` and calls a subroutine.
Screenshot addresses and bytes are hexadecimal.

```text
org 100h
lxi sp,9000h
mvi a,41h
sta 8000h
call increment
hlt
increment: inr a
sta 8001h
ret
org 8000h
db 0,0
org 8100h
db 'HELLO DEBUGGER',0
```

</details>

## Inspect an address

![Set breakpoint dialog targeting 0x8000 in bank 0, with Inspect only, Unset and Set buttons]({{ site.baseurl }}/assets/application/debugger-demo-inspect.png){: style="max-width: 332px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Address**. Enter the decimal or hexadecimal address to inspect. |
| <span class="circle">2</span> | **Bank**. Select the memory bank to inspect; this does not change the CPU’s bank. |
| <span class="circle">3</span> | **Keep inspection while stepping**. Keep the breakpoint’s inspected address as you step. |
| <span class="circle">4</span> | **Inspect only**. Inspect the live bytes without setting a breakpoint. |
| <span class="circle">5</span> | **Unset**. Remove the breakpoint at this address. |
| <span class="circle">6</span> | **Set**. Set an execution breakpoint at this address. |

Choose **Set breakpoint / inspect address...**, enter `0x8000`, then **Inspect only** to open live memory.
**Bank** selects inspection memory without switching the CPU's bank; common memory uses physical bank zero.
**Set** adds an execution breakpoint; hitting it opens **Memory**. With **Set**, enable **Keep inspection while stepping**
to retain the inspected address during later steps. Instruction-table breakpoint controls cycle through off, enabled
and keep-inspection states.

## Memory and annotations

### Find bytes, integers or text

![Byte search for 41 42 finds one match at 8000, labeled output]({{ site.baseurl }}/assets/application/debugger-demo-search.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Search type**. Search for byte patterns, integers, or text. |
| <span class="circle">2</span> | **Search value**. Enter the pattern, integer, or text to find. |
| <span class="circle">3</span> | **Find**. Capture memory and search the selected bank. |
| <span class="circle">4</span> | **Previous result**. Select the preceding match. |
| <span class="circle">5</span> | **Next result**. Select the following match. |
| <span class="circle">6</span> | **Rescan**. Filter existing candidates against a new memory capture. |
| <span class="circle">7</span> | **Live memory**. Return to the current live bytes. |
| <span class="circle">8</span> | **Compare / strings**. Show string scanning and baseline tools. |
| <span class="circle">9</span> | **Find strings**. Find ASCII strings in a memory capture. |
| <span class="circle">10</span> | **Capture baseline**. Save a baseline for later comparisons. |
| <span class="circle">11</span> | **Compare baseline**. Show bytes that differ from the baseline. |
| <span class="circle">12</span> | **Results**. Inspect matching addresses, captured values, strings, or baseline differences. |

After running the example, choose **Bytes**, enter `41 42`, then **Find**. Wildcards work too: `3E ?? 32` or `A? ?F`.
**Integer** supports widths of 1, 2, 4 or 8 bytes and either byte order; **Text** uses UTF-8.

**Rescan** filters previous matches by Changed, Equal, Increased or Decreased, retaining the original bank, width and byte
order. Results show captured bytes; **Live memory** returns to current bytes.

### Compare before and after execution

![Baseline comparison shows 41 at 8000, 42 at 8001, and return-address bytes at 8FFE and 8FFF]({{ site.baseurl }}/assets/application/debugger-demo-compare.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Search type**. Search for byte patterns, integers, or text. |
| <span class="circle">2</span> | **Search value**. Enter the pattern, integer, or text to find. |
| <span class="circle">3</span> | **Find**. Capture memory and search the selected bank. |
| <span class="circle">4</span> | **Previous result**. Select the preceding match. |
| <span class="circle">5</span> | **Next result**. Select the following match. |
| <span class="circle">6</span> | **Rescan**. Filter existing candidates against a new memory capture. |
| <span class="circle">7</span> | **Live memory**. Return to the current live bytes. |
| <span class="circle">8</span> | **Compare / strings**. Show string scanning and baseline tools. |
| <span class="circle">9</span> | **Find strings**. Find ASCII strings in a memory capture. |
| <span class="circle">10</span> | **Capture baseline**. Save a baseline for later comparisons. |
| <span class="circle">11</span> | **Compare baseline**. Show bytes that differ from the baseline. |
| <span class="circle">12</span> | **Results**. Inspect matching addresses, captured values, strings, or baseline differences. |

Open **Compare / strings** and **Capture baseline** before running. Pause, then **Compare baseline**.
Here, `STA` changed `8000–8001`; `CALL` left its return address at `8FFE–8FFF` after `RET` restored SP.
**Compare binary** accepts a full-size raw image of the inspected bank. Baseline capture preserves annotations.

### Find readable strings

![String scan finds HELLO DEBUGGER at 8100 and shows its message label]({{ site.baseurl }}/assets/application/debugger-demo-strings.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Search type**. Search for byte patterns, integers, or text. |
| <span class="circle">2</span> | **Search value**. Enter the pattern, integer, or text to find. |
| <span class="circle">3</span> | **Find**. Capture memory and search the selected bank. |
| <span class="circle">4</span> | **Previous result**. Select the preceding match. |
| <span class="circle">5</span> | **Next result**. Select the following match. |
| <span class="circle">6</span> | **Rescan**. Filter existing candidates against a new memory capture. |
| <span class="circle">7</span> | **Live memory**. Return to the current live bytes. |
| <span class="circle">8</span> | **Compare / strings**. Show string scanning and baseline tools. |
| <span class="circle">9</span> | **Find strings**. Find ASCII strings in a memory capture. |
| <span class="circle">10</span> | **Capture baseline**. Save a baseline for later comparisons. |
| <span class="circle">11</span> | **Compare baseline**. Show bytes that differ from the baseline. |
| <span class="circle">12</span> | **Results**. Inspect matching addresses, captured values, strings, or baseline differences. |

Choose **Find strings** under **Compare / strings**. It finds printable ASCII runs of at least four bytes,
including `HELLO DEBUGGER` at `8100`. Displayed text comes from the scan's capture.

### Label and bookmark addresses

![Annotation editor labels bank 0 address 8000 as output, marks it DATA and bookmarks it]({{ site.baseurl }}/assets/application/debugger-demo-annotations.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Filter**. Find annotations by their text. |
| <span class="circle">2</span> | **Bookmarks only**. Show bookmarked annotations. |
| <span class="circle">3</span> | **Go to annotation**. Navigate to the selected entry. |
| <span class="circle">4</span> | **Delete**. Remove the selected annotation. |
| <span class="circle">5</span> | **Annotate inspected address**. Start an annotation at the current inspected address. |
| <span class="circle">6</span> | **Label**. Enter the address label. |
| <span class="circle">7</span> | **Comment**. Enter the address comment. |
| <span class="circle">8</span> | **Kind**. Mark the address as code, data, or unspecified. |
| <span class="circle">9</span> | **Bookmark**. Mark this annotation for quick retrieval. |
| <span class="circle">10</span> | **Save annotation**. Save edits at the displayed editing address. |
| <span class="circle">11</span> | **Export annotations**. Save the annotation metadata. |
| <span class="circle">12</span> | **Import**. Read annotations from a saved file. |
| <span class="circle">13</span> | **Clear annotations**. Remove all annotations from this image. |
| <span class="circle">14</span> | **Export memory and metadata**. Save the captured bytes and their annotation sidecar. |

Inspect `0x8000`, open **Annotations**, then **Annotate inspected address**. Enter `output`, choose **DATA**, enable
**Bookmark**, then **Save annotation**. Check **Editing bank N:ADDR**; browsing leaves this edit target unchanged.
Use **Filter**, **Bookmarks only** and **Go to annotation** to revisit entries.

Annotations persist beside the computer configuration, bound to a captured image and bank layout. After loading another
program, **Take snapshot** saves the old annotations and loads those matching the new capture. **Save**/**Import** transfer
metadata for the same image. Compiler source mappings remain separate.

## Watches and breakpoints

### Watch registers and memory

![Watches show A as 0x42, SP as 0x9000, bytes 0x41 and 0x42, and their little-endian word 0x4241]({{ site.baseurl }}/assets/application/debugger-demo-watches.png){: style="max-width: 355px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Expression**. Enter a register or memory expression. |
| <span class="circle">2</span> | **Add watch**. Add the expression to the watch list. |
| <span class="circle">3</span> | **Format**. Choose how watch values are displayed. |
| <span class="circle">4</span> | **Watch list**. Inspect values in the selected bank; changed values remain marked until the next stop. |

Enter an **Expression** and choose **Add**. Watches use the inspection bank. Choose **Hex + decimal**, **Binary** or **ASCII**;
changed values receive a marker. **Follow value** opens the evaluated address. **Edit register** reveals **Write register**.

| Expression | Meaning |
|---|---|
| `A` or `reg(A)` | Accumulator. |
| `mem[0x8000]` | Byte: `0x41` after execution. |
| `mem16[0x8000]` | Little-endian word: `0x4241`. |
| `mem16be[0x8000]` | Big-endian word: `0x4142`; `mem32`/`mem32be` read four bytes. |
| `(mem[0x8000] & 1) != 0` | Test bit 0. Arithmetic, shifts, comparisons and short-circuit `&&`/`||` are supported. |

### Stop on a conditional memory write

![Named WRITE rule at 0x8001 in all banks, conditioned on A == 0x42, with inspection kept while stepping]({{ site.baseurl }}/assets/application/debugger-demo-breakpoints.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Name**. Enter a descriptive rule name. |
| <span class="circle">2</span> | **Kind**. Choose execution, read, write, or source matching. |
| <span class="circle">3</span> | **Address**. Enter the address to match. |
| <span class="circle">4</span> | **Bank**. Match a selected bank or all banks. |
| <span class="circle">5</span> | **Add breakpoint**. Add the configured rule. |
| <span class="circle">6</span> | **Advanced options**. Show the condition, hit count, and inspection controls. |
| <span class="circle">7</span> | **Condition**. Evaluate this expression when the rule matches. |
| <span class="circle">8</span> | **Stop from hit**. Stop after the specified matching hit count. |
| <span class="circle">9</span> | **Keep inspection**. Keep the rule’s inspected address while stepping. |
| <span class="circle">10</span> | **Enable / disable**. Toggle the selected rule. |
| <span class="circle">11</span> | **Remove**. Delete the selected rule. |
| <span class="circle">12</span> | **Add ordinary breakpoint**. Add a simple execution breakpoint. |
| <span class="circle">13</span> | **Save settings**. Persist the breakpoint rules. |
| <span class="circle">14</span> | **Reset hit counts**. Clear the accumulated rule hits. |
| <span class="circle">15</span> | **Go to address**. Inspect the selected breakpoint’s address. |

Before rerunning, open **Breakpoints**, enter a name, choose **WRITE**, and set the address to `0x8001`. Enter condition
`A == 0x42`, leave **Bank** at `-1` and **Stop from hit** at `1`, enable **Keep inspection while stepping**, then click
**Add breakpoint**. It stops after the writing instruction. Bank `-1` matches all banks; conditions use the CPU's selected logical bank.
Each qualifying instruction counts once, even with repeated accesses.

**EXEC** stops before execution; **SOURCE** requires a file path and a one-based line with a current compiler mapping.
**READ** includes instruction fetches; **WRITE** includes attempted guest writes. Debugger reads trigger no access rules.
Named rules stay separate from instruction-table breakpoints; **Add ordinary breakpoint** creates an unconditional one.
Resuming skips the stopped EXEC/SOURCE rule once.

Use **Enable / disable**, **Remove** or **Reset hit counts** to manage rules. Watches and breakpoints persist in the computer's
`.debugger` file; **Save settings** saves them explicitly. Hit counts restart at zero when reloading.

## References, flow and history

### Follow a call

![Static reference list shows the call from 0108 to 010C beside the decoded instruction graph]({{ site.baseurl }}/assets/application/debugger-demo-references.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Analyze from address**. Decode reachable instructions from the inspected address. |
| <span class="circle">2</span> | **Find incoming references**. Search for references to the inspected address. |
| <span class="circle">3</span> | **Go to reference**. Inspect the selected reference’s address. |
| <span class="circle">4</span> | **Instruction**. Select a decoded instruction. |
| <span class="circle">5</span> | **Go to instruction**. Inspect the selected decoded instruction. |
| <span class="circle">6</span> | **References and graph**. Select a reference or graph node to inspect its address. Indirect targets may remain unresolved. |

Select `0100`, open **References**, then **Analyze from address**. The call links `0108` to `010C`.
Choose a graph node or **Go to reference**/**Go to instruction** to navigate. **Find incoming references** searches callers.
Analysis uses the CPU's active bank and at most 256 reachable instructions; indirect targets may remain unresolved.
Static references do not prove execution coverage.

### Inspect a recorded write

![Recorded instruction 010D to 0110 shows A at 42 and WRITE bank 0:8001 = 42]({{ site.baseurl }}/assets/application/debugger-demo-history.png){: style="max-width: 886px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Record**. Enable or disable the bounded instruction-history recorder. |
| <span class="circle">2</span> | **Refresh**. Reload the recorded history. |
| <span class="circle">3</span> | **Show unchanged registers**. Include registers whose values did not change. |
| <span class="circle">4</span> | **Recorded instructions**. Select an executed instruction. |
| <span class="circle">5</span> | **Recorded state**. Read the selected instruction’s registers and memory accesses; this is historical state. |

Enable **Record last 1024 instructions** while paused, then run or step. Select `010D → 0110` to see
`WRITE bank 0:8001 = 42`, register values and instruction fetches. Recording can reduce throughput and starts disabled;
history is not saved. Historical inspection leaves the live machine unchanged. **Move PC Back** changes only the PC.

## Repeatable debugger operations

Run the same check with `auto --debug-script FILE` after compiling the example:

```text
RUN 0x010B 20
ASSERT A == 0x42
ASSERT mem16[0x8000] == 0x4241
CAPTURE result.bin
```

`RUN` stops before `HLT` at `010B`, within 20 instructions. `CAPTURE` writes the selected logical bank beside the script.
Failed assertions return a nonzero exit status. See [Debug scripts]({{ site.baseurl }}/application/automation#debug-scripts)
for the command line and operation limits.

## Export memory and metadata

In **Annotations**, choose **Export memory and metadata** to write `memory-bank-N.bin` and `memory-bank-N.properties`.
The binary contains the annotation image's captured bytes, even after live memory changes. The UTF-8 properties file
records image identity, processor, bank layout, labels, comments, bookmarks and code/data kinds. **Import** requires
matching image/layout metadata. Source maps, execution history and device state are not included.
