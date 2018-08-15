'Description:
'	Set the "QuickEdit" flag in the registry (under HKEY_CURRENT_USER\Console) to 1.
'	This will enable the "QuickEdit Mode" setting for the CMD window.
' 
'	Note: 	This enables the "QuickEdit Mode" under the CMD window "Default" option, 
'			and not the "QuickEdit Mode" under the CMD window "Properties option.
'			This therefore means that the change will apply to all future CMD 
'			windows auotmatically. See: 
'			http://www.winhelponline.com/blog/enable-quick-edit-command-prompt-by-default/
'Usage:
'	cscript /nologo quickedit.vbs
'
'References:
'	https://msdn.microsoft.com/en-us/library/aa394600(v=vs.85).aspx
'	https://msdn.microsoft.com/en-us/library/aa393297(v=vs.85).aspx
'
'JeremyC 14/1/2017
		
const HKEY_CURRENT_USER = &H80000001

Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")

strKeyPath = "Console"
strValueName = "QuickEdit"

oReg.GetDWORDValue HKEY_CURRENT_USER,strKeyPath,strValueName,dwValue

If dwValue = 0 Then
	WScript.Echo "Setting QuickEdit to 1 ..."
	oReg.SetDWORDValue HKEY_CURRENT_USER,strKeyPath,strValueName,1
Else
	WScript.Echo "QuickEdit already set to 1"
End If
