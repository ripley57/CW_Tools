;----------------------------------------
#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %1%            ; Ensures a consistent starting directory.
DetectHiddenText, off        ; Only use visible window text for this program
;----------------------------------------
GetSelectedText() {
tmp = %ClipboardAll% ; save clipboard
Clipboard := "" ; clear clipboard
Send, ^c ; simulate Ctrl+C (=selection in clipboard)
ClipWait, 0, 1 ; wait until clipboard contains data
selection = %Clipboard% ; save the content of the clipboard
Clipboard = %tmp% ; restore old content of the clipboard
return selection
}
;----------------------------------------
if 0 < 2
{
	MsgBox Not enough parameters specified
	ExitApp 1
}
;Temp variables param1 and param2 are needed becuase ahk can't handle a command line param in an expression!
;First parameter is full path to jd-gui.exe.
param1 = %2%
if !FileExist( param1 )
{
	MsgBox File not found at [%2%].
	ExitApp 2
}
; Second parameter is full path to a Java class file.
param2 = %3%
if !FileExist( param2 )
{
	MsgBox File not found at [%3%].
	ExitApp 3
}
; -------------------------------
; If there's a jd-gui window already open then exit with an error
; -------------------------------
SetTitleMatchMode 2
IfWinExist Java Decompiler
{
	MsgBox jd-gui is already running.
	ExitApp 4
}
; -------------
; Launch jd-gui
; -------------
Run %2% %3%
WinWaitActive, Error, , 2
if ErrorLevel = 0
{
	ExitApp 5
}
WinWaitActive, Java Decompiler, , 5
; -------------------------------
; Perform "Save Source" (Ctrl + S)
; -------------------------------
Send ^s
WinWaitActive Save
sel := GetSelectedText()
Send %1%\%sel%
Send {ENTER}
; -------------------------------
; Prompt will be displayed if Java file already exists.
; Overwrite existing Java file.
; -------------------------------
;Sleep, 5000  ; 
;SetTitleMatchMode 2
;IfWinExist Save
;{
;	Send {ENTER}
;}
; -------------------------------
; Exit jd-gui (Alt + x)
; -------------------------------
Sleep, 2000  ; 
Send !x
