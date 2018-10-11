# This makefile was stolen from somewhere else, so some of the settings below might not be required.
#
# 1. Install VC++ from my CD titled "Visual Studio 2010 SP1 Express (Aug 2014)":
#    F:\VCExpress\setup.exe
#
# 2. Launch a VC++ command window:
#    %comspec% /k ""C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"" x86
#
# 3. Point to MAPI header files using -I"..\include\Office 2010 Developer Resources\Outlook 2010 MAPI Headers"
#
# 4. MapiStubLibrary.cpp includes <winsock2.h>. To successfully find this header file, add the following to the include path:
#    -I"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Include"
#
# 5. Build program:
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

#cflags=/nologo /EHsc /W3 /O2 /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D _CRT_SECURE_NO_WARNINGS /c /Zi
cflags=/c /Zi /EHsc

#lflags=Advapi32.lib kernel32.lib user32.lib wsock32.lib winmm.lib ole32.lib /nologo /subsystem:console /machine:I386  /out:msgedit2.exe /debug  /pdb:msgedit2.pdb
lflags=Advapi32.lib kernel32.lib user32.lib wsock32.lib winmm.lib ole32.lib /nologo /subsystem:console /out:msgedit2.exe /debug  /pdb:msgedit2.pdb

include=-I"..\include\Office 2010 Developer Resources\Outlook 2010 MAPI Headers" -I"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include" -I"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Include"

all:: msgedit2.exe

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
	
CSVReader.obj: CSVReader.cpp
	$(cc) $(cflags) $(include) CSVReader.cpp
	
Msg.obj: Msg.cpp
	$(cc) $(cflags) $(include) Msg.cpp

MSGEdit.obj: MSGEdit.cpp
	$(cc) $(cflags) $(include) MSGEdit.cpp
	
Session.obj: Session.cpp
	$(cc) $(cflags) $(include) Session.cpp
	
Logger.obj: Logger.cpp
	$(cc) $(cflags) $(include) Logger.cpp
	
Utils.obj: Utils.cpp
	$(cc) $(cflags) $(include) Utils.cpp
	
wingetopt.obj: wingetopt.cpp
	$(cc) $(cflags) $(include) wingetopt.cpp
	
main.obj: main.cpp
	$(cc) $(cflags) $(include) main.cpp
	
msgedit2.exe: setup32bitenv $(stub_objs) CSVReader.obj Msg.obj MSGEdit.obj Session.obj Logger.obj Utils.obj wingetopt.obj main.obj
    $(link) $(stub_objs) CSVReader.obj Msg.obj MSGEdit.obj Session.obj Logger.obj Utils.obj wingetopt.obj main.obj $(lflags)

clean:
	del *.obj
	del msgedit2.ilk vc100.pdb
