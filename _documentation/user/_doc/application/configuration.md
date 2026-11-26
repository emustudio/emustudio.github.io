---
layout: default
title: Configuration file
nav_order: 2
parent: emuStudio Application
permalink: /application/configuration-file
---

{% include analytics.html category="Application" %}

# Configuration file

Use `emuStudio.toml` for application-wide preferences and the files in `config/` for individual computers. Set the configuration and plugin roots when you need a separate profile or plugin installation.

emuStudio reads application settings from `emuStudio.toml` at startup. By default it uses the current working directory;
run the launcher from the extracted installation directory to use its settings. The schema and source editors write
their preferences back to this file while emuStudio is running.

## Configuration and plugin roots

Set separate roots for application settings and plugins to use portable profiles or read-only installations.

| Root | Command-line option | Environment variable | Contents |
|---|---|---|---|
| Configuration | `--config-dir DIR` | `EMUSTUDIO_CONFIG_DIR` | `emuStudio.toml` and computer files in `config/` |
| Plugins | `--plugins-dir DIR` | `EMUSTUDIO_PLUGINS_DIR` | `compiler/`, `cpu/`, `memory/`, and `device/` plugin directories |

For each root, the command-line option takes precedence over its environment variable. If neither is set, emuStudio
uses the current working directory. Relative plugin paths in a computer configuration resolve below the plugin root;
absolute paths remain unchanged. You can also use these options after the `automation` subcommand.

Each computer configuration is a separate TOML file in `config/`. Manage its plugins and connections with the
[Open virtual computer dialog]({{ site.baseurl }}/application/opening-computer) or the
[schema editor]({{ site.baseurl }}/application/computer-schema).

Computer files also store watch expressions, breakpoints, and user annotations in `[debugger]`. Copy a computer's
TOML file to carry these settings to another installation. See
[Debugger inspection]({{ '/application/debugger-analysis#keep-debugger-settings-with-the-computer' | relative_url }})
to learn which controls update them.

## Application settings

| Configuration key | Possible values | Default value | Description |
|---|---|---|---|
| `useSchemaGrid` | `true` / `false` | `true` | Show the grid and snap placement and movement to it in the schema editor. |
| `schemaGridGap` | positive integer | `20` | Grid spacing in pixels; the editor's slider offers values from `5` to `100`. |
| `theme` | `"LIGHT"`, `"DARK"` | `"LIGHT"` | Window and control appearance. Unsupported values use `"LIGHT"`.   |

### Source editor preferences

Use **Edit → Indentation...** to set tab width, choose tabs or spaces, and set alignment columns. Use **Edit → Editor
display** for the display settings. New source views and later sessions use the saved preferences. Changing a display
option affects the focused view immediately. The other open views keep their current display.

| Configuration key | Possible values | Default value | Description |
|---|---|---|---|
| `editorTabSize` | from `1` to `16` | `4` | Indentation width and displayed tab width. |
| `editorSpaces` | `true` / `false` | `true` | Insert spaces instead of tab characters when indenting. |
| `editorWhitespace` | `true` / `false` | `false` | Show space and tab markers. |
| `editorIndentGuides` | `true` / `false` | `false` | Show indentation guides. |
| `editorWrap` | `true` / `false` | `false` | Wrap long lines in the source view. |

See [Source editing]({{ site.baseurl }}/application/source-editing) for the full command guide.

#### Token colors

**Edit → Editor display → Token colors** saves changed colors to top-level keys in `emuStudio.toml` when you choose
**OK**. Values are signed 32-bit ARGB integers. Omit a key to use the default color shown in the table as RGB hex.

| Token category | Configuration key | Default color |
|---|---|---|
| Reserved words | `tokenColorReserved` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #000000">&nbsp;</span> (`#000000`) |
| Identifiers | `tokenColorIdentifier` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #000000">&nbsp;</span> (`#000000`) |
| Labels / definitions | `tokenColorLabel` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #008080">&nbsp;</span> (`#008080`) |
| Directives / blocks | `tokenColorPreprocessor` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #505050">&nbsp;</span> (`#505050`) |
| Comments | `tokenColorComment` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #008000">&nbsp;</span> (`#008000`) |
| Literals | `tokenColorLiteral` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #000080">&nbsp;</span> (`#000080`) |
| Registers | `tokenColorRegister` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #800000">&nbsp;</span> (`#800000`) |
| Operators | `tokenColorOperator` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #000080">&nbsp;</span> (`#000080`) |
| Separators | `tokenColorSeparator` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #000000">&nbsp;</span> (`#000000`) |
| Errors | `tokenColorError` | <span aria-hidden="true" style="display: inline-block; width: 1em; height: 1em; box-sizing: border-box; border: 1px solid currentColor; vertical-align: middle; background-color: #FF0000">&nbsp;</span> (`#FF0000`) |
