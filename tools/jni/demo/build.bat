@echo off
REM Description:
REM   Demo using JNI to call C++ (in a DLL) from Java.
REM
REM Note:
REM   Run this from a VC++ prompt for the cl.exe command to work, e.g.:
REM   %comspec% /k ""C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"" amd64
REM
REM Example output:
REM   intMethod: 25
REM   booleanMethod: false
REM   stringMethod: JAVA
REM   intArrayMethod: 33
REM
REM JeremyC 18-02-2018

javac Sample1.java

REM Create header file for our native Java methods.
javah Sample1

REM Build Sample1.dll.
cl /I "C:\Program Files\Java\jdk1.8.0_45\include" /I "C:\Program Files\Java\jdk1.8.0_45\include\win32" -LD Sample1.cpp -FeSample1.dll

REM Run the demo.
java Sample1
