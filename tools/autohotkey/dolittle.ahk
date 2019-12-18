;
;Change History
; Add support for detecting 7 digital string containing 'q' as Microsoft article.


; EV Auto finder
; If 4 digits assume event id
; if 6 digits assume etrack
; if 7 digit and not contain Q presume Etrack.
; if 9 digits assume titan
; if 11 digit and - assume titan
; if 8004 mapi error code
; if contains the word hotfix, hotfix web site.
; if 7 digit and contains Q presume Microsoft KB

;F10 - Search vault
;F12 - Set default Vault ID.
;F1 - Try and recognise selected text and goto appropiate system to search
;Sample data
;2626
;123123
;281-124-984
;asda-todayasdadsasdasd
;281124984
;80040116
;80040109
; there is a hotfix that you can download for this.
; there is a lot of useful information in our wiki that you can find at

;https://na3.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?searchType=2&sen=a0o&sen=ka&sen=005&sen=001&sen=500&sen=003&str=
;120524-27103

;open wall-e
F2::
run https://na3.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?searchType=2&sen=a0o&sen=ka&sen=005&sen=001&sen=500&sen=003&str=
return

;open wall-e
F3::
run http://clearwell-vm.hosted.jivesoftware.com/index.jspa
return

;open wall-e
F4::
run http://jira-new.cw-test.com:8092/secure/Dashboard.jspa
return



F1::
; Lets see if anything is selected
clipboard=

;msgbox Clipboard is currently
x = %clipboard%

;msgbox %x%

  current_clipboard = %clipboard%
  sendinput ^c

  clipwait,2 ; wait for clipboard to contain data
  if ErrorLevel
   {
       goto NothingSelected
       return
   }

  now_clipboard = %clipboard%

;msgbox the clipboard is now
;msgbox %now_clipboard%

  if current_clipboard = %now_clipboard%
  {
   msgbox nothing selected
   msgbox %now_clipboard%
  }
  else
  {
  }

  targetnumoriginal = %now_clipboard%
  targetnum = %now_clipboard%
  ; remove all spaces
  stringreplace targetnum,targetnum,%A_SPACE%,,All
 
  ; remove any carriage returns
  stringreplace targetnum,targetnum,`r`n,,All
  StringLen, Targetlength, targetnum

 ;finished cleaning the string of text 

 
 


;If field is 6 characters presume it's an Etrack number
  if Targetlength = 6
      {
	ToolTip_Message = Going to the Etrack
	Gosub Display_ToolTip
   goto doEtrack
      }
	  
ifInString,Targetnumoriginal,esa-
        {
	ToolTip_Message = Going directly to jira database
	Gosub Display_ToolTip
         run http://jira-new.cw-test.com:8092/browse/%targetnumoriginal%
	 return
         }
	  
;If field is 7 characters presume it's an Etrack number
  if Targetlength = 7
      {
;If string contains 'q' presume it's a microsoft kb article number
        ifInString,Targetnumoriginal,Q
        {
	ToolTip_Message = Going to Microsoft Knowledge database.
	Gosub Display_ToolTip
         run http://support.microsoft.com/search/default.aspx?query=%targetnumoriginal%
	 return
         }
        else
        {
	ToolTip_Message = Going to Etrack
	Gosub Display_ToolTip
        goto doEtrack
        }
      }
	  
;If field is 9 characters presume it's an Etrack number
  if Targetlength = 9
      {
	ToolTip_Message = Going to the Titan
	Gosub Display_ToolTip
        goto doTitan

       } 
;If field is 11 characters presume it's an titan with dashes   
if Targetlength = 11
  {
   ifinstring, targetnum, `-
   {
	ToolTip_Message = Going to the Titan
	Gosub Display_ToolTip
    goto doTitan
   }
  }

 ;If field is 12 characters presume it's an SFDC with dashes  
  if Targetlength = 12
  {
   ;ifinstring, targetnum, `-
   {
	ToolTip_Message = Going to the salesforce
	Gosub Display_ToolTip
    goto dosalesforce
   }
  }


;----------------------------------------------------------------------
 ; look for ICO numbers ABC-1234
 
 iconum := RegExReplace(targetnumoriginal,".*?([a-zA-Z\d][a-zA-Z\d][a-zA-Z\d]-\d\d\d\d([.]\d)?)", "$1|") ; replace everything except numbers. use '|' as separator
 iconum := RegExReplace(iconum,"(.*)\|$","$1") ; lose trailing '|'
 
 ; launch ICOs
 loop parse, iconum, |
 {
  isnumber := RegExMatch(A_LoopField, "[a-zA-Z\d][a-zA-Z\d][a-zA-Z\d]-\d\d\d\d([.]\d)?")
 
  if isnumber = 1
  {
   tempiconum = %A_LoopField%
   IfNotInString,tempiconum,.
   {
    tempiconum=%tempiconum%.0
   }   
 	ToolTip_Message = Going to ICO Search tool
	Gosub Display_ToolTip
   run C:\Python23\pythonw.exe "c:\program files\ico bug search\icoedit.pyw" %tempiconum%
   return 
 }
 
 }
 
 
;;*****************
;;AT this point we have not been able to identify the selected term so we'll simply ask the user where they want to goto.

Gui,Add, Text ,,Could not identify selected text, please choose search engine

;Gui, Add, Button,, &EV Search
;Gui, Add, Button,, &DesktopSearch


Gui, Add, Button,, &SFDC

Gui, Add, Button,, &walle
Gui, Add, Button,, jira
Gui, Add, Button,, &Google
Gui, Add, Button,, &Enterprise Vault



Gui,Show,,Choose search destination

exit



ICOBugSearch:
  ToolTip_Message = Going to ICO Bug search application
  Gosub Display_ToolTip
  run C:\Python23\pythonw.exe "c:\program files\ico bug search\icoedit.pyw" %targetnumoriginal%

return
ButtonEVSearch:

   ToolTip_Message = Going to Enterprise Vault search
   Gosub Display_ToolTip
   run http://gdeskeng.gpk.rnd.veritas.com/search?q=%targetnumoriginal%

return

ButtonDesktopSearch:

   ToolTip_Message = Going to Google Desktop search
   Gosub Display_ToolTip
 

run "C:\Program Files\Windows Desktop Search\WindowsSearch.exe"  /launchsearchwindow


  sendinput {ctrl} + {ctrl}
  sleep 100
 
  sendinput {ctrl}
  sleep 100
;sendinput ^
;  sleep 10
;  sendinput %targetnumoriginal%
  
msgbox test1
exit



ButtonSFDC:

   ToolTip_Message = Going to the SFDC
   Gosub Display_ToolTip
   run https://na3.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?searchType=2&sen=a0o&sen=ka&sen=005&sen=001&sen=500&sen=003&str=%targetnumoriginal% 

return

Buttonjira:

   ToolTip_Message = Going to the Jira
   Gosub Display_ToolTip
   run http://jira-new.cw-test.com:8092/secure/IssueNavigator!executeAdvanced.jspa?

return

Buttonwalle:
;  	  		  	testmsgbox wall-e search
   ToolTip_Message = Going to search Etrack
   Gosub Display_ToolTip

   run http://clearwell-vm.hosted.jivesoftware.com/search.jspa?peopleEnabled=true&userID=&containerType=&container=&spotlight=true&q=%targetnumoriginal%

return


ButtonGoogle:

   ToolTip_Message = Going to search Google
   Gosub Display_ToolTip
   run http://www.google.co.uk/search?q=%targetnumoriginal%

return


ButtonEnterpriseVault:

RegRead, VaultID, HKEY_LOCAL_MACHINE, SOFTWARE\MikeApp\, VaultID
;msgbox %VaultID%

if strlen(VaultID) <> 0
{
   ToolTip_Message = Going to search Enterprise Vault
   Gosub Display_ToolTip
   run http://gpkentvlt1.veritas.com/EnterpriseVault/searcho2k.asp?adv=0&mode=&content=%targetnumoriginal%&vaultid=%VaultID%&sortkey=-date
   return
}
else
{
   msgbox You need to press F12 to specify your Vault ID before you can use this option.
   return
}



doEtrack:
 
  ;this must be an etrack
 
  ; get rid of any leading 'E'
  stringreplace, targetnum,targetnum,E,,All
 
  run https://engtools.veritas.com/Etrack/readonly_inc.php?incident=%targetnum%&database=etrack

   sleep 10000



 sendinput {shift tab}
 sendinput {tab}
 sendinput test


  goto finish
  
doTitan:
  ; get rid of any dashes
  stringreplace, targetnum,targetnum,-,,All
  run http://ast.ges.symantec.com/case/summary/case.html?id=%targetnum% 
  goto finish

dosalesforce:
  ; get rid of any dashes
  stringreplace, targetnum,targetnum,-,,All
  run https://na3.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?searchType=2&sen=a0o&sen=ka&sen=005&sen=001&sen=500&sen=003&str=%targetnumoriginal% 
  goto finish
 

 

finish:

return

NothingSelected:
; Goto this section if we determine nothing has been highlighted and so instead we are gong to auto highlight.

	click 3 ; triple-click to select current line

	; empty the clipboard
	clipboard =
	; sleep to give clipboard time to catch up
	sleep 100

	sendinput ^c ; copy selected line to clipboard
	clipwait,2 ; wait for clipboard to contain data

	if ErrorLevel
		{
			MsgBox, Failed to copy the text to the clipboard.
			return
		}


	targetstring = %clipboard%
	StringReplace, targetstring, targetstring, `r`n, , All



	;----------------------------------------------------------------------
	; look for titan numbers 123-123-123

	;msgbox %targetstring%
	titan := RegExReplace(targetstring,".*?(\d\d\d-\d\d\d-\d\d\d)", "$1|") ; replace everything except numbers. use '|' as separator
	;msgbox %titan%

	titan := RegExReplace(titan,"(.*)\|$","$1") ; lose trailing '|'

	;msgbox %titan%

	;stringsplit, alltitans, titan, |

	; launch titan cases
	loop parse, titan, |
	{
		isnumber := RegExMatch(A_LoopField, "\d\d\d-\d\d\d-\d\d\d")
		;msgbox %A_LoopField%
		if isnumber = 1
		{
	ToolTip_Message = Found Titan case reference ( %A_LoopField% ), going to Titan
	Gosub Display_ToolTip
		run	http://ast.ges.symantec.com/case/summary/case.html?id=%A_LoopField%
		}

	}

	;----------------------------------------------------------------------
	; look for etrack numbers (6 or 7 digits)

	etrack7 := RegExReplace(targetstring,".*?(\d\d\d\d\d\d\d)", "$1|") ; replace everything except numbers. use '|' as separator
	etrack7 := RegExReplace(etrack7,"(.*)\|$","$1") ; lose trailing '|'

	; strip all 7-digit numbers of string. i should be able to get 6 or 7 digit numbers with regex search, but fail :(
	etrack6string := RegExReplace(targetstring,"\d\d\d\d\d\d\d", " ") ; lose all 7-digit numbers

	etrack6 := RegExReplace(etrack6string,".*?(\d\d\d\d\d\d)", "$1|") ; replace everything except numbers. use '|' as separator
	etrack6 := RegExReplace(etrack6,"(.*)\|$","$1") ; lose trailing '|'

	; launch all the 7-digit etracks
	loop parse, etrack7, |
	{
		isnumber := RegExMatch(A_LoopField, "\d\d\d\d\d\d\d")
		if isnumber = 1
		{
	                ToolTip_Message = Found Etrack reference number ( %A_LoopField% ), going to Etrack
	                Gosub Display_ToolTip

			run https://engtools.veritas.com/Etrack/readonly_inc.php?incident=%A_LoopField%&database=etrack
		}

	}

	; launch all the 6-digit etracks
	loop parse, etrack6, |
	{
		isnumber := RegExMatch(A_LoopField, "\d\d\d\d\d\d")
		if isnumber = 1
		{
			ToolTip_Message = Found Etrack reference number ( %A_LoopField% ), going to Etrack
			Gosub Display_ToolTip

			run https://engtools.veritas.com/Etrack/readonly_inc.php?incident=%A_LoopField%&database=etrack
		}

	}

;----------------------------------------------------------------------
 ; look for ICO numbers ABC-1234
 
 iconum := RegExReplace(targetstring,".*?([a-zA-Z\d][a-zA-Z\d][a-zA-Z\d]-\d\d\d\d([.]\d)?)", "$1|") ; replace everything except numbers. use '|' as separator
 iconum := RegExReplace(iconum,"(.*)\|$","$1") ; lose trailing '|'
 
 ; launch ICOs
 loop parse, iconum, |
 {
  isnumber := RegExMatch(A_LoopField, "[a-zA-Z\d][a-zA-Z\d][a-zA-Z\d]-\d\d\d\d([.]\d)?")
 
  if isnumber = 1
  {
   tempiconum = %A_LoopField%
   IfNotInString,tempiconum,.
   {
    tempiconum=%tempiconum%.0
   }   
 
   run C:\Python23\pythonw.exe "c:\program files\ico bug search\icoedit.pyw" %tempiconum%
  }
 
 }
 


	goto finish




;;Search your archive for selected text
F10::
  ; empty the clipboard
  clipboard =
  ; sleep to give clipboard time to catch up
  sleep 100
 
  sendinput ^c
  clipwait,2 ; wait for clipboard to contain data
  if ErrorLevel
   {
       MsgBox, Failed to copy the text to the clipboard.
       return
   }
 ToolTip_Message = Going to Enterprise Vault Search
 Gosub Display_ToolTip

   targetnum = %clipboard%
   run http://gpkentvlt1.veritas.com/EnterpriseVault/searcho2k.asp?adv=0&mode=&content=%targetnum%&vaultid=%VaultID%&sortkey=-date

 
return
 



; To have a ToolTip disappear after a certain amount of time
; without having to use Sleep (which stops the current thread):


Display_ToolTip: 
ToolTip, %ToolTip_Message%
SetTimer, RemoveToolTip, 2000
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return







