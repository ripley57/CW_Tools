Build instructions for the critical section demo (i.e. inter-thread deadlock) in Chapter 09 of book "Inside Windows Debugging" (page 344).

We will use the "Windows 7 Driver Development Kit (DDK)" to build the demo. IMO this method is overkill for simple one-file basic Windows demos. However, for examples like this, that use Visual Studio classes such as CHandle (which requires ATL), this method looks to be very straight forward. You simply need to setup the necessary directories.

Note: The files required for this just this demo have been copied to this CW_Tools directory. Perform the following steps to build the demo:

1) Install the "Windows 7 Driver Development Kit (DDK)". 
Download the DDK from here:
https://www.microsoft.com/en-us/download/details.aspx?id=11800
This will download an ISO file such as "GRMWDK_EN_7600_1.iso".

2) Mount the ISO using a free tool such as "WinCDEmu-4.1.exe".

3) Run the DDK installer (KitSetup.exe) and select the default installation directory.
This will install the files to a directory such as this:
C:\WinDDK\7600.16385.1\

4) Prepare the build environment:
C:\WinDDK\7600.16385.1>bin\setenv.bat C:\WinDDK\7600.16385.1

5)) Change to this (CW_Tools) directory and build the demo:
C:\cygwin\home\jcdc\Github\CW_Tools\tools\threads\criticalsection>bcz
BUILD: Compile and Link for x86
BUILD: Start time: Fri Dec 02 18:08:02 2016
BUILD: Examining c:\cygwin\home\jcdc\github\cw_tools\tools\threads\criticalsection directory for files to compile.
BUILD: Compiling and Linking c:\cygwin\home\jcdc\github\cw_tools\tools\threads\criticalsection directory
Compiling - main.cpp
Linking Executable - objfre_win7_x86\i386\demo.exe
BUILD: Finish time: Fri Dec 02 18:08:07 2016
BUILD: Done

    3 files compiled
    1 executable built

JeremyC 2/12/2016. 