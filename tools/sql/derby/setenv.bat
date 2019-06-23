@echo off

rem Set DERBY_INSTALL
rem See http://db.apache.org/derby/papers/DerbyTut/ns_intro.html#ns_intro

if not exist lib (
    echo ERROR: ./lib not found, please run "ant install-derby"
    exit /b 1
)

for /d %%D in (lib\*) do set DERBY_INSTALL=%%~fD
rem echo DERBY_INSTALL=%DERBY_INSTALL%
