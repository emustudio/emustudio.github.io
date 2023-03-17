---
layout: default
title: Display "ssem-display"
nav_order: 4
parent: SSEM
permalink: /ssem/ssem-display
---

{% include analytics.html category="SSEM" %}

# SSEM Display

SSEM computer used CRT memory (see [ssem-mem][ssem-mem]), so memory cells were actually visible due to phosphorescent electrons
glow in the vacuum tube. In emuStudio there are two plugins, separating the functionality of memory and display.
 
[At this link][crt]{:target="_blank"} can be seen the original computer.

## Graphical User Interface (GUI)

GUI window of the SSEM display in emuStudio is depicted below:

![SSEM Display GUI sample look]({{ site.baseurl }}/assets/ssem/ssem-display.png)

It doesn't do any user interaction except displaying. Controlling the memory values can be interactively done
in the [ssem-mem][ssem-mem] plugin.

[crt]: http://www.davidsharp.com/baby/
[ssem-mem]: {{ site.baseurl }}/ssem/ssem-mem
