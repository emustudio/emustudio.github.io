---
layout: default
title: Configuration file
nav_order: 2
parent: emuStudio Application
permalink: /application/configuration-file
---

{% include analytics.html category="Application" %}

# Configuration file

emuStudio uses a configuration file called `emuStudio.toml`. By default it can be found in the root directory of the
emuStudio installation.
The file is loaded just once on startup. It can be overwritten by emuStudio while running.

## Configuration and plugin roots

The configuration and plugin trees can have separate base directories. This is useful for read-only installations,
portable profiles, and development builds.

|---
| Command-line option | Environment variable | Resolved content
|-|-|-
|`--config-dir DIR` | `EMUSTUDIO_CONFIG_DIR` | `emuStudio.toml` and the `config/` virtual-computer directory
|`--plugins-dir DIR` | `EMUSTUDIO_PLUGINS_DIR` | `compiler/`, `cpu/`, `memory/`, and `device/` plugin directories
|---

For each root, the command-line option has priority over its environment variable. If neither is set, emuStudio uses
the current working directory. Relative plugin paths in a computer configuration are resolved below the selected
plugin root; absolute plugin paths remain unchanged. These options also work after the `automation` subcommand.

The following table describes possible configuration options.

|---
| Configuration key | Possible values | Default value | Description
|-|-|-|-
|`useSchemaGrid`  | `true` / `false` | `true` | Whether to show and use grid when editing computer configuration    
|`schemaGridGap`  | positive integer | 20 | Gap between grid points in pixels
|`lookAndFeel`    | quoted string | "com.sun.java.swing.plaf.gtk.GTKLookAndFeel" | Java Look&Feel used by emuStudio
|---
