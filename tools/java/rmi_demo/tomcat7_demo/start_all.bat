@echo off

start cmd /k rmiregistry -J-Djava.rmi.server.useCodebaseOnly=false 1099

REM Sleep 5 seconds
ping 127.0.0.1 -n 6 > nul

start cmd /k java -classpath classes_server -Djava.rmi.server.codebase=file:%cd%/classes_server/ example.hello.Server

