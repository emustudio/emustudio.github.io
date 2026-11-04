---
layout: default
title: Find and replace
nav_order: 6.5
parent: emuStudio Application
permalink: /application/find-replace
---

{% include analytics.html category="Application" %}

# Find and replace

Use the inline search bar to find or replace text in the active source view. Press **Ctrl+F** to find or **Ctrl+R** to show the replacement controls. If text is selected when you open the bar, it becomes the search query.

<div class="screenshot-key" style="position: relative; max-width: 1100px;">
  <img src="{{ site.baseurl }}/assets/application/find-replace-current.png" alt="Inline find and replace bar above a source file, with numbered controls" style="display: block; width: 100%;">
  <span class="circle" style="position:absolute; left:1%; top:0%;">1</span>
  <span class="circle" style="position:absolute; left:30%; top:0%;">2</span>
  <span class="circle" style="position:absolute; left:61%; top:0%;">3</span>
  <span class="circle" style="position:absolute; left:65%; top:0%;">4</span>
  <span class="circle" style="position:absolute; left:69%; top:0%;">5</span>
  <span class="circle" style="position:absolute; left:73%; top:0%;">6</span>
  <span class="circle" style="position:absolute; left:79%; top:0%;">7</span>
  <span class="circle" style="position:absolute; left:85%; top:0%;">8</span>
  <span class="circle" style="position:absolute; left:94%; top:0%;">9</span>
  <span class="circle" style="position:absolute; left:30%; top:13%;">10</span>
  <span class="circle" style="position:absolute; left:61%; top:13%;">11</span>
  <span class="circle" style="position:absolute; left:81%; top:13%;">12</span>
  <span class="circle" style="position:absolute; left:94%; top:13%;">13</span>
</div>

{: .list .control-list .screenshot-controls .screenshot-key}
| Mark | Control |
|:--:|:--|
| <span class="circle">1</span> | Show or hide replacement controls. |
| <span class="circle">2</span> | **Find**: enter text or a regular expression. |
| <span class="circle">3</span> | **Match case**: distinguish uppercase and lowercase letters. |
| <span class="circle">4</span> | **Whole word**: exclude matches adjacent to a letter, digit, or underscore. |
| <span class="circle">5</span> | **Regex**: interpret the query as a regular expression. |
| <span class="circle">6</span> | **Selection**: limit the search to the captured selection in this view. |
| <span class="circle">7</span> | Result count, or an error for an invalid search or replacement. |
| <span class="circle">8</span> | Previous and next match. |
| <span class="circle">9</span> | Close the search bar. |
| <span class="circle">10</span> | **Replace with**: enter replacement text. Leave empty to delete matches. |
| <span class="circle">11</span> | **Preserve case**: adapt replacement capitalization to each match. |
| <span class="circle">12</span> | **Replace**: replace the selected match and move to the next one. |
| <span class="circle">13</span> | **Replace All**: replace all matches within the search boundary. |

## Find text

Type a query to see the number of matches in the active view. The count is a total, not the position of the selected match. Select the arrows, press **F3** for the next match or **Shift+F3** for the previous match, or use **Edit → Find next / Find previous**. Navigation wraps at the end of the search boundary. Pressing Enter in the find field also selects the next match.

To search only part of a file, select text in the editor, open the bar, and enable **Selection**. The button captures the selection when enabled; moving between matches does not change that boundary. Disable and re-enable it to capture a different selection. Switching to another source view clears the restriction. With **Selection** off, search covers the active view's entire document, including unsaved edits.

## Replace text

Enter a query and replacement, then select a match. **Replace** changes the selected match and moves to the next one. If no match is selected, it selects the next match without changing text. **Replace All** changes all matches within the search boundary in one undo step. Review the query and options before using it; use Undo to reverse the operation.

**Preserve case** changes the replacement to follow each match. For example, replacing `cat` with `dog` changes `cat` to `dog`, `CAT` to `DOG`, and `Cat` to `Dog`. Other mixed capitalization is left as entered. This option controls replacement; **Match case** controls which text is found.

## Regular expressions and groups

Enable **Regex** to use Java regular expressions. Without it, search treats the query as literal text. For example, `cp*` matches `c` followed by zero or more `p` characters, so it also matches the `c` in `backspace`. Use `cp.*` to match `cp` followed by the rest of the line. Use `cp+` to require at least one `p`.

Use parentheses to capture text and refer to it in the replacement with `$1`, `$2`, and so on; `$0` refers to the whole match. For example, find `(first) (last)` and replace with `$2, $1` to produce `last, first`. Named groups also work: find `(?<word>\w+)` and use `${word}` in the replacement. An unmatched optional group expands to an empty string. In a regex replacement, escape a literal dollar sign as `\$` and a literal backslash as `\\`.

Invalid patterns and replacement group references show an error in the bar. Correct the query or replacement before continuing. Closing the bar keeps its query available to the next/previous search commands.
