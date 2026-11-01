---
layout: default
title: Opening a computer
nav_order: 3
parent: emuStudio Application
permalink: /application/opening-computer
---

{% include analytics.html category="Application" %}

# Opening a computer

Before emulation starts, select a virtual computer. Each computer has a TOML configuration describing its plugins,
their settings, and their connections.

Available virtual computers include [MITS Altair8800]({{ site.baseurl }}/altair8800/),
[ZX Spectrum 48K]({{ site.baseurl }}/zxspectrum48k/),
[Space Invaders]({{ site.baseurl }}/spaceinvaders/),
[BrainDuck]({{ site.baseurl }}/brainduck/),
[RAM]({{ site.baseurl }}/ram/),
[RASP]({{ site.baseurl }}/rasp/), and
[SSEM]({{ site.baseurl }}/ssem/).

Running emuStudio without a computer selection opens the **Open virtual computer** dialog. To select a computer from
the command line, use `-cn NAME`, `-cf FILE`, or `-ci INDEX`; `-cl` lists the available names and indexes.

![Open virtual computer dialog with the MITS Altair8800 configuration selected]({{ site.baseurl }}/assets/application/open-virtual-computer.png){: style="max-width: 900px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Create new computer**. Enter a name, then place and connect plugins in the schema editor. |
| <span class="circle">2</span> | **Delete computer**. Delete the selected configuration after confirmation. |
| <span class="circle">3</span> | **Edit computer**. Change the selected computer’s plugins, connections, and layout. |
| <span class="circle">4</span> | **Rename computer**. Change the selected configuration’s name. |
| <span class="circle">5</span> | **Save schema image**. Export the selected computer’s schema as a PNG image. |
| <span class="circle">6</span> | **Virtual computers**. Select a configuration to preview it; double-click it or press Enter to open it. |
| <span class="circle">7</span> | **Show plugin configuration**. Expand the plugin paths and settings below the schema preview. |
| <span class="circle">8</span> | **Open computer**. Load the selected virtual computer. |
| <span class="circle">9</span> | **Exit**. Close the chooser. |

The **Virtual computers** list on the left contains the configurations in the selected
[configuration root]({{ site.baseurl }}/application/configuration-file#configuration-and-plugin-roots).
Select a computer to preview its schema on the right. Drag the divider to change the space available to the list and
preview.

The panel below the schema shows the selected computer's plugin names, JAR paths, and configured settings. Its
divider adjusts the space shared with the schema preview. Use **Edit computer** to change the configuration.

Click **Open computer**, double-click the selected entry, or press <kbd>Enter</kbd> to load it. **Exit** closes the dialog
without opening a computer.
