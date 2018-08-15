@echo off

rem Description:
rem  Demo showing how self-executing jar files like jgit.sh (http://eclipse.org/jgit/download/) work.
rem  See also my download.sh and cwtools.bat files in CW_Tools.
rem
rem JeremyC 29-06-2018

rem First, let's build our jar file.
call build_jar.bat

rem Now we run our demos, which should all print "Hello world" ...

rem 1)
rem The following will work, as one would expect:
java -jar demo.jar

rem 2)
rem Interestingly, this will also work:
copy demo.jar wibble1 2>&1 >nul
java -cp wibble1 Test

rem 3)
rem And, even more interestingly, this will also work:
echo some    > file.tmp
echo random >> file.tmp
echo text   >> file.tmp
copy file.tmp /b + wibble1 /b wibble2 /b 2>&1 >nul
java -cp wibble2 Test
rem NOTE: 
rem This 3rd example shows why self-executing jar files, like jgit.sh (http://eclipse.org/jgit/download/) work.
rem What's happening is that java is looking for class "Test" in the loaded binary (wibble.wobble), and is
rem ignoring anything before it, which means that it fortunately skips the leading ascii lines from file.tmp.

rem 4) 
rem Now, let's use this to create a self-executing jar inside a shell script.
rem See https://stackoverflow.com/questions/24048157/how-to-create-a-self-executing-jar-file
rem Note: Be sure to run unix2dos on script1.bat.
copy script1.bat /b + wibble1 /b script2.bat /b 2>&1 >nul
call script2.bat

rem Tidy
if exist script2.bat (del script2.bat)
if exist wibble1 (del wibble1)
if exist wibble2 (del wibble2)
if exist demo.jar (del demo.jar)
if exist file.tmp (del file.tmp)

