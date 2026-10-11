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

![Open virtual computer dialog with the MITS Altair8800 (Z80) configuration selected]({{ site.baseurl }}/assets/application/open-virtual-computer.png){: style="max-width:1110px; width: 100%;" }

The **Virtual computers** list on the left contains the configurations in the selected
[configuration root]({{ site.baseurl }}/application/configuration-file#configuration-and-plugin-roots).
Select a computer to preview its schema on the right. Drag the divider to change the space available to the list and
preview.

Click **Open computer**, double-click the selected entry, or press <kbd>Enter</kbd> to load it. **Exit** closes the dialog
without opening a computer.

## Managing virtual computers

The vertical toolbar manages computer configurations. Its controls are numbered from top to bottom:

{: .list .control-list}
| <span class="circle">1</span> {% include control-icon.html image="/assets/application/computer-management-toolbar.png" x=2 y=2 %} | **Create new computer**. Enter a name, then build its configuration in the [schema editor]({{ site.baseurl }}/application/computer-schema).
| <span class="circle">2</span> {% include control-icon.html image="/assets/application/computer-management-toolbar.png" x=2 y=32 %} | **Delete computer**. Delete the selected configuration after confirmation. This action cannot be undone.
| <span class="circle">3</span> {% include control-icon.html image="/assets/application/computer-management-toolbar.png" x=2 y=62 %} | **Edit computer**. Open the selected configuration in the schema editor.
| <span class="circle">4</span> {% include control-icon.html image="/assets/application/computer-management-toolbar.png" x=2 y=92 %} | **Rename computer**. Enter a new name for the selected configuration.
| <span class="circle">5</span> {% include control-icon.html image="/assets/application/computer-management-toolbar.png" x=2 y=122 %} | **Save schema image**. Export the displayed schema as a PNG image. This exports the picture; use the schema editor to save configuration changes.
