#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Autohotkey docs:
; https://www.autohotkey.com/docs/commands/

; winkey + x	: Display the autohotkeys defined in this script.
#x::
todisplay := "My Autohotkeys" "`n" "`n"
Loop
{
	FileReadLine, line, %A_ScriptFullPath%, %A_Index%
	if errorlevel 
		break
	FoundPos := RegExMatch(line, "^; winkey \+ ")
	if FoundPos
	{
		todisplay .= line "`n" 
	}

	;Debugging
	;MsgBox, 4, , Line #%A_Index% is "%line%".  Continue?
	;IfMsgBox, No
	;      	break
}
MsgBox,, %A_ScriptFullPath%, %todisplay%
return

;; winkey + a	: tbd
;#a::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://app.asana.com/"
;return

;; winkey + b	: tbd
;#b::Run "C:\Program Files\Git\git-bash.exe" --cd-to-home
;return

;; winkey + c	: tbd
;#c::Run "c:\users\jclough\Desktop\CW_Tools.lnk"
;return

; winkey + d	: Runtime docs (online)
#d::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://www.microfocus.com/documentation/enterprise-developer/ed50pu2/ED-Eclipse/GUID-8B6408E7-A484-4567-94B2-58830891A1BB.html"
return

; winkey + e	: Windows Explorer
#e::Run "explorer.exe" "D:\Work"
return

;; winkey + f	: tbd
;#f::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://share.exonar.net/home.php"
;return

;; winkey + g	: tbd
;#g::Run "C:\Program Files\Git\git-bash.exe" --cd-to-home
;return

;;winkey + j	: tbd
;#j::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://..."
;return

; DO NOT USE winkey + l BECAUSE WE NEED TO KEEP DEFAULT BEHAVIOUR - I.E. TO LOCK LAPTOP!
;; winkey + l	: not used

;; winkey + m	: tbd
;#m::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://jclough.exonar.net/files/ExonarUserGuide-v1.3.pdf"
;return

; winkey + n	: Notepad++
#n::Run "notepad++"
return

;; winkey + o	: tbd
;return

;; winkey + p	: Login with username and password
;#p::
;Send, exonar
;Send, {TAB}
;Send, Discovery!1
;Send, {TAB}
;Send, {ENTER}
;return

; winkey + p	: Load Pivotal at the highlighed RPI.
#p::
oCB = %clipboard% 
clipboard = 
Send, ^c
ClipWait
oTXT = %clipboard%
clipboard = %oCB%
Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window http://pivotalrpi/rpi.asp?w=1&r=%oTXT%
return

; winkey + s	: Faststone capture
#s::Run "C:\Program Files (x86)\FastStone Capture\FSCapture.exe"
return

;; winkey + t	: tbd
;return

;; winkey + u	: tbd
;return

;; winkey + v	: tbd
;return

; winkey + w	: Microsoft Word
#w::Run "winword.exe"
return

;; winkey + z	: tbd
;#z::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://exonar.zendesk.com/"
;return

; winkey + 0	: Open Windows Startup folder
#0::Run "explorer.exe" "C:\Users\jclough\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
return

; winkey + 1	: Calculate total transactions.
#1::
clipboard = ; Empty the clipboard
Send ^a ; select all text
sleep 100
send ^c	; copy the selected text
ClipWait, 2
if ErrorLevel
{
    MsgBox, The attempt to copy text onto the clipboard failed.
    return
}
screen_text=%clipboard%
trans_total=0
Loop, parse, screen_text, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
{
	;msgbox, [%A_LoopField%]
	line = %A_LoopField%

	If InStr(line, "New Order Transactions:")
		trans_total += extractNumber(line)
	If InStr(line, "Payment Transactions:")
		trans_total += extractNumber(line)
	If InStr(line, "Delivery Transactions:")
		trans_total += extractNumber(line)
	If InStr(line, "Order Status Transactions:")
		trans_total += extractNumber(line)
	If InStr(line, "Stock Level Transactions")
		trans_total += extractNumber(line)
}
clipboard=%trans_total%
MsgBox % "Total (copied to clipboard): " . trans_total
return

; Used when calculating total transactions.
; https://www.autohotkey.com/docs/commands/RegExMatch.htm
extractNumber(str) {
	If RegExMatch(str, "O)(.*)\s+([0-9\.,]+)", SubPat)
		return SubPat.Value(2)
	return str
}

;; winkey + 2	: tbd
;return

;; winkey + 3	: tbd
;#3::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://167.99.80.221/"
;return

;; winkey + 4	: tbd
;#4::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://demo.exonar.net/"
;return

;; winkey + 5	: tbd
;#5::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://showcase.exonar.net/"
;return

;; winkey + 6	: tbd
;#6::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://exonar.atlassian.net/wiki/spaces/~532957535/pages/672628737/Useful+commands"
;return

;; winkey + 7	: tbd
;#7::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "file:///C:/ex_My_stuff/Architecture/Ben_presentation.jpg"
;return

;; winkey + 8	: tbd
;#8::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://docs.google.com/drawings/d/1F9JQuAQDZrFBvvzP3cruhax70mVMPd1pgPeJT4PvpcU/edit"
;return

;; winkey + 9	: tbd
;#9::Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --new-window "https://exonar.atlassian.net/wiki/spaces/devops/pages/1082818572/Process+Dependencies"
;return

;InvokeVerb(path, menu, validate=True) {
;;by A_Samurai
;;v 1.0.1 http://sites.google.com/site/ahkref/custom-functions/invokeverb
;    objShell := ComObjCreate("Shell.Application")
;    if InStr(FileExist(path), "D") || InStr(path, "::{") {
;        objFolder := objShell.NameSpace(path)   
;        objFolderItem := objFolder.Self
;    } else {
;        SplitPath, path, name, dir
;        objFolder := objShell.NameSpace(dir)
;        objFolderItem := objFolder.ParseName(name)
;    }
;    if validate {
;        colVerbs := objFolderItem.Verbs   
;        loop % colVerbs.Count {
;            verb := colVerbs.Item(A_Index - 1)
;            retMenu := verb.name
;            StringReplace, retMenu, retMenu, &       
;            if (retMenu = menu) {
;                verb.DoIt
;                Return True
;            }
;        }
;        Return False
;    } else
;        objFolderItem.InvokeVerbEx(Menu)
;}

;;winkey + x	: Copy file to paste buffer.
;#x::InvokeVerb("C:\mystuff\Jeremys_Share\CW_Tools\cwtools.jar", "Copy")
;return

;; winkey + t	: Save current email as text file and open in Notepad++
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

;; winkey + m	: Launch notepad and paste currently selected text.
;#m::
;{
;    savedclipboard=%clipboard%
;    Send, ^c
;    selection=%clipboard%
;    clipboard=%savedclipboard%
;    savedclipboard=
;    Run "C:\Windows\system32\notepad.exe"
;    WinWait, Untitled - Notepad
;    Send, ^v
;    return
;}

;#IfWinActive ahk_class ExploreWClass|CabinetWClass
;    return
;#IfWinActive

;#k::
;   selection := FC("explorer","","selection")
;   MsgBox selection
;return
