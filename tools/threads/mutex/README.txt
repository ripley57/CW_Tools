This is a mutex demo from https://monkeyweekend.wordpress.com/2014/07/26/about-win32-mutex-handles-and-windbg-handle-extension/

Unlike critical sections, which are inter-thread only, this program can be used to demo mutexes, which can be used inter-process (i.e. to synchronize separate programs).

Build instructions:

Note: These build steps assume that the Windows 7 Development Kit has been installed (in C:\WinDDK\7600.16385.1). See the build steps for the critical section demo (CW_Tools/tools/threads/criticalsection) for the WinDDK installation steps.

1) C:\WinDDK\7600.16385.1>bin\setenv.bat C:\WinDDK\7600.16385.1

2) cd C:\cygwin\home\jcdc\Github\CW_Tools\tools\threads\mutex
C:\cygwin\home\jcdc\Github\CW_Tools\tools\threads\mutex>bcz
BUILD: Compile and Link for x86
BUILD: Start time: Fri Dec 02 19:04:09 2016
BUILD: Examining c:\cygwin\home\jcdc\github\cw_tools\tools\threads\mutex directo
ry for files to compile.
BUILD: Compiling and Linking c:\cygwin\home\jcdc\github\cw_tools\tools\threads\m
utex directory
Compiling - main.cpp
Linking Executable - objfre_win7_x86\i386\demo.exe
BUILD: Finish time: Fri Dec 02 19:04:11 2016
BUILD: Done

    3 files compiled
    1 executable built

JeremyC 2/12/2016.
