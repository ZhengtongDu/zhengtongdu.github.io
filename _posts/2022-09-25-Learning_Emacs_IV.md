---
layout: post
title: Learning Emacs IV
date: 2022-09-25 14:29 +0800
tags: [learning, emacs]
toc: true
---

# Chapter 04: Using Buffers, Windows, and Frames

This chapter focuses on topics of frames, windows and bookmarks, teaching you how to use them for convenience. So interesting!

- Frame commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-x 5 o|other-frame|Move to other frame.|
|C-x 5 0|delete-frame|Delete current frame.|
|C-x 5 2|make-frame|Create a new frame on the current buffer.|
|C-x 5 f|find-file-other-frame|Find file in a new frame.|
|C-x 5 r|find-file-read-only-other-frame|Find a file in a new frame, but it is read-only.|
|C-x 5 b|switch-to-buffer-other-frame|Make frame and display other buffer in it.|

- Buffer manipulation commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-x b|switch-to-buffer|Move to the buffer specified.|
|C-x \right-arrow|next-buffer|Move to the next buffer in the buffer list.|
|C-x \left-arrow|previous-buffer|Move to the previous buffer in the buffer list.|
|C-x C-b|list-buffers|Display the buffer list.|
|C-x k|kill-buffer|Delete the buffer specified|
||kill-some-buffers|Ask about deleting each buffer.|
||rename-buffer|Change the buffer's name to the name specified. |
|C-x s|save-some-buffers|Ask whether you want to save each modified buffer.|

- Buffer list commands

|Keystrokes|Action|Occurs|
|:---|:---|:---|
|C-n, Space, n, or \down-arrow|Move to the next buffers in the list(i.e., down one line). | Immediately |
|C-p, p, or \up-arrow |Move to the previous buffer in the list(i.e., up one line).| Immediately |
|d, or k|Mark buffer for deletion.| When you press x|
|s|Save buffer. | When you press x|
|u|Unmark buffer.| Immediately |
|x|Execute other one-letter commands on all marked buffers.| Immediately |
|Del|Unmark the previous buffer in the list; if there is no mark, move up one line.| Immediately |
|~|Mark buffer as unmodified.| Immediately |
|%|Toggle read-only status of buffer. | Immediately |
|1|Display buffer in a full screen. | Immediately |
|2|Display this buffer and the next one in horizontal windows.| Immediately |
|f|Replace buffer list with this buffer.| Immediately |
|o|Replace other window with this buffer.| Immediately |
|m|Mark buffers to be displayed in windows.| When you press v|
|v|Display buffers marked with m; Emacs makes as many windows as needed.| Immediately |
|q|Quit buffer list.| Immediately |

- Window commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-x 2|split-window-vertically|Divide current window into two Windows, one above the other.|
|C-x 3|split-window-horizontally|Divide current window into two side-by-side windows.|
|C-x o|other-window|Move to the other window; if there are several, move to the next window.|
|C-x 0|delete-window|Delete the current window.|
|C-x 1|delete-other-windows|Delete all windows but this one.|
|C-x ^|enlarge-window|Make window taller.|
||shrink-window|Make window shorter.|
|C-x }|enlarge-window-horizontally|Make window wider.|
|C-x {|shrink-window-horizontally|Make window narrower.|
|C-x +|balance-windows|Make windows the same size.|
|C-x 4 f|find-file-other-window|Find a file in the other window.|
|C-x 4 b|switch-to-buffer-other-window|Select a buffer in the other window.|

Commands for editing the bookmark list

|Command name|Action|
|:---|:---|
|Enter, f, or j|Go to the bookmark on the current line.|
|C-o or o|Open the bookmark on the current line in another window;o moves the cursor to that window; C-o keeps the cursor in the current window.|
|d, C-d, or k|Flag bookmark for deletion.|
|r|Rename bookmark.|
|s|Save all bookmarks listed.|
|m|Mark bookmarks to be displayed in multiple windows.|
|v|Display marked bookmarks or the one the cursor is on if none are marked.|
|t|Toggle display of paths to files associated with bookmarks.|
|w|In the minibuffer, display location of file associated with bookmarks.|
|x|Delete bookmarks flagged for deletion.|
|u|Remove mark from bookmark.|
|Del|Remove mark from bookmark on previous line or move to the previous line(if there is no mark).|
|q|Exit bookmark list.|
|Space or n|Move down a line.|
|p|Move up a line.|
|\||Load a bookmark file(other than the default).|
|A|Display all annotations.|
|a|Display annotation for current bookmark.|
|e|Edit(or create)annotation for the current bookmark.|


|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-x r m|bookmark-set|Set a bookmark at the current cursor position.|
|C-x r b|bookmark-jump|Jump to a bookmark.|
||bookmark-rename|Rename a bookmark.|
||bookmark-delete|Delete a bookmark.|
||bookmark-save|Save all bookmarks in default file.|
|C-x r l|bookmark-menu-list|Move to \*Bookmark List\*buffer.|

