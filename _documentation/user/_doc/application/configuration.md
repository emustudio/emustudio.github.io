---
layout: default
title: Configuration file
nav_order: 2
parent: emuStudio Application
permalink: /application/configuration-file
---

# Configuration file

emuStudio uses a configuration file called `emuStudio.toml`. It can be found in the root directory of emuStudio installation.
The file is loaded just once on startup. It can be overwritten by emuStudio while running.

The following table describes possible configuration options.


|---
| Configuration key | Possible values | Default value | Description
|-|-|-|-
|`useSchemaGrid`  | `true` / `false` | `true` | Whether to show and use grid when editing computer configuration    
|`schemaGridGap`  | positive integer | 20     | Gap between grid points in pixels
|`lookAndFeel`    | quoted string    | "com.sun.java.swing.plaf.gtk.GTKLookAndFeel" | Java Look&Feel used by emuStudio 
|---
