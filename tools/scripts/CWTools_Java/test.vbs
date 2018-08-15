' Description:
'	Test script to verify that it can be called from a jar file.
'
' Usage example:
'	cscript /nologo test.vbs	
'

WScript.Echo "test.vbs successfull called!"
WScript.Echo "Arguments:"
Set args = WScript.Arguments
For Each a in args
	WScript.Echo a
Next
