---
layout: default
title: Source editing
nav_order: 6
parent: emuStudio Application
permalink: /application/source-editing
---

{% include analytics.html category="Application" %}

# Source editing

Use **File** to manage source tabs and **Edit** to work in the focused source view. Choose a command for the current selection, or use the line and navigation commands at the caret.

The **Edit** menu provides column selection, text transformation, go-to-line, display, refactoring, and split-view commands.
Commands act on the focused source view. With no selection, line transformations such as sorting and whitespace cleanup
act on the whole file; duplicate acts on the current line.

![Edit menu with numbered controls for text editing, column selection, navigation, and editor views]({{ site.baseurl }}/assets/application/source-edit-menu.png){: style="max-width: 1100px; width: 100%;" }

{: .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Text**. Duplicate, reorder, or transform source lines. |
| <span class="circle">2</span> | **Column Selection Mode**. Toggle rectangular selection in the active view. |
| <span class="circle">3</span> | **Go to line / column**. Move the caret to a source position. |
| <span class="circle">4</span> | **Editor display**. Change folding, indentation, and display settings. |
| <span class="circle">5</span> | **Refactor** and **Split view**. Rename or extract code, or open a second view. |

## Files and tabs

The editor opens with an untitled tab. **File → New** creates a tab. **File → Open** opens a file or selects its
existing tab. Click **×** beside any tab's name to close that file. Use **File → Close tab** to close the active
file. An asterisk marks unsaved changes. Closing a modified tab offers save, discard, or cancel. Closing the last
file leaves a fresh untitled tab.

Save, Save As, and compilation use the focused source view. In a split, click the view you want to work on first.
Save other modified files before compiling a source that includes them. Ctrl-click a compiler-identified include path
to open it in a tab; save the containing file first so relative paths can be resolved.

The editor uses JetBrains Mono NL. The toolbar's **Font zoom** control and **Ctrl+mouse wheel** change the active view's
font size; **Ctrl++** and **Ctrl+-** also zoom. Line numbers and compiler-provided syntax highlighting help identify
source positions. Undo/redo and cut/copy/paste are available in **Edit** and the toolbar; **Edit → Select All** selects
the entire document.

## Multiple selections and columns

Hold **Alt** and click to add carets. Typing, deletion, cut, and paste act on all selections in one undo step.
Arrow keys move all carets. **Escape** clears additional selections. Copy joins selections with newlines. When the
clipboard has one row per selection, paste inserts the corresponding row into each selection. Otherwise, paste
inserts the full clipboard text into each selection.

Choose **Edit → Column Selection Mode** to toggle the mode in the active editor view.
While the menu item is checked, drag or use **Shift+arrow keys** to create and extend a rectangle.
Toggle the mode off to return to regular selection. For a single rectangular selection, hold **Alt+Shift** and drag.
Typing into a column selection pads short lines to the selected column.

## Find and replace

Use the inline search bar to find or replace text in the active source view. See [Find and replace]({{ site.baseurl }}/application/find-replace) for controls, selection scope, and regular expression examples.

## Text and indentation

**Edit → Text → Duplicate line / selection** duplicates the current line or selection. **Text** also provides sorting, reversing, removing duplicate
lines, trailing-whitespace cleanup, tab/space conversion, reindentation, and column alignment.
**Uppercase**, **Lowercase**, and **Invert case** transform selected text, including multiple selections, in one undo
step. With no selection, these case commands leave the text unchanged.

**Edit → Text → Toggle comment** uses the active syntax's comment delimiter. **Edit → Editor display → Indentation settings**
controls indent width, tabs versus spaces, and columns used by alignment. Alignment uses token boundaries; reindentation
uses generic block markers supplied by the compiler.

## Navigation

Choose **Edit → Go to line / column** and enter `line:column`, with both numbers starting at 1.

## Folding, display, and splits

Use the fold gutter or **Edit → Editor display → Collapse all / Expand all** to fold compiler-provided blocks, multiline comments, and indented
regions. A comment ending in `region` (optionally followed by a name) and a comment ending in `endregion` mark a custom
region. Plain text supports `#region` and `#endregion` lines. Fold detection does not recognize assembler keywords in
the editor.

**Edit → Editor display** controls visible whitespace, indentation guides, soft wrap, and token colors.
Choose **Syntax highlighting** to select the syntax for the focused file: **Default (selected compiler)**,
**Plain text**, or one of the bundled language modes. This choice also selects that mode's comment and folding rules;
compilation and compiler-assisted refactoring still use the virtual computer's compiler. Both views of the same file
share its syntax choice. Choices for saved files are restored on reopening; untitled files keep their choice when saved.
Display and indentation preferences are saved in application settings.

**Edit → Split view → Split current file** opens two views of one document; edits appear in both. **Split with another
file…** places two open files side by side. **Close split** restores the tab views. File operations use the focused
source view. Closing a file or opening another file also restores the tab views.

![Two views of hello-world-8080.asm in the split source editor]({{ site.baseurl }}/assets/application/source-split-view.png){: style="max-width: 1100px; width: 100%;" }

## Rename and extraction

**Edit → Refactor → Rename symbol…** uses compiler-provided definitions, references, and scopes in the active source and its reachable
includes. Review its preview before applying. The 8080 and Z80 assemblers provide label, constant, macro, and macro-local
symbol metadata; RAM and RASP provide labels. Comments and strings are not renamed as symbol references. Invalid source,
ambiguous declarations, repeated/cyclic includes, and name conflicts are rejected. Save an untitled source before
resolving its relative includes.

![Rename preview listing the source positions that will change]({{ site.baseurl }}/assets/application/source-rename-preview.png){: style="max-width: 580px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Preview**. Review the proposed symbol rename before applying it. |
| <span class="circle">2</span> | **OK**. Apply the displayed changes. |
| <span class="circle">3</span> | **Cancel**. Close the preview and keep the source unchanged. |

The 8080 and Z80 assemblers support **Edit → Refactor → Extract selection…** for complete instruction lines outside existing macros.
Choose **Macro** or **Subroutine (uses stack)**, enter a new name, and review the generated source. Extraction rejects
declarations, nested blocks, and includes. Subroutine extraction also rejects stack and control-flow instructions and
requires a working stack at runtime. Other compilers do not offer extraction. Review address-sensitive code after
subroutine extraction because the generated call, jump, and return change the program layout.

![Extraction preview showing the selected instructions moved into a new macro]({{ site.baseurl }}/assets/application/source-extraction-preview.png){: style="max-width: 580px; width: 100%; height: auto;" }

{: .list .control-list .screenshot-controls}
| Mark | Explanation |
|:--:|:--|
| <span class="circle">1</span> | **Preview**. Review the proposed extracted source before applying it. |
| <span class="circle">2</span> | **OK**. Apply the displayed changes. |
| <span class="circle">3</span> | **Cancel**. Close the preview and keep the source unchanged. |

## Keyboard shortcuts

| Action | Linux and Windows | macOS |
| --- | --- | --- |
| Close active file | **Ctrl+F4** | **Cmd+W** |
| Show inline Find / Replace | **Ctrl+F** / **Ctrl+R** | **Cmd+F** / **Cmd+R** |
| Next / previous match | **F3** / **Shift+F3** | **F3** / **Shift+F3** |
| Duplicate line or selection | **Ctrl+D** | **Cmd+D** |
| Redo | **Ctrl+Shift+Z** | **Cmd+Shift+Z** |
| Delete current line | **Ctrl+Y** | **Cmd+Backspace** |
| Toggle comment | **Ctrl+/** | **Cmd+/** |
| Toggle Column Selection Mode | **Alt+Shift+Insert** | **Cmd+Shift+8** |
| Go to line / column | **Ctrl+G** | **Cmd+L** |
| Rename symbol | **Shift+F6** | **Shift+F6** |

Hold **Alt** (Option on macOS) and click to add a caret, or hold **Alt+Shift** and drag to select a rectangle.
Press **Escape** to clear additional carets and marked occurrences. Use **Ctrl+mouse wheel**, **Ctrl++**, or **Ctrl+-**
to change the font size.
