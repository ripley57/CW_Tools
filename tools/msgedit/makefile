# Outlook 2010 MAPI Header Files
# http://www.microsoft.com/en-us/download/details.aspx?id=12905

# Microsoft SDK v7.0A (ME: I found this link today. It might not be the one I used.)
# https://www.microsoft.com/en-gb/download/details.aspx?id=3138

# MAPI Stub Library (ME: Not sure if I need this or not)
# https://mapistublibrary.codeplex.com/
# "The MAPI Stub Library is a drop in replacement for mapi32.lib which supports 
#  building both 32 and 64 bit MAPI applications. This library eliminates the 
#  need to explicitly link to MAPI."
# Includes files: MapiStubLibrary.cpp and StubUtils.cpp


# ME: This makefile was stolen from somewhere else, so a lot of the options below
#     are probably not required.

cc=cl
link=link

cflags=/nologo /W3 /O2 /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D "TELNET" /D "GAPING_SECURITY_HOLE" /FD /c /D _CRT_SECURE_NO_WARNINGS
lflags=Advapi32.lib kernel32.lib user32.lib wsock32.lib winmm.lib ole32.lib /nologo /subsystem:console /machine:I386 /out:msgedit.exe
include=-I"C:\Office 2010 Developer Resources\Outlook 2010 MAPI Headers" -I"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Include" -I"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include"

all: msgedit.exe

MapiStubLibrary.obj: MapiStubLibrary.cpp
    $(cc) $(cflags) $(include) MapiStubLibrary.cpp

StubUtils.obj: StubUtils.cpp
    $(cc) $(cflags) $(include) StubUtils.cpp
	
msgedit.obj: msgedit.cpp
    $(cc) $(cflags) $(include) msgedit.cpp

msgedit.exe: msgedit.obj MapiStubLibrary.obj StubUtils.obj
    $(link) msgedit.obj MapiStubLibrary.obj StubUtils.obj $(lflags)
