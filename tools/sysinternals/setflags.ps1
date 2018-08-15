# Usage:
# 	powershell -executionpolicy RemoteSigned setflags.ps1 <filepath> [-bytetoupdate <int>] [-flagstoset <int>]
#
# Examples:
#	To set "run as admin" flag of a shortcut (.lnk) file:
#	powershell -executionpolicy RemoteSigned d:\setflags.ps1  shortcut.lnk 0x15 0x20
#
# References:
#	Specification of shortcut lnk binary format (also includes "QuickEdit" console setting, etc):
#	https://msdn.microsoft.com/en-us/library/dd871305.aspx
#
# JeremyC 14/1/2017
 
param (
    [Parameter(Mandatory=$true)][string]$filepath,
    [Int]$bytetoupdate = 0x15,
    [Int]$flagstoset = 0x20
)

$bytes = [System.IO.File]::ReadAllBytes($filepath)

#From:
#http://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
#$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
$bytes[$bytetoupdate] = $bytes[$bytetoupdate] -bor $flagstoset

[System.IO.File]::WriteAllBytes($filepath, $bytes)