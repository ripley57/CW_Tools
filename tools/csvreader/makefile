
cc=cl
link=link

cflags=/nologo /W3 /O2 /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D "TELNET" /D "GAPING_SECURITY_HOLE" /FD /c /D _CRT_SECURE_NO_WARNINGS /EHsc
lflags=Advapi32.lib kernel32.lib user32.lib wsock32.lib winmm.lib ole32.lib /nologo /subsystem:console /machine:I386 /out:csvdemo.exe
include=-I"C:\Office 2010 Developer Resources\Outlook 2010 MAPI Headers" -I"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Include" -I"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include"

all: csvdemo.exe

CSVReader.obj: CSVReader.cpp
	$(cc) $(cflags) $(include) CSVReader.cpp

main.obj: main.cpp
    $(cc) $(cflags) $(include) main.cpp

csvdemo.exe: main.obj CSVReader.obj
    $(link) main.obj CSVReader.obj $(lflags)
