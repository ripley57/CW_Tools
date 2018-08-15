@echo off
set _olddir="%CD%"
chdir /d %1
echo Starting All CW Services... 1>&2
call b2 start-services
echo Waiting 30 seconds for all services to start... 1>&2
sleep 30
chdir /d "%_olddir%"
