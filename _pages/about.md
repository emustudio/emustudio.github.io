---
layout: default
title: About
permalink: /about/
---

{% include analytics.html category="root" %}

# Why another emulator?

{:.lead}
A long time ago at [Technical University of Košice][tuke]{:target="_blank"} ([Slovakia][tukesk]{:target="_blank"}) far,
far away...

During initial lessons of assembly language, my classmates and I were introduced to vintage computers. We had to
create simple programs for Intel 8080, but we had to do it by hand on a paper! There weren't good emulators that
allowed simple 'compile-load-emulate' workflows.

Project _emuStudio_ started in 2006 as a school project, then a master thesis, created by
[Peter Jakubčo][peterj]{:target="_blank"}. I had continued to work on it afterward, giving it my limited free time.

Supervisor of the school project was [Slavomír Šimoňák][slavos]{:target="_blank"}, who could be understood as the
first "product owner". I remember the times with nostalgia. Lots of good ideas came from discussions between us.

The gaps which emuStudio want to fill up are as follows.

### Support academic process

emuStudio can be used as a tool used in classes at schools. Teachers can use it for presenting vintage computers, or
demonstrating working code running on emulated computers.

Students can get programming assignments for vintage computers. The output of the assignments can be generated
automatically using emulation automation.

emuStudio is also a great as a base platform for school projects for writing custom vintage computer emulators, or
extending existing ones.

### Support enthusiasts

I know some guys who know how to program Z80, and they are missing it! Wouldn't it be wonderful if they had a platform
which allowed them to enjoy their guilty pleasure? It is one of goals of emuStudio - be able to realize a desire to
write some new piece of vintage software or a game. With emuStudio, it should be easy to execute the software on modern
devices.

# Contributing

Everybody *please* contribute. Statistics show that students are the main contributors, but from time-to-time,
some unknown contributor appears.

How can you contribute? It's simpler than you think:

- Provide a feedback to [the author](mailto:pjakubco@gmail.com) or
  the [developer group](mailto:emustudio@googlegroups.com)
- Fill
  an [issue/bug on GitHub](https://github.com/emustudio/emuStudio/issues/new?assignees=&labels=&template=bug_report.md&title=){:target="_blank"}
- Request
  a [feature](https://github.com/emustudio/emuStudio/issues/new?assignees=&labels=&template=feature_request.md&title=){:target="_blank"}
- Fix a bug
- Implement a feature
- Implement emulator of a new computer
- Support the project [financially](https://github.com/sponsors/vbmacher){:target="_blank"} (it's a free time project)

## Getting help

If you are seeking for a help with emuStudio, you have two options. The preferred way is to raise
an [issue at GitHub](https://github.com/emustudio/emuStudio/issues/new/choose){:target="_blank"}.
The second option is to write an email to the [developer group](mailto:emustudio@googlegroups.com).

Responses to the issues/emails might be slow, as this project is still mostly a one-person show, and it's a
hobby project. Thank you for understanding.

## Important note

emuStudio is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either [version 3][gpl3]{:target="_blank"} of the License, or
(at your option) any later version.

emuStudio is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.


[mame]: https://www.mamedev.org/
[simh]: https://github.com/simh/simh
[peterj]: https://github.com/vbmacher
[slavos]: https://kpi.fei.tuke.sk/sk/person/slavomir-simonak
[tuke]: https://www.tuke.sk
[tukesk]: https://goo.gl/maps/9hoGFpr5q17GxF9M6
[gpl3]: https://www.gnu.org/licenses/gpl-3.0.html
