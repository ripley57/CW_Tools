@echo off

if not exist src echo WARN: Could not find local "src" directory. Aborting compile. && exit /b 1
dir /s /b /a:-d src > sources_list.txt
if not exist classes md classes
set CLASSPATH=classes
javac -g -d classes @sources_list.txt
if exist sources_list.txt del sources_list.txt
