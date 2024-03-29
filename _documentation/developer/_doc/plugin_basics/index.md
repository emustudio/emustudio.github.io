---
layout: default
title: Plugin basics
nav_order: 3
has_children: true
permalink: /plugin_basics/
---

{% include analytics.html category="developer_basics" %}

# Plugin basics

Each plugin is a separate Java module (source code can be written in any JVM language), compiled into a single JAR file.
The JAR file is then placed in the proper directory (e.g. `compiler/`, `cpu/`, `memory/`, and `device/`) in emuStudio
installation.

In the source code, plugins are located in `plugins/` subdirectory, then branched further by plugin type.

## Naming conventions

Plugin names are derived from JAR file names. A naming convention defines how the name should be picked. Each plugin
type has a different naming convention. General idea is that the JAR file name should say clearly what the plugin is
about.

A plugin JAR file name should be in the form of:

{:.code-example}
```
[specific abbreviation]-[plugin type].jar
```

where `[specific abbreviation]` means some custom abbreviation of the real world "device" the plugin emulates or is part of,
optionally preceded with the manufacturer (e.g. `intel-8080`, `adm-3A`, etc.).
Then `[plugin type]` follows, but in a form, as it is shown in the following table:

{:.table-responsive}
{:.table .table-stripped}
|---
| Plugin type | Naming convention | Examples
|-|-|-
| Compiler | `[language]-compiler` (for compiler of higher language), or `as-[cpu type]` (for assembler) | `as-8080`, `as-z80`, `brainc-compiler`, `ram-compiler`
|---
| CPU | `[cpu model]-cpu`, or `[computer type]-cpu` | `8080-cpu`, `z80-cpu`, `ram-cpu`, `brainduck-cpu`
|---
| Memory | `[some feature]-mem`, or `[computer type]-mem` | `byte-mem`, `ram-mem`, `rasp-mem`
|---
| Device | `[device model]-[device type]` | `88-dcdd`, `88-sio`, `adm3a-terminal`, `simh-pseudo`, `vt100-terminal`
|===

Plugin names can contain digits, small and capital letters (regex: `[a-zA-Z0-9]+`). Capital letters shall be used only
just for word separation (e.g. `zilogZ80`).

## Plugin structure

A plugin must contain a public class which is considered as _plugin root_. The plugin root is automatically found, then
instantiated by emuStudio, then assigned into a virtual computer and used.

A class which is to be plugin root, must:

- implement some plugin interface (i.e. [CPU][cpu]{:target="_blank"}, [Device][device]{:target="_blank"}, [Memory][memory]{:target="_blank"} or [Compiler][compiler]{:target="_blank"})
- annotate the class with [PluginRoot][pluginRoot]{:target="_blank"} annotation
- implement a public constructor with three arguments of types (`long`, [ApplicationApi][applicationApi]{:target="_blank"}, [PluginSettings][pluginSettings]{:target="_blank"})

A sample plugin root class might look like this:

{:.code-example}
```java
@PluginRoot(type = PLUGIN_TYPE.CPU, title = "Sample CPU emulator")
public class SamplePlugin implements CPU {

    public SamplePlugin(long pluginId, ApplicationApi emustudio, PluginSettings settings) {
        ...
    }

    ...
}
```

If more classes implement some plugin interface, just one of them has to be annotated with `PluginRoot`.
If there are more classes like this, the plugin might not work correctly.

The constructor parameters have the following meaning:

- `pluginId` is a unique plugin identification, assigned by emuStudio. Some operations require it as an input argument.
- `emustudio` is a runtime API implementation, provided by emuStudio application, to be used by plugins.
- `settings` are plugin's settings. A plugin can use it for reading/writing its custom or emuStudio settings.
  Updated settings are saved immediately in the configuration file, in the same thread.

## Third-party dependencies

Each plugin can depend on third-party libraries (or other plugins). In this case, the dependencies should be either
bundled with the plugin, or the location should be present in the `Class-Path` attribute in the plugin's `Manifest`
file.

Some libraries are preloaded by emuStudio and those shouldn't be included in plugin JAR file:

- [emuLib][emulib]{:target="_blank"}
- [ANTLR4 runtime][antlr-runtime]{:target="_blank"}
- [SLF4J logging][slf4j]{:target="_blank"}
- [Picoli][picoli]{:target="_blank"} for command-line parsing

Plugins that want to use the dependencies above should specify them as "provided" in the project.

## Incorporating a plugin in emuStudio

A new plugin is another Gradle submodule, which should be "registered" in `settings.gradle` file.

If a plugin is part of a new computer, the new configuration should be created (in [TOML][toml]{:target="_blank"} format)
and put in `application/src/main/files/config` directory.

Plugin can have static example files, or shell scripts. Plugin must copy them into build directory,
e.g. `plugins/compiler/as-8080/build/libs/examples` or `plugins/compiler/as-8080/build/libs/scripts`.
Then, in `application/build.gradle` are sections marked with `// Examples` or `// Scripts` comments:

{:.code-example}
```groovy
...
// Examples
["as-8080", "as-z80", "as-ssem", "brainc-brainduck", "ramc-ram", "raspc-rasp"].collect { compiler ->
    from(examples(":plugins:compiler:$compiler")) {
        into "examples/$compiler"
    }
}

// Scripts
["as-8080", "as-z80", "as-ssem", "brainc-brainduck", "ramc-ram", "raspc-rasp"].collect { compiler ->
    from(scripts(":plugins:compiler:$compiler")) {
        into "bin"
    }
}
["88-dcdd"].collect { device ->
    from(scripts(":plugins:device:$device")) {
        into "bin"
    }
}
...
```

It is necessary to put your plugin name in the particular collection.

[emulib]: https://search.maven.org/artifact/net.emustudio/emulib/11.5.0/jar
[antlr-runtime]: https://mvnrepository.com/artifact/org.antlr/antlr4-runtime/4.11.1
[slf4j]: https://mvnrepository.com/artifact/org.slf4j/slf4j-api/1.7.30
[picoli]: https://mvnrepository.com/artifact/info.picocli/picocli/4.7.0

[pluginSettings]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/PluginSettings.html
[applicationApi]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/ApplicationApi.html
[cpu]: {{ site.baseurl}}/emulib_javadoc/net/emustudio/emulib/plugins/cpu/CPU.html
[device]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/device/Device.html
[memory]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/memory/Memory.html
[compiler]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/compiler/Compiler.html
[pluginRoot]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/annotations/PluginRoot.html  
[toml]: https://github.com/toml-lang/toml/blob/master/versions/en/toml-v0.5.0.md
