---
layout: default
title: Opening a computer
nav_order: 3
parent: emuStudio Application
permalink: /application/opening-computer
---

{% include analytics.html category="Application" %}

# Opening a computer

The first action that emuStudio does is loading a computer to be emulated. Virtual computers are described in abstract schemas, which are stored in configuration files.

Computers can be loaded either from the command line or manually in GUI (by default).
The "open dialog" is the first thing which appears to a user.

!["Open a computer" dialog]({{ site.baseurl}}/assets/application/open-computer.png){:style="max-width:780"}

The left part contains a control panel and a list of all available virtual computers. When a user clicks at a computer, it's abstract schema is displayed on the right. Double-clicking or clicking
on the `Open` button loads selected computer.

## Managing virtual computers

![Managing virtual computers]({{ site.baseurl}}/assets/application/open-computer-panel.png)

- *A*: Adds new computer. The abstract schema editor will be opened.
- *B*: Deletes selected computer. Be aware of what you are doing - the action cannot be undone.
- *C*: Edits selected computer. The abstract schema editor will be opened.
- *D*: Renames computer.
- *E*: Saves the displayed abstract schema into image file.
