# Build instructions:
#
# 1. Install the Microsoft SDK.
#    http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDKX_EN_DVD.iso
#    http://stackoverflow.com/questions/1901279/windows-7-sdk-installation-failure
#
# 2. Point to the MAPI header files in "..\include\Office 2010 Developer Resources\Outlook 2010 MAPI Headers".
#
# 3. Setup the environment to build 32-bit.
#    3.1 Open the Windows SDK command prompt window:
#        Click Start, All Programs, Microsoft Windows SDK v7.1, 
#    3.2 setenv /debug /x86
#
# 4. Build program:
#    nmake -f makefile
#
# Comments:
# o The source files being included here, include the "MAPI Stub Library".
#   These do seem to be required in order successfully link my program.
#   From https://mapistublibrary.codeplex.com/:
#  "The MAPI Stub Library is a drop in replacement for mapi32.lib which supports building both 32
#   and 64 bit MAPI applications. This library eliminates the need to explicitly link to MAPI."
#   This build currently includes source files: MapiStubLibrary.cpp and StubUtils.cpp
#
# o We need to build our MAPI program in 32-bit because that is the version of Outlook
#   that we will using. From https://msdn.microsoft.com/en-us/library/office/dd941355.aspx:
#  "The default installation of Office on a 64-bit version of the Windows operating system is 32-bit Office."
#   More details on building 32-bit using Microsoft Windows SDK v7.1. 
#   https://msdn.microsoft.com/en-us/library/ff660764(v=vs.100).aspx:

cc=cl
link=link

include=-I"..\include\Office 2010 Developer Resources\Outlook 2010 MAPI Headers" -I"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include" -I"C:\WinSDK\Include"

cflags=/c /Zi /EHsc -DUNICODE -D_UNICODE
lflags=Advapi32.lib kernel32.lib user32.lib wsock32.lib winmm.lib ole32.lib /nologo /subsystem:console /out:pstlister.exe /debug /pdb:pstlister.pdb 


all:: pstlister.exe

setup32bitenv:
	@echo.
	@echo ###########################################################################################
	@echo WARNING: Run setenv /x86 for 32-bit build. Otherwise MAPIInitialize will fail with 80004005
	@echo ###########################################################################################
	@echo.

MapiStubLibrary.obj: MapiStubLibrary.cpp
    $(cc) $(cflags) $(include) MapiStubLibrary.cpp

StubUtils.obj: StubUtils.cpp
    $(cc) $(cflags) $(include) StubUtils.cpp

stub_objs=MapiStubLibrary.obj StubUtils.obj


Utils.obj: Utils.cpp	
	$(cc) $(cflags) $(include) Utils.cpp

MyProfiles.obj: MyProfiles.cpp
	$(cc) $(cflags) $(include) MyProfiles.cpp
	
pstlister.exe: setup32bitenv $(stub_objs) Utils.obj MyProfiles.obj
	$(link) $(stub_objs) Utils.obj MyProfiles.obj $(lflags)

	
clean:
	del *.obj
	del pstlister.ilk vc100.pdb
