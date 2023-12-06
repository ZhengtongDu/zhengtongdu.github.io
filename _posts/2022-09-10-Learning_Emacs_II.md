---
layout: post
title: Learning Emacs II
date: 2022-09-10 12:11 +0800
tags: [learning, emacs]
toc: true
---
## Chapter 02
All about EDITING.

- Text filling and reformatting 
```
I want to know what happened if I enable the auto-fill mode. It seems
that... Oh! It helps me split the long sentence automatically!
Amazing! Oh! Again, it does the same thing once more. Now I want to
stop this mode. I should type "M-x auto-fill-mode" to disable the
minor mode. Now the auto-fill mode has been disabled.
```
Some commands

|Keystrokes|Command name| Action|
|:---|:---|:---|
|(none)| refill-mode| Toggle refill mode, inwhich Emacs automatically refromats text.|
|(none)| | Toggle auto-fill mode, in which Emacs formats paragraphs as you type them.|
|M-q| fill-paragraph| Reformat paragraph.|
|(none)| fill-region| Reformat individual paragraphs within a region.|


```
If I type a suuuuuuuper long sentence and don't make line-split manually, then type "M-q", what will happened?

If I type a suuuuuuuper long sentence and don't make line-split
manually, then type "M-q", what will happened?

The result is the sentence is reformatted.

If I type a suuuuuuuper long sentence and don't make line-split manually, select the latter part and type "M-x fill-region", what will happened?

If I type a suuuuuuuper long sentence and don't make line-split manually, select
the latter part and type "M-x fill-region", what will happened?

The result is the part being selected is reformatted.

```
- Cursor movement commands

|Keystrokes|Command name| Action|
|:---|:---|:---|
|C-f| forward-char| Move forward one character(right).|
|C-b| backward-char| Move backward one character(left).|
|C-p| previous-line| Move to previous line(up).|
|C-n| next-line| Move to next line(down).|
|M-f| forward-word| Move one word forward.|
|M-b| backward-word| Move one word backward.|
|C-l| recenter| Redraw screen with current line in the center.|
|M-n| digit-argument| Repeat the next command n times.|
|C-u n| universal-argument| Repeat the next command n times(four times if you omit n).|

(I don't want to master all the commands mentioned in the book.)

- Deleting, killing and yanking text

|Keystrokes|Command name| Action|
|:---|:---|:---|
|C-d| delete-char| Delete character under cursor. |
|Del| delete-backward-char| Delete previous character.|
|M-d| kill-word| Delete next word.|
|M-Del| backward-kill-word| Delete previous word.|
|C-k| kill-line| Delete from cursor to end of line.|
|M-k| kill-sentence| Delete next sentence.|
|C-x Del| backward-kill-sentence| Delete previous sentence.|
|C-y| yank| Restore what you've deleted.a|
|C-w| kill-region| Delete a markedregion|n
|(none)| kill-paragraph| Delete next paragraph|
|(none)| backward-kill-paragraph| Delete previous paragraph|

- Commands for working with regions

|Keystrokes|Command name| Action|
|:---|:---|:---|
|C-@ or C-Space| set-mark-command| Mark the beginning(or end) of a region|
|C-x C-x| exchange-point-and-mark| Exchange location of cursor and mark.|
|C-w| kill-region| Delete the region.|
|C-y| yank| Paste most recently killed or copied|
|M-w| Kill-ring-save| Copy the region(so it can be pasted with C-y).|
|M-h| mark-paragraph| Mark paragraph.|
|C-x C-p| mark-page| Mark page.|
|C-x h| mark-whole-buffer| Mark buffer.|
|M-y| yank-pop| After C-y, pastes earlier deletion.|

- Transposition commands

|Keystrokes|Command name| Action|
|:---|:---|:---|
|C-t| transpose-chars| Transpose two letters.|
|M-t| transpose-words| Transpose two words.|
|C-x C-t| transpose-lines| Transpose two lines.|
|(none)| transpose-sentences| Transpose two Sentences|
|(none)| transpose-paragraphs| Transpose two Paragraphs|

- Capitalization commands

|Keystrokes|Command name| Action|
|:---|:---|:---|
|M-c| capitalize-word| Capitalizefirst letter of word.|
|M-u| upcase-word| Uppercase word.|
|M-l| downcase-word| Downcase word.|
|Meta - M-c| negative-argument;capitalize-word| Capitalize previous word.|
|Meta - M-u| negative-argument;upcase-word| Uppercase previous word.|
|Meta - M-l| negative-argument;downcase-word| Lowercase previous word.|

[Back To Overview](https://zhengtongdu.github.io/2022/09/07/Learning_Emacs_Overview/)
