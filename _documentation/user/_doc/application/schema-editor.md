---
layout: default
title: Computer schema
nav_order: 4
parent: emuStudio Application
permalink: /application/computer-schema
---

{% include analytics.html category="Application" %}

# Computer schema

A computer schema describes the plugins in a virtual computer and the connections between them. Each box represents
a compiler, CPU, memory, or device plugin. Arrows show which plugins can access each other's contexts.

In the [Open virtual computer dialog]({{ site.baseurl }}/application/opening-computer), select a computer and click
**Edit computer**, or click **Create new computer** to start a new configuration.

![Computer schema editor showing the MITS Altair8800 configuration and its grid spacing slider]({{ site.baseurl }}/assets/application/computer-schema-editor.png){: style="max-width: 1000px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Save & Close**. Save the configuration and close the editor. |
| <span class="circle">2</span> | **Set compiler**. Choose a compiler, then click the canvas to place it. |
| <span class="circle">3</span> | **Set CPU**. Choose a CPU, then click the canvas to place it. |
| <span class="circle">4</span> | **Set operating memory**. Choose a memory plugin, then click the canvas to place it. |
| <span class="circle">5</span> | **Add device**. Choose a device plugin, then click the canvas to add it. |
| <span class="circle">6</span> | **Add connection**. Click the source, optional intermediate points, and the destination. |
| <span class="circle">7</span> | **Bidirectional connection**. Toggle whether new connections carry data in both directions. |
| <span class="circle">8</span> | **Delete component or connection**. Select this tool, then click the item to remove. |
| <span class="circle">9</span> | **Plugin selector**. Select the plugin to place with the active component tool. |
| <span class="circle">10</span> | **Grid**. Show the grid and snap components to it. |
| <span class="circle">11</span> | **Grid spacing**. Adjust the distance between grid points. |
| <span class="circle">12</span> | **Canvas**. Place, move, and connect the computer’s plugins. |

## Editor controls

A computer can have one compiler, one CPU, one memory plugin, and multiple devices. The configurations supplied with
emuStudio combine a CPU and memory with the compiler and devices required by that computer.

Placing another compiler, CPU, or memory replaces the existing box of that type at the clicked location and reconnects
its lines to the new box. Configure the replacement plugin's settings after opening the computer.

With no drawing tool active, drag boxes to move them, or drag their borders to resize them. Drag across an empty area
to select several boxes and lines. Hold <kbd>Ctrl</kbd> or <kbd>Shift</kbd> and click boxes to extend a selection. Press <kbd>Delete</kbd>
to remove selected items. Press <kbd>Esc</kbd> to cancel the current drawing operation and clear the selection.

Use **Save & Close** to keep schema changes. Closing the editor with the window's close button discards unsaved schema
changes; grid preferences are application settings and take effect immediately.

## Connection lines

A connection grants the source plugin access to contexts published by the destination plugin. The arrow points from
the plugin requesting access to the plugin providing it. A bidirectional connection permits access in both directions.

![A one-way connection from the 8080 CPU to byte memory]({{ site.baseurl }}/assets/application/cpu-memory-connection.png)

Here the CPU can obtain the memory context to read and write memory. The reverse direction is not enabled. The plugin
implementations determine which contexts and connection directions a particular computer needs.

To draw a line, select **Add connection** and click an existing box. Move the pointer toward the destination box;
a temporary line follows it. Click empty canvas positions to add intermediate points, then click the destination box
to finish. Use clicks rather than dragging, and press <kbd>Esc</kbd> to cancel an unfinished line.

With no drawing tool active, drag an intermediate point to move it. Drag a line segment to add another point, or
right-click an existing point to remove it.
