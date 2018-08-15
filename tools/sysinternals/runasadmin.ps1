# Description:
#	Script to run a program as admin, by launching the program from a temporary shortcut
#   that has the "run as admin" bit set in the shortcut ".lnk" file. The shortcut file is 
#   deleted afterwards. 
#
#   This script is useful for running programs such as SystemInternals regjump.exe.
# 	This is not a problem on Windows Server 2008 when the user is a member of the 
#	administrators group. However, on a Windows 8.1 PC, running regjump.exe fails 
#	with the error: "Administrative privileges are required to open the path."
#
# Usage:
# 	powershell -executionpolicy RemoteSigned runasadmin.ps1 <programfilepath> <shortcutfilepath> <shortcutargs>
#
# Examples:
#	powershell -executionpolicy RemoteSigned D:\runasadmin.ps1 D:\regjump.exe D:\temp.lnk 'HKU'
#
# Rerefences:
#	Shorcut (.lnk) binary format:
#	https://msdn.microsoft.com/en-us/library/dd871305.aspx
#
# JeremyC 14/1/2017
 
param (
    [Parameter(Mandatory=$true)][string]$programfilepath,
	[Parameter(Mandatory=$true)][string]$shortcutfilepath,
	$shortcutargs
)

## Create a shortcut to the program we want to run.
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutfilepath)
$Shortcut.TargetPath = $programfilepath
$Shortcut.Arguments = $shortcutargs
$Shortcut.Save()

## Set the "run as admin" bit in the shortcut (.lnk) file.
## From: 
## http://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
$bytes = [System.IO.File]::ReadAllBytes($shortcutfilepath)
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes($shortcutfilepath, $bytes)

## Launch the program via the shortcut.
& $shortcutfilepath

## Delete the shortcut.
remove-item $shortcutfilepath
