---
layout: default
title: Source editing
nav_order: 6
parent: emuStudio Application
permalink: /application/source-editing
---

{% include analytics.html category="Application" %}

# Source editing

The **Edit** menu provides selection, text transformation, navigation, display, refactoring, and split-view commands.
Commands act on the focused source view. With no selection, line transformations such as sorting and whitespace cleanup
act on the whole file; duplicate acts on the current line.

![Edit menu with text, selection, navigation, macros, display, refactoring, and split-view commands]({{ site.baseurl }}/assets/application/source-edit-menu.png){: style="max-width: 1100px; width: 100%;" }

## Files and tabs

**File → New** creates an untitled tab. **File → Open** opens another file or selects its existing tab. Click the small
**×** beside a tab's name to close that file, even when another tab is selected. **Ctrl+W** and **File → Close tab**
close the active file. Unsaved changes are marked with `*`; closing offers save, discard, or cancel. Closing the last
file leaves a fresh untitled tab. Saved open files are restored when you reopen that virtual computer.

Save, Save As, and compilation use the focused source view. In a split, click the view you want to work on first.
Save other modified files before compiling a source that includes them. Ctrl-click a compiler-identified include path
to open it in a tab; save the containing file first so relative paths can be resolved.

The editor uses JetBrains Mono NL. The toolbar's **Font zoom** slider and **Ctrl+mouse wheel** change the active view's
font size; **Ctrl++** and **Ctrl+-** also zoom. Line numbers and compiler-provided syntax highlighting help identify
source positions. Undo/redo and cut/copy/paste are available in **Edit** and the toolbar; **Edit → Select All** selects
the entire document.

## Multiple selections and columns

Hold **Alt** and click to add carets. **Alt+D** selects the next occurrence of selected text; **Ctrl+Shift+L** selects
all occurrences. Typing, deletion, cut, and paste act on all selections in one undo step. Arrow keys move all carets;
**Escape** clears additional selections. Copy joins selections with newlines. When pasted text contains one row per
selection, each selection receives its corresponding row; otherwise every selection receives the full text.

Hold **Alt+Shift** and drag for a rectangular selection. **Edit → Selection → Column selection** also converts an
ordinary selection's endpoints into a rectangle. Insertion pads short lines to the selected column.

Use **Alt+Shift+Right** to expand a selection through a word, enclosing brackets, lines, a detected fold, and the file.
**Alt+Shift+Left** restores the previous selection.

## Find and replace

Use the inline search bar to find or replace text in the active source view. See [Find and replace]({{ site.baseurl }}/application/find-replace) for controls, selection scope, and regular expression examples.

## Text and indentation

**Ctrl+Shift+D** duplicates a line or selection. **Edit → Text** also provides sorting, reversing, removing duplicate
lines, trailing-whitespace cleanup, tab/space conversion, reindentation, and column alignment.
**Uppercase**, **Lowercase**, and **Invert case** transform selected text, including multiple selections, in one undo
step. With no selection, these case commands leave the text unchanged.

**Ctrl+/** toggles comments using the active syntax's comment delimiter. **Edit → Editor display → Indentation settings**
controls indent width, tabs versus spaces, and columns used by alignment. Alignment uses token boundaries; reindentation
uses generic block markers supplied by the compiler.

## Bookmarks and navigation

Click the bookmark gutter or press **Ctrl+F2** to toggle a bookmark. **F2** and **Shift+F2** move between bookmarks.
**Edit → Navigate → Name / number bookmark** assigns a name or digit; **Ctrl+Alt+0–9** jumps to numbered bookmarks in
open files. **Edit → Navigate → Bookmarks…** lists bookmarks across open tabs. Bookmarks follow edits and are restored
for saved files.

**Ctrl+G** opens go-to-line/column, using `line:column` with both numbers starting at 1. **Edit → Navigate → Back**,
**Forward**, and **Previous edit** revisit source locations.

## Folding, display, macros, and splits

Use the fold gutter or **Edit → Editor display → Collapse all / Expand all** to fold compiler-provided blocks, multiline comments, and indented
regions. A comment ending in `region` (optionally followed by a name) and a comment ending in `endregion` mark a custom
region. Plain text supports `#region` and `#endregion` lines. Fold detection does not recognize assembler keywords in
the editor.

**Edit → Editor display** controls visible whitespace, end-of-line markers, indentation guides, soft wrap, and token colors.
Choose **Syntax highlighting** to select the syntax for the focused file: **Default (selected compiler)**,
**Plain text**, or one of the bundled language modes. This choice also selects that mode's comment and folding rules;
compilation and compiler-assisted refactoring still use the virtual computer's compiler. Both views of the same file
share its syntax choice. Choices for saved files are restored on reopening; untitled files keep their choice when saved.
Display and indentation preferences are saved in application settings.

**Edit → Editing macros → Start recording / Stop recording** records the editor library's typing and editing actions.
**Ctrl+Shift+M** replays the last recording. Recording is shared across source views for the current application session.

**Edit → Split view → Split current file** opens two views of one document; edits appear in both. **Split with another
file…** places two open files side by side. **Close split** restores the tab views. File operations use the focused
source view. Closing a file or opening another file also restores the tab views.

![Two views of the same source with compiler-defined folds, a bookmark, and visible whitespace]({{ site.baseurl }}/assets/application/source-split-view.png){: style="max-width: 1100px; width: 100%;" }

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

| Shortcut | Action |
| --- | --- |
| **Ctrl+W** | Close active file |
| **Ctrl+F / Ctrl+R** | Show inline find / replace |
| **F3 / Shift+F3** | Next / previous search match |
| **Ctrl+Shift+D** | Duplicate line or selection |
| **Ctrl+/** | Toggle comment |
| **Alt+D** | Add next occurrence to the selection |
| **Ctrl+Shift+L** | Select all occurrences |
| **Alt+click** | Add a caret |
| **Alt+Shift+drag** | Make a rectangular selection |
| **Alt+Shift+Right / Left** | Expand / shrink selection |
| **Ctrl+G** | Go to line / column |
| **Ctrl+F2** | Toggle bookmark |
| **F2 / Shift+F2** | Next / previous bookmark |
| **Ctrl+Alt+0–9** | Go to a numbered bookmark across open files |
| **Ctrl+Shift+M** | Replay editing macro |
| **Ctrl+mouse wheel / Ctrl++ / Ctrl+-** | Change font size |
| **Escape** | Clear additional carets and marked occurrences |
