---
layout: default
title: Loading and initialization
nav_order: 1
parent: Plugin basics
permalink: /plugin_basics/loading
---

{% include analytics.html category="developer" %}

# Loading and initialization

emuStudio instantiates and initializes plugins in one thread. Each virtual computer owns one `URLClassLoader` shared
by its plugins and their dependencies. Classes and resources need unique package names within that computer.
The application and emuLib APIs are provided by the parent classloader.

## Plugin instantiation

The loader reads the plugin JARs and their manifest `Class-Path` entries and collects their URLs, removing duplicates.
It scans each plugin JAR for a concrete class implementing `Plugin` and annotated with `@PluginRoot`, then instantiates
that root with the plugin ID, application API, and settings. Manifest dependency paths are resolved from the working
directory. Keep the distribution's directory layout when launching emuStudio.

This process happens just once in the beginning, so adding another plugin at run-time is not possible. The result of
this phase is that all plugin classes are loaded in memory and all plugin roots are instantiated.

### What should plugin do in the constructor

Plugin constructor has three arguments - plugin ID, emuStudio API and plugin settings. Here, plugin can for example read
its settings, or instantiate some final objects used later. But the most important operation here is to register
so-called "plugin contexts" (if a plugin has some) into [ContextPool][contextPool]{:target="_blank"}, obtainable from
emuStudio API. Note that plugin contexts of connected plugins must NOT be obtained here - in constructor.

Another chapter talks about plugin contexts in more detail.

## Plugin initialization

After plugins are instantiated, they are being "initialized". It means just that emuStudio will
call [Plugin.initialize()][pluginInitialize]{:target="_blank"} method on each plugin. The plugin initializations are
ordered by plugin type:

1. Compiler
2. Memory
3. CPU
4. Devices in the order as they are defined in the virtual computer configuration

### What should plugin do here

The most important operation what a plugin should do in the [Plugin.initialize()][pluginInitialize]{:target="_blank"}
method is to obtain "plugin contexts" of another connected plugins. Plugin contexts can be obtained from already
mentioned [ContextPool][contextPool]{:target="_blank"} class, obtainable from emuStudio API.

## Destruction

Closing a virtual computer destroys devices in reverse configuration order, then the CPU, memory, and compiler.
It closes the shared plugin classloader and computer configuration after plugin cleanup. A plugin's `destroy()` must
release its listeners, worker threads, audio resources, and windows. Plugins must leave closing the shared classloader
to the application. Loading or construction failures also close the loader.

[contextPool]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/ContextPool.html
[pluginInitialize]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/Plugin.html#initialize()
