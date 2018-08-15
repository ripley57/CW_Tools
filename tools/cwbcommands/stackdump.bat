@echo off
set _olddir="%CD%"
chdir /d %1
call b2 admin-client monitor.thread getAllStackTraces
chdir /d "%_olddir%"
