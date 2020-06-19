---
layout: default
title: Documenting
nav_order: 3
parent: Getting started
permalink: /getting_started/documenting
---

# Documenting

There are two types of documentation - user and developer. Only the current version of the documentation is maintained.
Older versions can be accessed from git. Both types of documentation use separate Jekyll static
site project. The structure of the documentation is as follows:

```
_documentation
  |
  + developer
  |  + ... jekyll static site ...
  + user
     + ... jekyll static site ...
```

Based on the type of documentation, you can navigate to the right place where to contribute. The documentation
is built manually, not by GitHub pages. The reason for having separate Jekyll projects is that the documentation
uses a different template than the main web site, and those cannot be combined easily.

When you update the documentation, please run script:

```
_documentation/build.sh
```

which will generate the sites in the correct place, where the main web site will recognize it. Commits should include
rendered documentation as well. 

## User documentation

Plugins are usually part of virtual computers. Therefore, virtual computers are "chapters" in the documentation in a
separate directory (e.g. `_documentation/user/0.40/altair8800`, and plugins are described there, in a separate file (e.g.
`standard-mem.md`). The documentation of virtual computer should document all possible configurations, and all possible
plugins, even if their use is optional (which should be documented as well).

User documentation should focus on the interaction part with the user of emuStudio, and should not go in details
of what's going under the hood. Keep the information useful. Do not bloat text with obvious.
 
### Structure 
 
Virtual computer documentation should start with a short introduction:

- How the computer is related to computer history?
- Is it abstract or real?
- The purpose of the computer
- Possible computer configurations
- Comparison of features which are supported vs. features of real computer

Then, every plug-in should be described, in a separate file, in the following order:
 
- compiler ("programming language" tutorial)
- CPU
- memory
- devices

The last chapters should be devoted to emulation automation and debugging problems (e.g. how to do some analysis when
something doesn't work).

## Developer's documentation

Developer documentation (as you read this one) focuses on introducing new contributors to emuStudio internals and plugin
development. You can contribute by fixing or extending the existing plugin. 

Developer documentation of a particular plugin is optional. The reason is that plugin documentation will not be
published separately, just as part of the documentation of the whole computer.
 
In the developer documentation, only technical details should be explained, not the structure of the plugin code. Majority
of things which the documentation should include are the "why"s instead of "how"s.
