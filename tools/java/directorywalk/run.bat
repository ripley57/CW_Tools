@echo off

set CLASSPATH=classes
rem java WalkDirectory %*
java WalkDirectory "%~dp0\test\walkdemo"
