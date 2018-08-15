@echo off

rem Demo of a basic ant setup.
rem
rem	1. Download the Ant binary distribution from http://ant.apache.org/bindownload.cgi
rem 2. Download Groovy from http://groovy-lang.org/download.html and extract just the "groovy-all" jar 
rem    file, which is found in the "embeddable" directory when you have unzipped the Groovy download.
rem
rem Demo output:
rem D:\tmp_ant>go
rem Buildfile: D:\tmp_ant\build-1.xml
rem
rem init:
rem   [groovy] testval1=hello world
rem
rem BUILD SUCCESSFUL
rem Total time: 1 second
rem
rem JeremyC 3-5-2017.

set JAVA_HOME=C:\jdk-8u74-x64
set ANT_HOME=C:\apache-ant-1.10.1
set PATH=%ANT_HOME%\bin;%JAVA_HOME%\bin;%PATH%
set CLASSPATH=%~dp0\groovy-all-2.4.11.jar

ant -v -buildfile build-1.xml
