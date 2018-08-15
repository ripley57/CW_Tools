#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; winkey + a	: Display autohotkeys defined in this script.
; Gui testing.
#a::
todisplay := "My Autohotkeys" "`n" "`n"
Loop
{
	FileReadLine, line, %A_ScriptFullPath%, %A_Index%
	if errorlevel 
		break
	FoundPos := RegExMatch(line, "^; (winkey \+.*)", subpat1)
	if FoundPos
	{
		;todisplay .= line "`n"
		todisplay .= subpat1 "`n"
	}

	;Debugging
	;MsgBox, 4, , Line #%A_Index% is "%line%".  Continue?
	;IfMsgBox, No
	;      	break
}
MsgBox,, %A_ScriptFullPath%, %todisplay%
return


; winkey + c	: Cygwin
#c::Run "C:\Users\Public\Desktop\Cygwin Terminal.lnk"

; winkey + b	: Cheatsheet
#b::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "file:///C:\Users\jcdc\Dropbox\Public\cheatsheet.htm"

; winkey + e	: Windows Explorer
#e::Run  "explorer.exe" "C:\mystuff"

; winkey + s	: FastStone Capture
;#s:: Run "SnippingTool.exe"
#s:: Run "C:\Program Files (x86)\FastStone Capture\FSCapture.exe"

; winkey + w	: Word
#w::Run "winword.exe"

; winkey + n	: Notepad++
#n::Run "notepad++"

; winkey + m	: Launch notepad and paste currently selected text.
#m::
{
    savedclipboard=%clipboard%
    Send, ^c
    selection=%clipboard%
    clipboard=%savedclipboard%
    savedclipboard=
    Run "C:\Windows\system32\notepad.exe"
    WinWait, Untitled - Notepad
    Send, ^v
    return
}


InvokeVerb(path, menu, validate=True) {
;by A_Samurai
;v 1.0.1 http://sites.google.com/site/ahkref/custom-functions/invokeverb
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        SplitPath, path, name, dir
        objFolder := objShell.NameSpace(dir)
        objFolderItem := objFolder.ParseName(name)
    }
    if validate {
        colVerbs := objFolderItem.Verbs   
        loop % colVerbs.Count {
            verb := colVerbs.Item(A_Index - 1)
            retMenu := verb.name
            StringReplace, retMenu, retMenu, &       
            if (retMenu = menu) {
                verb.DoIt
                Return True
            }
        }
        Return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
}

;winkey + x
;#x::InvokeVerb("C:\mystuff\Jeremys_Share\CW_Tools\cwtools.jar", "Copy")
;return

;winkey + z
;#z::InvokeVerb("C:\Users\jeremy_c\Dropbox\Public\CW_Tools\cwtools.jar", "Copy")
;return

;winkey + i
;#i::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\Internals"
;winkey + p
;#p::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\Procedures"

;winkey + p
;#p::
;Send, superuser
;Send, {TAB}
;Send, california
;Send, {TAB}
;Send, {ENTER}
;return

;winkey + g
;#g::
;Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://vrts.sam.com/auth/"
;Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://granite.community.com/"
;Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://edp-jira.engba.com/secure/Dashboard.jspa"
;Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "http://edp-confluence.engba.com/dashboard.action"
;Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://engtools.engba.com/Etrack/bottom.php"
;return

;winkey + 1
;#1::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v81"
;winkey + 2
;#2::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v82"
;winkey + 3
#3::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v713"
;winkey + 4
#4::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v714"
;winkey + 5
#5::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v715"
;winkey + 6
#6::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v66"
;winkey + 7
#7::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v715"
;winkey + 8
#8::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "C:\mystuff\documentation\v811"

; winkey + t	: Windows Explorer C:\tmp
;#t::Run  "explorer.exe" "C:\tmp"

;winkey + o
;#o:: Run "outlook.exe"

; winkey + t	: Save current email as text file and open in Notepad++
;#t::
;Send, !fa
;WinWait, Save As
;Send, C:\tmp\_t.txt
;Send, {TAB}
;Send, t
;FileDelete, C:\tmp\_t.txt 
;Send, {ENTER}
;Sleep, 1000 
;Run "C:\Program Files (x86)\Notepad++\notepad++.exe" "C:\tmp\_t.txt"
;return

;winkey + j: launch jira
;#j::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://cw-jira.teneo-test.local/secure/Dashboard.jspa"
;winkey + j: Search Jira for selected text.
;#j::
;{
;    savedclipboard=%clipboard%
;    Send, ^c
;    selection=%clipboard%
;    clipboard=%savedclipboard%
;    savedclipboard=
;    Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "http://jira-new.cw-test.com:8092/browse/%selection%"
;    return
;}

;#IfWinActive ahk_class ExploreWClass|CabinetWClass
;    return
;#IfWinActive

;#k::
;   selection := FC("explorer","","selection")
;   MsgBox selection
;return
