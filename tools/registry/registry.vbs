'Description:
'  Functions to update the registry.
'
'Example usage:
'  cscript /nologo registry.vbs /operation:setdword /root:hkcu /key:"Console\01 - Command Prompt" /name:QuickEdit /value:1
'  cscript /nologo registry.vbs /operation:getdword /root:hkcu /key:"Console\01 - Command Prompt" /name:QuickEdit
'
'JeremyC 21/1/2017

class VBSReg
    public objReg
	
	public HKEY_CLASSES_ROOT
	public HKEY_CURRENT_USER
	public HKEY_LOCAL_MACHINE
	public HKEY_USERS
	
	private dictrootkeys
	
	private sub populatedictrootkeys()
		Set dictrootkeys = CreateObject("scripting.dictionary")
		with dictrootkeys
				.add "HKCR", HKEY_CLASSES_ROOT
				.add "HKCU", HKEY_CURRENT_USER
				.add "HKLM", HKEY_LOCAL_MACHINE
				.add "HKU",  HKEY_USERS
		end with
	end sub
	
	private sub checkrootkey(strrootkey)
		If Not dictrootkeys.Exists(UCase(strrootkey)) Then
			WScript.Echo "Bad root registry key name: " & strrootkey
			WScript.Quit
		End If
	end sub
	
	public sub Class_Initialize()
		HKEY_CLASSES_ROOT 	= &H80000000
		HKEY_CURRENT_USER 	= &H80000001
		HKEY_LOCAL_MACHINE 	= &H80000002
		HKEY_USERS 			= &H80000003
		
		populatedictrootkeys
		
		If IsObject(objReg) = False Then
			Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
		End If
	end sub
	
    public sub Class_terminate()
		If IsObject(objReg) = True Then
			Set objReg = Nothing
		End If
    end sub
		
	public sub setdword(strrootkey, strregkeyname, strvaluename, dwvalue)
		checkrootkey(strrootkey)
		objReg.SetDWORDValue dictrootkeys(UCase(strrootkey)),strregkeyname,strvaluename,dwvalue
		If Err <> 0 Then
			WScript.Echo "Error setting DWORD value = " & Err.Number
		End If
	end sub
	
	public function getdword(strrootkey, strregkeyname, strvaluename)
		Dim dwvalue
		checkrootkey(strrootkey)
		objReg.getDWORDValue dictrootkeys(UCase(strrootkey)),strregkeyname,strvaluename,dwvalue
		If Err <> 0 Then
			WScript.Echo "Error getting DWORD value = " & Err.Number
		End If
		getdword = dwvalue
	end function
	
	public sub setstring(strrootkey, strregkeyname, strvaluename, strvalue)
		Dim arrSubKeys
		checkrootkey(strrootkey)
		
		'Create the registry key if it does not currently exist.
		If Not objReg.EnumKey(dictrootkeys(UCase(strrootkey)),strregkeyname,arrSubKeys) = 0 Then
			objReg.CreateKey dictrootkeys(UCase(strrootkey)),strregkeyname
		End If
		
		objReg.SetStringValue dictrootkeys(UCase(strrootkey)),strregkeyname,strvaluename,strvalue
		If Err <> 0 Then
			WScript.Echo "Error setting string value = " & Err.Number
		End If
	end sub
	
	public function getstring(strrootkey, strregkeyname, strvaluename)
		Dim strvalue, arrSubKeys
		checkrootkey(strrootkey)
		
		'We will only try and get the value if the registry key exists.
		If objReg.EnumKey(dictrootkeys(UCase(strrootkey)),strregkeyname,arrSubKeys) = 0 Then
			objReg.getStringValue dictrootkeys(UCase(strrootkey)),strregkeyname,strvaluename,strvalue
			If Err <> 0 Then
				WScript.Echo "Error getting string value = " & Err.Number
			End If
			getstring = strvalue
		Else
			WScript.Echo "Warning: Registry key not found: " & UCase(strrootkey) & "\" & strregkeyname
			getstring = ""
		End If
	end function
	
end class

set regkeysetup = new VBSReg

sub assertdefined(arg, argname)
	If arg = "" Then
		WScript.Echo
		WScript.Echo "ERROR: Argument not defined: " & argname
		WScript.Echo
		usage
		WScript.Quit
	End If
end sub

sub setdword(args)
	Dim root, key, name, value
	assertdefined args.Item("root"),"root"
	assertdefined args.Item("key"),"key"
	assertdefined args.Item("name"),"name"
	assertdefined args.Item("value"),"value"
	regkeysetup.setdword args.Item("root"), args.Item("key"), args.Item("name"), args.Item("value")
end sub

sub getdword(args)
	Dim root, key, name, value
	assertdefined args.Item("root"),"root"
	assertdefined args.Item("key"),"key"
	assertdefined args.Item("name"),"name"
	value = regkeysetup.getdword(args.Item("root"), args.Item("key"), args.Item("name"))
	WScript.Echo value
end sub

sub setstring(args)
	Dim root, key, name, value
	assertdefined args.Item("root"),"root"
	assertdefined args.Item("key"),"key"
	assertdefined args.Item("name"),"name"
	assertdefined args.Item("value"),"value"
	regkeysetup.setstring args.Item("root"), args.Item("key"), args.Item("name"), args.Item("value")
end sub

sub getstring(args)
	Dim root, key, name, value
	assertdefined args.Item("root"),"root"
	assertdefined args.Item("key"),"key"
	assertdefined args.Item("name"),"name"
	value = regkeysetup.getstring(args.Item("root"), args.Item("key"), args.Item("name"))
	WScript.Echo value
end sub

function usage()
	WScript.Echo
	WScript.Echo "Usage examples:"
	WScript.Echo "  cscript registry.vbs /operation:setdword  /root:hkcu /key:""\Console\01 - Command Prompt"" /name:QuickEdit /value:1"
	WScript.Echo "  cscript registry.vbs /operation:setstring /root:hkcu /key:""\Software\CW_Tools"" /name:BGInfo_Text /value:""some text"""
	WScript.Echo "  cscript registry.vbs /operation:getstring /root:hkcu /key:""\Software\CW_Tools"" /name:BGInfo_Text"
	WScript.Echo
end function


''
'' Main start of script.
''

Set colNamedArguments = WScript.Arguments.Named
Set args = WScript.Arguments

'Display the script usage message. 
Select Case True
Case args.Count = 0
	usage
	WScript.Quit
Case (args.Count = 1) And (args.Item(0) = "/help")
	usage
	WScript.Quit
End Select

If colNamedArguments.Exists("operation") Then	
	arg_operation = colNamedArguments.Item("operation")
	Select Case True
	Case arg_operation = "setdword"
		setdword colNamedArguments
	Case arg_operation = "getdword"
		getdword colNamedArguments
	Case arg_operation = "setstring"
		setstring colNamedArguments	
	Case arg_operation = "getstring"
		getstring colNamedArguments
	Case Else
		WScript.Echo VbCrLf & "ERROR: Bad operation (" & arg_operation & ")"
		WScript.Quit
	End Select
End If
