@echo off

echo.
echo ###################################################################
echo MAPIInitialize is currently failing on Windows 8.1 Office 2016 when
echo msgedit2.exe is run through WinDbg. I'mnot sure why at the moment.
echo Here is the error:
echo.
echo ModLoad: 73820000 73845000   C:\Program Files (x86)\Microsoft Office\root\Office16\JitV.dll
echo (ac4.7a0): Access violation - code c0000005 (first chance)
echo ...
echo *** ERROR: Symbol file could not be found.  Defaulted to export symbols for C:\Program Files (x86)\Microsoft Office\root\Office16\JitV.dll echo JitV!IsCurrentThreadVirtualized+0x1195:
echo 738280d8 8b00            mov     eax,dword ptr [eax]  ds:002b:000000c0=????????
echo.
echo UPDATE:
echo Apparently these crashes in MAPIInitialize are normal inside the
echo debugger. See:
echo http://answers.microsoft.com/en-us/office/forum/office_insider-outlook/outlook-build-16069652053-for-office-2016-causing/4ad99f17-fc9a-4b2c-acd9-0f3adcac5c52
echo.
echo If I keep entering 'g' I then see this:
echo 0:000> g
echo (10c8.5b8): C++ EH exception - code e06d7363 (first chance)
echo JIT-V : Initialized
echo JIT-V : Enabling Virtualization on ThreadId 1464
echo ###################################################################
echo.

set pwd=%~dp0

"c:\Program Files (x86)\Debugging Tools for Windows (x86)\windbg.exe" -y "%pwd%" -srcpath "%pwd%" -c "bc *;bp msgedit2!main;g" msgedit2.exe

