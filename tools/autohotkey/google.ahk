#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ME: search for clipboard contents on google.
#g:: ; Win+g
   oCB = %clipboard% 
   clipboard =
   Send, ^c
   ClipWait
   oTXT = %clipboard%
   clipboard = %oCB%     
   Run http://www.google.com/search?q=%oTXT%
Return

; ME: search for Jira bug using clipboard contents.
#j:: ; Win+j
   oCB = %clipboard% 
   clipboard = 
   Send, ^c
   ClipWait
   oTXT = %clipboard%
   clipboard = %oCB%
   Run https://cw-jira.teneo-test.local/browse/%oTXT%
Return

; ME: Get selected text and expand it for a Jira query.
#d:: ; win+d
   oCB = %clipboard%
   clipboard =
   Send ^c
   ClipWait,1
   oTXT = %clipboard%
   clipboard = (summary ~ "%oTXT%" OR description ~ "%oTXT%" OR comment ~ "%oTXT%") AND
   Send ^v
;   clipboard = %oCB% 
Return

; ME: SearCh my Jira watchlist.
#k:: ; win+k
   oCB = %clipboard%
   clipboard =
   Send ^c
   ClipWait,1
   oTXT = %clipboard%
   clipboard = AND key in watchedIssues()
   Send ^v    
Return
