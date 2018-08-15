@echo off
set _olddir="%CD%"
chdir /d %1
echo Stopping EsaApplicaton service... 1>&2
call b server-stop-service
echo Waiting 30 seconds for service to stop... 1>&2
sleep 30
echo Starting EsaApplicatoin services... 1>&2
call b server-start-service
echo Waiting 30 seconds for service to start... 1>&2
sleep 30
chdir /d "%_olddir%"
