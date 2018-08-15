' Description:
'   Display file time properties.
'
' JeremyC 11th Nov 2013.

Sub Usage
    Wscript.Echo "Program:"
	Wscript.Echo "   times.vbs"
	Wscript.Echo ""
    Wscript.Echo "Description:"
	Wscript.Echo "   Display file time properties"
	Wscript.Echo ""
	Wscript.Echo "Comments:"
	Wscript.Echo "   This program will not work with UNC paths"
	Wscript.Echo ""
	Wscript.Echo "Example"
	Wscript.Echo "   cscript times.vbs d:\filetimes\file.txt"
	Wscript.Echo ""
	Wscript.Echo "Name:          d:\filetimes\file.txt"
	Wscript.Echo "Creation date: 20131110124850.895856-300"
	Wscript.Echo "Last accessed: 20131110163232.180974-300"
	Wscript.Echo "Last modified: 20131029154133.373682-240"
	Wscript.Echo ""
	Wscript.Echo "Date-Time Format:"
	Wscript.Echo "Positions | Description"
	Wscript.Echo "----------|---------------------------------------------"
	Wscript.Echo "1-4       | Year, e.g. 2013"
	Wscript.Echo "5-6       | Month, e.g. 11"
	Wscript.Echo "7-8       | Day, e.g. 10"
	Wscript.Echo "9-14      | Hours, minutes, seconds, e.g. 163232"
	Wscript.Echo "15        | A period ."
	Wscript.Echo "16-21     | Milliseconds, e.g. 180974"
	Wscript.Echo "22-25     | Minutes difference between local time and GMT"
	Wscript.Quit
End Sub

If Wscript.Arguments.UnNamed.Count = 0 Then 
	Usage
End If
strArg1 = Wscript.Arguments.UnNamed(0)
If strArg1 = "-h" OR strArg1 = "-help" OR strArg1 = "/?" Then
	Usage
End If
strFileName = Wscript.Arguments.UnNamed(0)

strComputer = "."

' Backslashes need to be escaped.
strFileName = Replace(strFileName,"\","\\")

'Wscript.Echo "strComputer:   " & strComputer
'Wscript.Echo "strFileName:   " & strFileName

Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set oFiles = objWMIService.ExecQuery _
	("SELECT * FROM CIM_Datafile WHERE Name = '" & strFileName & "'")

For Each oFile in oFiles
	Wscript.Echo "Name:          " & oFile.Name
	Wscript.Echo ""
	Wscript.Echo "Creation date: " & oFile.CreationDate
	Wscript.Echo "Last accessed: " & oFile.LastAccessed
	Wscript.Echo "Last modified: " & oFile.LastModified
	Wscript.Echo ""
	Wscript.Echo "Readable:      " & oFile.Readable
	Wscript.Echo "Writeable:     " & oFile.Writeable
Next
