---
layout: default
title: Source editing
nav_order: 6
parent: emuStudio Application
permalink: /application/source-editing
---

{% include analytics.html category="Application" %}

# Source editing

The **Editor** menu provides selection, text transformation, navigation, display, refactoring, and split-view commands.
Commands act on the focused source view. With no selection, line transformations such as sorting and whitespace cleanup
act on the whole file; duplicate acts on the current line.

## Multiple selections and columns

Hold **Alt** and click to add carets. **Alt+D** selects the next occurrence of selected text; **Ctrl+Shift+L** selects
all occurrences. Typing, deletion, cut, and paste act on all selections in one undo step. Arrow keys move all carets;
**Escape** clears additional selections. Copy joins selections with newlines. When pasted text contains one row per
selection, each selection receives its corresponding row; otherwise every selection receives the full text.

Hold **Alt+Shift** and drag for a rectangular selection. **Editor → Selection → Column selection** also converts an
ordinary selection's endpoints into a rectangle. Insertion pads short lines to the selected column.

Use **Alt+Shift+Right** to expand a selection through a word, enclosing brackets, lines, a detected fold, and the file.
**Alt+Shift+Left** restores the previous selection.

## Find and replace

**Ctrl+F** or **Ctrl+H** opens the inline find/replace bar. It supports case-sensitive, whole-word and regex searches,
capture-group replacement, a current/total match counter, and preserve-case replacement. **Selection** captures the
current selection as the search boundary. Moving to another match keeps that boundary; switching source views clears it.
Next/previous search shortcuts use the inline query, including after the bar is closed.

Choose **Files…** or **Editor → Find / replace in files…** to search open tabs or a directory. Include/exclude globs use
semicolon-separated patterns, for example `*.asm;*.inc`. Directory searches read UTF-8 text and use unsaved open buffers
when available. Results show the file, line, matched text, and proposed replacement; double-click a result to navigate.
Check the replacements to apply and choose **Apply checked replacements**. Changed snapshots abort replacement. Open
buffers remain unsaved and support undo; replacements in closed files are written to disk.

## Text and indentation

**Ctrl+Shift+D** duplicates a line or selection. **Editor → Text** also provides sorting, reversing, removing duplicate
lines, case conversion, trailing-whitespace cleanup, tab/space conversion, reindentation, and column alignment.

**Ctrl+/** toggles comments using the compiler's comment delimiter. **Editor → Editor display → Indentation settings**
controls indent width, tabs versus spaces, and columns used by alignment. Alignment uses token boundaries; reindentation
uses generic block markers supplied by the compiler.

## Bookmarks and navigation

Click the bookmark gutter or press **Ctrl+F2** to toggle a bookmark. **F2** and **Shift+F2** move between bookmarks.
**Name / number bookmark** assigns a name or digit; **Ctrl+Alt+0–9** jumps to numbered bookmarks in open files.
**Editor → Bookmarks…** lists bookmarks across open tabs. Bookmarks follow edits and are restored for saved files.

**Ctrl+G** opens go-to-line/column, using `line:column` with both numbers starting at 1. **Editor → Back**, **Forward**,
and **Previous edit** revisit source locations. Ctrl-click a compiler-identified include path to open the referenced file.

## Folding, display, macros, and splits

Use the fold gutter or **Collapse all / Expand all** to fold compiler-provided blocks, multiline comments, and indented
regions. A comment ending in `region` (optionally followed by a name) and a comment ending in `endregion` mark a custom
region. Plain text supports `#region` and `#endregion` lines. Fold detection does not recognize assembler keywords in
the editor.

**Editor display** controls visible whitespace, end-of-line markers, indentation guides, soft wrap, token colors, and
syntax selection for the current file. The compiler syntax is the default; other choices include plain text, Java, C,
JSON, XML, and shell. Display and indentation preferences are saved in application settings.

**Editing macros → Start recording / Stop recording** records the editor library's typing and editing actions.
**Ctrl+Shift+M** replays the last recording. Recording is shared across source views for the current application session.

**Split current file** opens two views of one document; edits appear in both. **Split with another file…** places two
open files side by side. **Close split** restores the tab views. File operations use the focused source view.

## Rename and extraction

**Rename symbol…** uses compiler-provided definitions, references, and scopes in the active source and its reachable
includes. Review its preview before applying. The 8080 and Z80 assemblers provide label, constant, macro, and macro-local
symbol metadata; RAM and RASP provide labels. Comments and strings are not renamed as symbol references. Invalid source,
ambiguous declarations, repeated/cyclic includes, and name conflicts are rejected. Save an untitled source before
resolving its relative includes.

The 8080 and Z80 assemblers support **Extract selection…** for complete instruction lines outside existing macros.
Choose **Macro** or **Subroutine (uses stack)**, enter a new name, and review the generated source. Extraction rejects
declarations, nested blocks, and includes. Subroutine extraction also rejects stack and control-flow instructions and
requires a working stack at runtime. Other compilers do not offer extraction. Review address-sensitive code after
subroutine extraction because the generated call, jump, and return change the program layout.
