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
- Spell-checking
- Some modes

## SEARCHING

- Incremental search commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-s|isearch-forward|Start incremental search forward; follow by search string. Also, find next occurrence(forward) of search string.|
|C-r|isearch-backward|Start incremental search backward; follow by search string. Also, find next occurrence(backward) of search string.|
|Enter|isearch-exit|In an incremental search, exit the search.|
|C-g|keyboard-quit|In an incremental search, cancel the search.|
|Del|isearch-delete-char|In an incremental search, delete character from search string.|
|C-s C-w|isearch-yank-word|Start incremental search with the word the cursor is on as the search string.|
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

## REPLACING

- Query-replace

Responses during query-replace(Type M-% to go into query-replace)

|Keystrokes|Command name|Action|
|:---|:---|:---|
|Space or y||Replace *search string* with *new string* and go to the next instance of the string.|
|Del or n||Don't replace; move to next instance.|
|.||Replace the current instance and quit|
|,||Replace and let me see the result before moving on.(Press Space or y to move on.)|
|!||Replace all the rest and don't ask.|
|^||Back up to the previous instance.|
|Enter or q||Exit query-replace.|
|E||Modify the replacement string.|
|C-r||Enter a recursive edit.|
|C-w||Delete this instance and enter a recursive edit|
|C-M-c||Exit recursive edit and resume query-replace.|
|C-\]||Exit recursive edit and query-replace|

- Regular Expressions for Search and Replacement Operations

- Characters for regular expressions

|Character(s)|Match|
|:---|:---|
|^|Matches the beginning of a line.|
|\$|Matches the end of a line.|
|.|Matches any single character(like ? in filenames).|
|.\*|Matches any group of zero or more characters(. matches any character and \* matches zero or more of the previous character)|
|\\<|Matches the beginning of a word.|
|\\>|Matches the end of a word.|
|[]|Matches any character specified within the brackets; for example, \[a-z\] matches any alphabetic character.|
|\\s, \\S|Matches any white space character: space, a newline, a tab, a carriage return, a formfeed, or a backspace; \\S matches any character except white space.|
|\\d, \\D|Matches any single digit, 0-9; \\D matches any character but a digit.|
|\\w, \\w|Matches any \"word\" character(upper- and lowercase letters, digits, and the underscore character);\\W matches any character but these.|

- Regular expression search commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|C-M-s Enter|re-search-forward|Search for a regular expression forward|
|C-M-r Enter|re-search-backward|Search for a regular expression backward.|
|C-M-s|isearch-forward-regexp|Search incrementally forward for a regular expression.|
|C-M-r|isearch-backward-regexp|Search incrementally backward for a regular expression.|
|C-M-%|query-replace-regexp|Query-replace a regular expression.|
|(none)|replace-regexp|Globally replace a regular expression unconditionally(use with caution).|

## SPELLING CHECKING

- Spell-checking commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|M-$|ispell-word|Check the word the cursor is on or the word following the cursor.|
||ispell-region|Check spelling of the region.|
||ispell-buffer|Check spelling of the buffer.|
||ispell-message|Check spelling of the body of a mail message.|
||ispell-comments-and-strings|Check spelling of comments and strings in a program.|
|C-u M-$|ispell-continue|Resume Ispell; it works only if stopped Ispell with C-g.|
||ispell-kill-ispell|Kill the Ispell process, which continues to run in the background after it is invoked.|
|M-Tab|ispell-complete-word|In text mode, list possible completions for the current word.|
||flyspell-mode|Enter the Flyspell minor mode, in which incorrectly spelled words are highlighted|
||flyspell-buffer|Spell-check the current buffer, underlining all misspelled words. Use middle mouse button to correct.|

- Word abbreviation commands

|Keystrokes|Command name|Action|
|:---|:---|:---|
|M-/|dabbrev-expand| Complete this word based on the nearest word that starts with this string(press M-/ again if that's not the word you want).|
||abbrev-mode|Enter(or exit) word abbreviation mode.|
|C-x a - or C-x a i g|inverse-add-global-abbrev|After typing the global abbreviation, type the definition.|
|C-x a i l|inverse-add-mode-abbrev|After typing the local abbreviation, type the definition.|
||unexpand-abbrev|Undo the last word abbreviation.|
||write-abbrev-file|Write the word abbreviation file.|
||edit-abbrevs|Edit the word abbreviations.|
||list-abbrevs|View the word abbreviations.|
||kill-all-abbrevs|Kill abbreviations for this session.|
