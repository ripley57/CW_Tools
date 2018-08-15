'Description:
' Functions to do the following with Window shortcuts:
'     1. Create Window shortcut.
'     2. Delete Window shortcut.
'     3. Move Window shortcut.
'
'References:
' Nice example showing the shortcut options available:
'     https://msdn.microsoft.com/en-us/library/xsy6k3ys(v=vs.84).aspx
' Microsoft shortcut lnk binary format download:
'     https://msdn.microsoft.com/en-us/library/dd871305.aspx
'
'JeremyC 11/12/2016.


Function usage()
	WScript.Echo
	WScript.Echo "Description:"
	WScript.Echo "  vbscript functions for creating Windows shortcuts."
	WScript.Echo
	WScript.Echo "Usage examples:"
	WScript.Echo "  cscript shortcuts.vbs /addusefulshortcuts:yes"
	WScript.Echo "  cscript shortcuts.vbs /removeusefulshortcuts:yes"
	WScript.Echo "  cscript shortcuts.vbs /rununittests:yes"
	WScript.Echo "  cscript shortcuts.vbs /create:yes /destdirspecial:Desktop"
	WScript.Echo "                        /destdir2:folder1 /linkname:test.lnk"
	WScript.Echo "                        /description:""My link"""
	WScript.Echo "                        /target:""C:\Windows\System32\services.msc\"""
	WScript.Echo "  cscript shortcuts.vbs /delete:yes /sourcedirspecial:Desktop"
	WScript.Echo "                        /sourcedir2:folder1 /filename:test.lnk"
	WScript.Echo "  cscript shortcuts.vbs /move:yes /sourcedirspecial:Desktop"
	WScript.Echo "                        /sourcedir2:folder1 /filename:test.lnk"
	WScript.Echo "                        /destdirspecial:Desktop /destdir2:folder2"
	WScript.Echo "  cscript shortcuts.vbs /launch:yes /sourcedirspecial:Desktop"
	WScript.Echo "                        /sourcedir2:""My Shortcuts"" /linkname:test.lnk"
	WScript.Echo
End Function


' Description:
'   Move a file from one directory to another.
'
' Arguments:
'   sSourceDirSpecial	:	Optional. Special folder name such as "Desktop".
'                           This folder path is expanded if it is specified.
'   sSourceDir2			:	Optional. Source folder. If sSourceDirSpecial was
'                           specified, this path is appended to it.
'   sFileName			:	Name of the source file. 
'   sDestDirSpecial		:	Optional. Special folder name such as "Desktop".
'                           This folder path is expanded if it is specified.
'   sDestDir2			:	Optional. Destination folder. If sDestDirSpecial 
'                           was specified, this path is appended to it.
' Example:
'   private_movefile "Desktop", "", "test link.lnk", "Desktop", "testdir2"
'
Function private_movefile(sSourceDirSpecial, sSourceDir2, sFileName, sDestDirSpecial, sDestDir2)
	Dim objShell, objFSO, sSourcePath, sDestDir, sDestPath

	Set objShell = WScript.CreateObject("WScript.Shell")
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Expand special folder paths, if specified.
	If Len(sSourceDirSpecial) > 0 Then
		sSourceDirSpecial = objShell.SpecialFolders(sSourceDirSpecial) & "\" 
	End If
	If Len(sDestDirSpecial) > 0 Then
		sDestDirSpecial = objShell.SpecialFolders(sDestDirSpecial) & "\"
	End If

	sSourcePath = sSourceDirSpecial &  sSourceDir2 & "\" & sFileName
 	sDestDir = sDestDirSpecial & "\" & sDestDir2
	
	'Create destination directory if it does not exist.
	If Not objFSO.FolderExists(sDestDir) Then
		objFSO.CreateFolder(sDestDir)
	End If
	
	sDestPath = sDestDir & "\" & sFileName
	
	'Debugging
	'WScript.Echo "sSourcePath=" & sSourcePath
	'WScript.Echo "sDestPath=" & sDestPath
	
	If Not objFSO.FileExists(sDestPath) Then
		objFSO.MoveFile sSourcePath, sDestPath
	Else
		'WScript.Echo "ERROR: private_movefile: File already exists: " & sDestPath
	End If
End Function


' Description:
'   Delete a file.
'
' Arguments:
'   sSourceDirSpecial	:	Optional. Special folder name such as "Desktop".
'                           This folder path is expanded if it is specified.
'   sSourceDir2			:	Optional. Source folder. If sSourceDirSpecial was
'                           specified, this path is appended to it.
'   sFileName			:	Name of the file.
'
' Example:
'   private_deletefile "Desktop", "", "test link.lnk"
' 
Function private_deletefile(sSourceDirSpecial, sSourceDir2, sFileName)
	Dim objShell, objFSO, sSourcePath, sDestPath

	Set objShell = WScript.CreateObject("WScript.Shell")
	Set objFSO = CreateObject("Scripting.FileSystemObject")

	'Expand special folder path, if specified.
	If Len(sSourceDirSpecial) > 0 Then
		sSourceDirSpecial = objShell.SpecialFolders(sSourceDirSpecial) & "\" 
	End If

	sSourcePath = sSourceDirSpecial & sSourceDir2 & "\" & sFileName
	
	'Debugging
	'WScript.Echo "sSourcePath=" & sSourcePath
	
	If objFSO.FileExists(sSourcePath) Then
		objFSO.DeleteFile(sSourcePath)
	End If
End Function


' Description:
'   Create a Windows shortcut.
'
'  Arguments:
'   sDestDirSpecial		:	Optional. Special folder name such as "Desktop".
'                           This folder path is expanded if it is specified.
'   sDestDir2			:	Optional. Source folder. If sDestDirSpecial was
'                           specified, this path is appended to it.
'   sLinkName			:	Name of the file. 
'   sSourcePath			:	Target of the shortcut.
'   sDescription		:	Description name for shortcut.
'
' Example:
'   private_createshortcut "Desktop", "", "test link.lnk", "C:\Windows\System32\services.msc", "My description"
'
Function private_createshortcut(sDestDirSpecial, sDestDir2, sLinkName, sSourcePath, sDescription, sArguments)
	Dim objShell, objFSO, sDestPath, objShortcut, sDestDir
	
	Set objShell = WScript.CreateObject("WScript.Shell")
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'Expand special folder path, if specified.
	If Len(sDestDirSpecial) > 0 Then
		sDestDirSpecial = objShell.SpecialFolders(sDestDirSpecial) & "\" 
	End If

	sDestDir = sDestDirSpecial & "\" & sDestDir2
	
	'Create destination directory if it does not exist.
	If Not objFSO.FolderExists(sDestDir) Then
		objFSO.CreateFolder(sDestDir)
	End If
	
	sDestPath = sDestDirSpecial & "\" & sDestDir2 & "\" & sLinkName

	WScript.Echo "Creating shortcut:  "  & sDestPath & " ..."
	
	'Debugging
	'WScript.Echo "sDestPath=" & sDestPath
	'WScript.Echo "sSourcePath=" & sSourcePath
	
	If Not objFSO.FileExists(sSourcePath) Then
		WScript.Echo "WARNING: Shortcut path not found: " & sSourcePath
	End If
		
	Set objShortcut = objShell.CreateShortcut(sDestPath)
	objShortcut.TargetPath = sSourcePath
	objShortcut.Description = sDescription
	objShortcut.Arguments = sArguments
	objShortcut.Save	
End Function


' Description:
'   Run test to check the functions in this script.
'
' Example:
'   cscript shortcuts.vbs /rununittests:yes
'
Function public_rununittests()
	Dim objShell, objFSO, sPath
	
	'1. If present, delete the existing shortcut "test link.lnk" from the desktop.
	private_deletefile "Desktop", "", "test link.lnk"

	'2. Create new shortcut "test link.lnk" on the desktop.
	private_createshortcut "Desktop", "", "test link.lnk", "C:\Windows\System32\services.msc", "My description", ""

	'3. Move our new shortcut into a sub-directory "testdir2" on the desktop.
	private_movefile "Desktop", "", "test link.lnk", "Desktop", "testdir2"
	
	'Verify that the shortcut created actually exists.
	Set objShell = WScript.CreateObject("WScript.Shell")
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	sPath = objShell.SpecialFolders("Desktop") & "\testdir2\test link.lnk"  
	If objFSO.FileExists(sPath) Then
		WScript.Echo "rununittests: PASS"
	Else
		WScript.Echo "rununittests: FAIL"
	End If
End Function


' Description:
'   Create useful shortcuts (in a folder named "My Shortcuts" on the desktop).
'
' Examples:
'   cscript shortcuts.vbs /addusefulshortcuts:yes
'
Function public_addusefulshortcuts()
	private_createshortcut "Desktop", "My Shortcuts", "services.lnk",  "C:\Windows\System32\services.msc", "My link to services", ""
	private_createshortcut "Desktop", "My Shortcuts", "lusrmgr.lnk",   "C:\Windows\System32\lusrmgr.msc",  "My link to lusrmgr", ""
	private_createshortcut "Desktop", "My Shortcuts", "taskmgr32.lnk", "C:\Windows\SysWOW64\Taskmgr.exe",  "My link to 32-bit Taskmgr", ""
	private_createshortcut "Desktop", "My Shortcuts", "windbgx86.lnk", "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe", "My link to windbg x86", ""
End Function


' Description:
'   Remove the useful shortcuts.
'
' Examples:
'   cscript shortcuts.vbs /removeusefulshortcuts:yes
'
Function public_removeusefulshortcuts()
	private_deletefile "Desktop", "My Shortcuts", "services.lnk"
	private_deletefile "Desktop", "My Shortcuts", "lusrmgr.lnk"
	private_deletefile "Desktop", "My Shortcuts", "taskmgr32.lnk"
	private_deletefile "Desktop", "My Shortcuts", "windbgx86.lnk"
End Function


' Description:
'	Launch a shortcut from the desktop.
'
'  Arguments:
'   sSourceDirSpecial	:	Optional. Special folder (either "Desktop" or "AllUsersDeksop").
'   sSourceDir2			:	Optional. Sub-folder. 
'   sLinkName			:	Name of the shortcut file. 
'
' Example:
'   private_launchshortcut "Desktop", "", "test.lnk"
Function private_launchshortcut(sSourceDirSpecial, sSourceDir2, sLinkName)
	Dim objShell, objFSO, sSourcePath

	Set objShell = WScript.CreateObject("WScript.Shell")
	Set objFSO = CreateObject("Scripting.FileSystemObject")

	'Expand special folder path, if specified.
	If Len(sSourceDirSpecial) > 0 Then
		sSourceDirSpecial = objShell.SpecialFolders(sSourceDirSpecial) & "\" 
	End If

	sSourcePath = sSourceDirSpecial & sSourceDir2 & "\" & sLinkName
	
	'Debugging
	'WScript.Echo "sSourcePath=" & sSourcePath
	
	If objFSO.FileExists(sSourcePath) Then
		objShell.Run sSourcePath
	Else
		WScript.Echo "ERROR: private_launchshortcut: No such file: " & sSourcePath
	End If
End Function


' Description:
'   Launch a shortcut from the desktop.
'
' Example:
'   cscript shortcuts.vbs /launch:yes /sourcedirspecial:Desktop /sourcedir2:"My Shortcuts" /linkname:test.lnk
Function public_launchshortcut()
	Dim sSourceDirSpecial, sSourceDir2, sLinkName
	
	sSourceDirSpecial = colNamedArguments.Item("sourcedirspecial")
	assertdefined sSourceDirSpecial, "sourcedirspecial"
	
	sSourceDir2 = colNamedArguments.Item("sourcedir2")
	'Optional: Can be empty. assertdefined sSourceDir2, "sourcedir2"
	
	sLinkName = colNamedArguments.Item("linkname")
	assertdefined sLinkName, "linkname"

	private_launchshortcut sSourceDirSpecial, sSourceDir2, sLinkName
End Function


' Description:
'   Helper function to check that argument is defined.
Function assertdefined(arg, argname)
	If arg = "" Then
		WScript.Echo
		WScript.Echo "ERROR: Argument not defined: " & argname
		WScript.Echo
		usage
		WScript.Quit
	End If
End Function

' Description:
'   Create a shortcut.
'
' Example:
'   cscript shortcuts.vbs /create:yes /destdirspecial:Desktop /destdir2:folder1 \
'                         /linkname:test.lnk /description:"My link" /target:"C:\Windows\System32\services.msc"
Function public_createshortcut()
	Dim sDestDirSpecial, sDestDir2, sLinkName, sDescription, sTarget, sArguments
	
	sDestDirSpecial = colNamedArguments.Item("destdirspecial")
	assertdefined sDestDirSpecial, "destdirspecial"
	
	sDestDir2 = colNamedArguments.Item("destdir2")
	'Optional: Can be empty. assertdefined sDestDir2, "destdir2"
	
	sLinkName = colNamedArguments.Item("linkname")
	assertdefined sLinkName, "linkname"
	
	sDescription = colNamedArguments.Item("description")
	assertdefined sDescription, "description"
	
	sTarget = colNamedArguments.Item("target")
	assertdefined sTarget, "target"
	
	sArguments = colNamedArguments.Item("arguments")
	
	private_createshortcut sDestDirSpecial, sDestDir2, sLinkName, sTarget, sDescription, sArguments
End Function


' Description:
'   Delete a shortcut.
'
' Example:
'   cscript shortcuts.vbs /delete:yes /sourcedirspecial:Desktop /sourcedir2:folder1 /filename:test.lnk 
'
Function public_deleteshortcut()
	Dim sSourceDirSpecial, sSourceDir2, sFileName
	
	sSourceDirSpecial = colNamedArguments.Item("sourcedirspecial")
	assertdefined sSourceDirSpecial, "sourcedirspecial"
	
	sSourceDir2 = colNamedArguments.Item("sourcedir2")
	'Optional: Can be empty. assertdefined sSourceDir2, "sourcedir2"
	
	sFileName = colNamedArguments.Item("filename")
	assertdefined sFileName, "filename"
	
    private_deletefile sSourceDirSpecial, sSourceDir2, sFileName
End Function


' Description:
'   Move a shortcut.
'
' Example:
'   cscript createShortcuts.vbs /move:yes /sourcedirspecial:Desktop /sourcedir2:folder1 \
'                               /filename:test.lnk /destdirspecial:Desktop /destdir2:folder2
'
Function public_moveshortcut()
	Dim sSourceDirSpecial, sSourceDir2, sFileName, sDestDirSpecial, sDestDir2
	
	sSourceDirSpecial = colNamedArguments.Item("sourcedirspecial")
	assertdefined sSourceDirSpecial, "sourcedirspecial"
	
	sSourceDir2 = colNamedArguments.Item("sourcedir2")
	'Optional: Can be empty. assertdefined sSourceDir2, "sourcedir2"
	
	sFileName = colNamedArguments.Item("filename")
	assertdefined sFileName,"filename"
	
	sDestDirSpecial = colNamedArguments.Item("destdirspecial")
	assertdefined sDestDirSpecial, "destdirspecial"
	
	sDestDir2 = colNamedArguments.Item("destdir2")
	'Optional: Can be empty. assertdefined sDestDir2, "destdir2"
	
	private_movefile sSourceDirSpecial, sSourceDir2, sFileName, sDestDirSpecial, sDestDir2
End Function


'
'Start of the main script.
'

Set args = WScript.Arguments
If args.Count < 1 Then
	usage
End If

Set colNamedArguments = WScript.Arguments.Named
If colNamedArguments.Exists("rununittests") Then
	public_rununittests
End If
If colNamedArguments.Exists("addusefulshortcuts") Then
	public_addusefulshortcuts
End If
If colNamedArguments.Exists("removeusefulshortcuts") Then
	public_removeusefulshortcuts
End If
If colNamedArguments.Exists("create") Then
	public_createshortcut
End If
If colNamedArguments.Exists("delete") Then
	public_deleteshortcut
End If
If colNamedArguments.Exists("move") Then
	public_moveshortcut
End If
If colNamedArguments.Exists("launch") Then
	public_launchshortcut
End If
