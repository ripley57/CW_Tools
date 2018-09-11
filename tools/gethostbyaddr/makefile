# Build instructions:
#
# 1. Install the Microsoft SDK.
#    http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDKX_EN_DVD.iso
#    http://stackoverflow.com/questions/1901279/windows-7-sdk-installation-failure
#
# 2. Setup the environment to build 32-bit.
#    3.1 Open the Windows SDK command prompt window:
#        Click Start, All Programs, Microsoft Windows SDK v7.1, 
#    3.2 setenv /debug /x86
#
# 4. Build program:
#    nmake -f makefile
#
# JeremyC 11-09-2018

cc=cl
link=link

#include=-I"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include" -I"C:\WinSDK\Include"
cflags=/c /Zi /EHsc -DUNICODE -D_UNICODE
lflags=/nologo /subsystem:console /out:gethostbyaddr.exe /debug /pdb:gethostbyaddr.pdb

all:: gethostbyaddr.exe

main.obj: main.cpp	
	$(cc) $(cflags) $(include) main.cpp

gethostbyaddr.exe: main.obj
	$(link) main.obj $(lflags)

clean:
	del *.obj
	del gethostbyaddr.ilk vc100.pdb
