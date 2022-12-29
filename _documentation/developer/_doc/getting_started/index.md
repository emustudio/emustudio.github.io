---
layout: default
title: Getting started
nav_order: 2
has_children: true
permalink: /getting_started/
---

{% include analytics.html category="developer_getting_started" %}

# Getting started

emuStudio is a Java Swing application that implements editor of virtual computer, source code editor,
and emulation "controller" (sometimes known as "debugger"). The emulation controller is used for controlling the
emulation, and also supports interaction in application GUI. Under the hood, it operates with an instance
of the so-called "virtual computer". The virtual computer - or a computer emulator - is loaded from the computer
configuration, selected by the user on the application startup.

Virtual computer is assembled from plugin object instances, possibly interconnected, according to the definition of
given computer configuration. Each plugin is a single, almost a self-contained JAR file. It means almost all
dependencies the plugin uses are present in the JAR file, except the following, which are bundled with emuStudio and
will always be available in the class-path:

- [emuLib][emulib-github]{:target="_blank"} (Maven [here][emulib-maven]{:target="_blank"})
- [ANTLR4 runtime][antlr-runtime]{:target="_blank"}
- [SLF4J logging][slf4j]{:target="_blank"}
- [Picoli][picoli]{:target="_blank"} for command-line parsing

The application provides also:

- plugin configuration management - implementation of [PluginSettings][pluginSettings]{:target="_blank"} allowing
  plugins
  to register themselves or get instances of other registered plugins
- runtime API for the communication between plugins and emuStudio application - implementation
  of [ApplicationApi][applicationApi]{:target="_blank"}

Plugins get those objects in the constructor. Details are provided in further chapters, but here can be revealed just
this: there are four types of plugins: a **compiler** (which can produce code loadable in the
emulated memory), one **CPU** emulator, one operating **memory**, and none, one or more virtual **devices**. The core
concept of
a virtual computer is inspired by the [von Neumann model][vonNeumann]{:target="_blank"}.

Each plugin implements API from emuLib, following some predefined rules. Plugin physically is compiled into a JAR file
and copied into particular subdirectory in emuStudio installation.

## GitHub repositories

From architecture perspective, emuStudio is a family of [GitHub repositories][emustudio-github-all]{:target="_blank"}, a
combination of multiple sister projects:

- [emuStudio][emustudio-github]{:target="_blank"} - application and plugins
- [emuLib][emulib-github]{:target="_blank"} - a shared run-time library used by emuStudio and plugins. Javadoc is [here][emulib-javadoc]{:target="_blank"}.
- [Edigen][edigen-github]{:target="_blank"} - CPU instruction decoder and disassembler generator based on a specification file.
- [Edigen Gradle plugin][edigen-github-gradle]{:target="_blank"}
- [CPU testing suite][cpu-testsuite-github]{:target="_blank"} - a general unit-testing framework for testing CPU plug-ins. Tests are
  specified in a declarative way.
- [emuStudio website][website-github]{:target="_blank"}


[antlr-runtime]: https://mvnrepository.com/artifact/org.antlr/antlr4-runtime/4.11.1
[slf4j]: https://mvnrepository.com/artifact/org.slf4j/slf4j-api/1.7.30
[picoli]: https://mvnrepository.com/artifact/info.picocli/picocli/4.7.0
[pluginSettings]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/PluginSettings.html
[applicationApi]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/ApplicationApi.html
[vonNeumann]: https://en.wikipedia.org/wiki/Von_Neumann_architecture

[emulib-maven]: https://search.maven.org/artifact/net.emustudio/emulib/11.5.0/jar
[emulib-github]: https://github.com/emustudio/emuLib
[emulib-javadoc]: {{ site.baseurl }}/emulib_javadoc/
[emustudio-github-all]: https://github.com/orgs/emustudio/repositories
[emustudio-github]: https://github.com/emustudio/emuStudio
[edigen-github]: https://github.com/emustudio/edigen
[edigen-github-gradle]: https://github.com/emustudio/edigen-gradle-plugin
[cpu-testsuite-github]: https://github.com/emustudio/cpu-testsuite
[website-github]: https://github.com/emustudio/emustudio.github.io
