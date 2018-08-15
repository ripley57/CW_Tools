@echo off
set _olddir="%CD%"
chdir /d %1
call b2 admin-client support run clusterbrowser
chdir /d "%_olddir%"
