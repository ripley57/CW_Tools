''
'' Description:
''	VBscript to be called from bginfo.exe to
''	display usseful information on the desktop.
''
'' Additional examples can be found here:
''	http://www.jasemccarty.com/blog/a-few-bginfo-vbscripts-for-my-vms/
''
'' JeremyC 10-12-2017
''

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20
const HKEY_CURRENT_USER = &H80000001
 
'*** Connect to this PC's WMI Service
Set objWMI = GetObject("winmgmts:\\.\root\CIMV2")
Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
 
Function GetWindowsVersion()
	Set Items = objWMI.ExecQuery("SELECT Caption FROM Win32_OperatingSystem",_
								 "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)
 	For Each Item In Items
		strWinVer = Item.Caption 'What we're after
	Next
 
	'*** Clean up the text
	strWinVer = Replace(strWinVer,"Microsoft","") 'strip off MSFT
	strWinVer = Replace(strWinVer,"(R)","") 'strip off (R)
	strWinVer = Trim(strWinVer) ' Remove leading/trailing spaces
 
	If Len(strWinVer) = 0 Then strWinVer = "Not Found in WMI"
 	Set WSHShell = CreateObject("WScript.Shell")
 	If Right(ProductName,2) = "R2" Then
		strWinVer = Replace(strWinVer,", "," R2, ")
	End If
	GetWindowsVersion = strWinVer
End Function 

Function GetUserName()
	Set objNetwork = CreateObject("Wscript.Network")
	GetUserName = objNetwork.UserName
End Function

Function GetHostName()
	Set colitems = objWMI.ExecQuery("Select * from Win32_ComputerSystem" )
	For Each objItem in colItems
		GetHostName = objItem.DNSHostName
	Next
End Function

'Determine path to text file for extra text to display in the
'bginfo.exe output. The path is read from the registry.
Function GetTextFilePath()
	strKeyPath = "Software\CW_Tools"
	strValueName = "BGInfo_TextFilePath"
	objReg.GetStringValue HKEY_CURRENT_USER,strKeyPath,strValueName,strValue
	If IsNull(strValue) Then
		strValue = "Text File Not Found"
	End If
	GetTextFilePath = strValue
End Function

'Return contents of text file containing additional 
'hard-coded text to display in the bginfo.exe output.
Function GetTextFile()
	Set objFS = CreateObject("Scripting.fileSystemObject")
	strFilePath = GetTextFilePath
	If objFS.FileExists(strFilePath) Then
		strNotes = ""
		Set objIN = objFS.OpenTextFile(strFilePath,1)
		inputData = Split(objIN.ReadAll, vbNewline)
 		For each strData In inputData
			strNOTES = strNOTES & strData & vbcrlf
		Next
 		objIN.Close
		GetTextFile = StrNotes
	Else
		GetTextFile = "Text File Not Found"
	End If
	Set objFS = Nothing
End Function

''Alternative to storing additional bginfo text in a file. 
''Instead we store the text in the Windows Registry.
Function GetText()
	strKeyPath = "Software\CW_Tools"
	strValueName = "BGInfo_Text"
	objReg.GetStringValue HKEY_CURRENT_USER,strKeyPath,strValueName,strValue
	If NOT IsNull(strValue) Then
		GetText = " | " &  strValue
	Else
		GetText = ""
	End If
End Function

''Get the username of the EsaApplicationService.
Function GetEsaUserName()
	Dim strUserName
	Set colitems = objWMI.ExecQuery("Select * from Win32_Service WHERE Name = 'EsaApplicationService'")
	For Each item in colitems
		strUserName = item.StartName
	Next
	If Len(strUserName) > 0 Then
		GetEsaUserName = " | esauser: " & strUserName
	Else
		GetEsaUserName = ""
	End If
End Function

''Get string we saved in registry that lists components enabled for debug.
Function GetDebugComps()
	strKeyPath = "Software\CW_Tools"
	strValueName = "BGInfo_Debugcomps"
	objReg.GetStringValue HKEY_CURRENT_USER,strKeyPath,strValueName,strValue
	If NOT IsNull(strValue) Then
		GetDebugComps = " | debugcomps: " & strValue
	Else
		GetDebugComps = ""
	End If
End Function

''Determine the IP v4 address. 
Function GetIPv4Address()
    strIP = ""
    Set setIPConfig = objWMI.ExecQuery("Select IPAddress from Win32_NetworkAdapterConfiguration WHERE IPEnabled = 'True'")
    For Each ipConfig in setIPConfig
        If Not IsNull(ipConfig.IPAddress) Then
			''We will ignore IPv6 addresses (we assume these contain a ":").
            For i = LBound(ipConfig.IPAddress) to UBound(ipConfig.IPAddress)
               If Not Instr(ipConfig.IPAddress(i), ":") > 0 Then
                   strIP = strIP & " " & ipConfig.IPAddress(i)
               End If
            Next
        End If
    Next
	GetIPv4Address = strIP
End Function

''Note: Replace Echo with WScript.Echo if you want to run this script directly on the command-line
''      (using "cscript //nologo bginfo_vbscript1.vbs"), but change it back aftwards, because 
''      otherwise bginfo.exe will error when it runs this script.
Echo "" & GetHostName & " |" & GetIPv4Address & " | login: " & GetUserName & GetEsaUserName & GetDebugComps & GetText
