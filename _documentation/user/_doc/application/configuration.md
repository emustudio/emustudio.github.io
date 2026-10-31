---
layout: default
title: Configuration file
nav_order: 2
parent: emuStudio Application
permalink: /application/configuration-file
---

{% include analytics.html category="Application" %}

# Configuration file

emuStudio reads application settings from `emuStudio.toml` at startup. By default it uses the current working directory;
run the launcher from the extracted installation directory to use its settings. The schema editor writes grid
preferences back to this file while emuStudio is running.

## Configuration and plugin roots

The configuration and plugin trees can have separate base directories. This is useful for read-only installations,
portable profiles, and development builds.

| Command-line option | Environment variable | Resolved content |
|---|---|---|
| `--config-dir DIR` | `EMUSTUDIO_CONFIG_DIR` | `emuStudio.toml` and the `config/` virtual-computer directory |
| `--plugins-dir DIR` | `EMUSTUDIO_PLUGINS_DIR` | `compiler/`, `cpu/`, `memory/`, and `device/` plugin directories |

For each root, the command-line option has priority over its environment variable. If neither is set, emuStudio uses
the current working directory. Relative plugin paths in a computer configuration are resolved below the selected
plugin root; absolute plugin paths remain unchanged. These options also work after the `automation` subcommand.

## Application settings

| Configuration key | Possible values | Default value | Description |
|---|---|---|---|
| `useSchemaGrid` | `true` / `false` | `true` | Show the grid and snap placement and movement to it in the schema editor. |
| `schemaGridGap` | positive integer | `20` | Grid spacing in pixels; the editor's slider offers values from `5` to `100`. |
| `theme` | `"LIGHT"`, `"DARK"`, `"INTELLIJ"` | `"INTELLIJ"` | Window and control appearance. Change the file and restart emuStudio. |

Computer configurations are separate TOML files in `config/`. Use the
[Open virtual computer dialog]({{ site.baseurl }}/application/opening-computer) and
[schema editor]({{ site.baseurl }}/application/computer-schema) to manage their plugins and connections.
