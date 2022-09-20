---
layout: post
title: Learning Emacs III
date: 2022-09-12 13:37 +0800
tags: [learning, emacs]
toc: true
---
Chapter03: Search and Replace

- Traditional search and replace facilities
- Incremental searches, regular expression searches and query-replace
- Spell-checkng
- Some modes

- Incremental search commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-s|isearch-forward|Start incremental search forward; follow by search string. Also, find next occurrence(forward) of search string.|
|C-r|isearch-backward|Start incremental search backward; follow by search string. Also, find next occurrence(backward) of search string.|
|Enter|isearch-exit|In an incremental search, exit the search.|
|C-g|keyboard-quit|In an incremental search, cancel the search.|
|Del|isearch-delete-char|In an incremental search, delete character from search string.|
|C-s C-w|isearch-yank-word|Staran incremental search with the word the cursor is on as th search string.|
|C-s C-y|isearch-yank-line|Start an incremental search with the text from the cursor position to the end of the line as the search string.|
|C-s M-y|isearch-yank-kill|Start an incremental search with text from the kill ring as the search string|
|C-s C-s|isearch-repeat-forward|Repeat previous search.|
|C-r C-r|isearch-repeat-backward|Repeat previous search.| 

- Simple search commands(nonincremental search)

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-s Enter *SEARCH STRING* Enter||Start nonincremental search forward|
|C-s||Repeat search forward|
|C-r Enter *SEARCH STRING* Enter||Start nonincremental search backward|
|C-r||Repeat search backward|



|Keystrokes|Command name|Action|
|:---|:---|:---|
||||
||||


|Keystrokes|Command name|Action|
|:---|:---|:---|
||||
||||

|Keystrokes|Command name|Action|
|:---|:---|:---|
||||
||||

|Keystrokes|Command name|Action|
|:---|:---|:---|
||||
||||
