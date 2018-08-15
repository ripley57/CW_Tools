@echo off

rem Description:
rem   Build a jar.
 
rem Create manifest file. Note the carriage return.
echo Main-Class: Test >Manifest.txt
echo Class-Path: .   >>Manifest.txt

if not exist classes (mkdir classes)

copy Manifest.txt  classes\ 2>&1 >nul

set JAVA_HOME=C:\jdk-8u74-windows-x64
set PATH=%JAVA_HOME%\bin;%PATH%

rem Compile the source file(s).
dir /s /b src > sources_list.txt
javac -cp classes -d classes @sources_list.txt

rem Create the jar
pushd classes
jar cfm ../demo.jar Manifest.txt Test.class
popd

rem Tidy
if exist Manifest.txt (del Manifest.txt)
if exist classes (rd /s /q classes)
if exist sources_list.txt (del sources_list.txt)
