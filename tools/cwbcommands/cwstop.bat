@echo off
set _olddir="%CD%"
chdir /d %1
echo Stopping All CW Services... 1>&2
call b2 stop-services
echo Waiting 30 seconds for all services to stop... 1>&2
sleep 30
chdir /d "%_olddir%"
