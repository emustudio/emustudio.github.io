---
layout: default
title: SSEM
nav_order: 7
has_children: true
permalink: /ssem/
---

{% include analytics.html category="SSEM" %}

# Small Scale Experimental Machine (SSEM)

Small Scale Experimental Machine, also known as [SSEM][ssem]{:target="_blank"}, was the world's very first
stored-program computer, nicknamed "Baby". It was a predecessor of [Manchester Mark 1][mark1]{:target="_blank"} which
led to [Ferranti Mark 1][fmark1]{:target="_blank"}, the world's first commercially available general-purpose computer.

The following image shows the [SSEM CRT display][wikis]{:target="_blank"}:

![SSEM CRT]({{ site.baseurl }}/assets/ssem/ssem.jpg)

It is very simple computer, which can run only 7 instructions.

## SSEM for emuStudio

In emuStudio, SSEM computer is composed of a compiler, memory, CRT display and CPU. Abstract schema follows:

![Abstract schema of SSEM]({{ site.baseurl }}/assets/ssem/ssem-schema.png){:style="max-width:261"}


[ssem]: https://en.wikipedia.org/wiki/Manchester_Small-Scale_Experimental_Machine
[mark1]: https://en.wikipedia.org/wiki/Manchester_Mark_1
[fmark1]: https://en.wikipedia.org/wiki/Ferranti_Mark_1
[wikis]: https://commons.wikimedia.org/wiki/File:CRT_memory.jpg
