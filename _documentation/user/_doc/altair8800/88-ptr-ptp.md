---
layout: default
title: Paper tape reader and punch
nav_order: 12
parent: MITS Altair8800
permalink: /altair8800/88-ptr-ptp
---

{% include analytics.html category="Altair8800" %}

# Paper tape reader and punch

Use **Reader** to feed a file from your computer to an Altair program. Use **Punch** to save bytes that the program
writes. Both tabs are in the **Altair PTR/PTP** window. Open it from **Emulator → Peripheral devices** by selecting
**Altair PTR/PTP** and choosing **Show device…**.

The `88-ptr-ptp` plugin transfers bytes as stored. A `.hex` file reaches the guest as Intel HEX text, ready for a
guest program that understands that format.

## Feed a file to the reader

Load the tape before starting the guest program that reads it. The reader tracks how many bytes the guest has consumed.

![Reader tab with numbered file selection, status, and tape controls]({{ site.baseurl }}/assets/altair8800/88-ptr-ptp-gui-reader.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Directory**. Shows the folder currently listed. |
| <span class="circle">2</span> | **Select directory**. Browse to the folder containing the tape file. |
| <span class="circle">3</span> | **Available tapes**. Lists readable `.pt`, `.bin`, and `.hex` files in that folder. |
| <span class="circle">4</span> | **Refresh**. Reread the folder after adding or renaming a file. |
| <span class="circle">5</span> | **Load**. Attach the selected file and start at its first byte. |
| <span class="circle">6</span> | **Reader status**. Shows the attached file and its state. The progress bar below counts bytes read. |
| <span class="circle">7</span> | **Rewind**. Return to the start of the attached tape. |
| <span class="circle">8</span> | **Eject**. Detach the tape. |

1. On **Reader**, choose **Select directory** and open the folder that contains your file.
2. Select the file and choose **Load**. For a nonempty tape, the reader shows **Ready** and starts at zero bytes read.
3. Run the guest program. The byte count advances as it reads. The reader shows **Read complete** when the program has
   consumed the last file byte.

To read the same tape again, choose **Rewind** or reset the virtual computer. Choose **Load** again to pick up changes
to the host file, since rewinding reuses the bytes already loaded. To remove a tape, choose **Eject**.

## Capture a file with the punch

Choose the output file before running the guest program. The punch writes each byte to that file as it arrives.

{: .warning}
Choosing an existing file in **Save tape** erases its contents immediately. Use a new filename for each capture.

![Punch tab with numbered output status and file controls]({{ site.baseurl }}/assets/altair8800/88-ptr-ptp-gui-punch.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Punch status**. Shows the output path and whether the punch is ready. |
| <span class="circle">2</span> | **Save tape**. Create the output file or replace its existing contents. |
| <span class="circle">3</span> | **Close output**. Close the file and stop capturing bytes. |

1. Switch to **Punch**, choose **Save tape**, and select the output path. Check that the punch shows **Ready**.
2. Run the guest program that writes to the punch.
3. When the program finishes, choose **Close output**. The punch shows **No output tape**, and the captured file is
   available at the path you chose.

Resetting the virtual computer rewinds the reader and leaves the punch file open. Close the output before starting a
new capture if you want each run in its own file.

## Open the window at startup

In **Emulator → Peripheral devices**, select **Altair PTR/PTP** and choose **Show settings…**. Enable
**Show GUI at startup**, then choose **Save**. The window opens the next time the computer starts with a GUI.

![Paper tape settings with numbered startup preference, fixed CPU ports, and Save button]({{ site.baseurl }}/assets/altair8800/88-ptr-ptp-settings.png)

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Show GUI at startup**. Open the reader and punch window when the computer starts with a GUI. |
| <span class="circle">2</span> | **CPU ports**. Shows the fixed status and data port addresses. |
| <span class="circle">3</span> | **Save**. Apply the startup preference. |

The corresponding TOML setting is `showGuiAtStartup`. It defaults to `false`.

## Program the CPU ports

The reader and punch share a fixed port pair. On a custom Altair, connect `88-ptr-ptp` to the CPU and reserve both ports.

| Port | Read with `IN` | Write with `OUT` |
|:--|:--|:--|
| `12h` | Bit 0 indicates an attached reader whose end-of-tape state is clear. Bit 1 is always set. | Write `03h` to clear the reader's end-of-tape state while keeping its current position. |
| `13h` | Read the next reader byte. | Write one byte to the attached punch file. With no output file attached, the byte is discarded. |

After the guest consumes the last file byte, status bit 0 stays set until the next read from `13h`. That read returns
`1Ah` and clears bit 0. Later reads return `00h`. A reader with no tape attached also returns `00h`.
If the reader is already at the end, writing `03h` to `12h` makes the next data read return `1Ah` again.
Rewind or reset the computer to return to the first byte.

For guest-controlled attachment or headless runs, connect `simh-pseudo` to the reader and punch as well as to
the CPU and memory. See [SIMH paper tape commands]({{ site.baseurl }}/altair8800/simh-pseudo#paper-tape-commands-3-5-16-17)
for the attach, detach, and rewind operations. The [Original software guide]({{ site.baseurl }}/altair8800/software)
explains how CP/M programs use them to transfer files.
