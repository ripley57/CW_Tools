@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Find all the ".pdb" files in the current directory and search for the specified symbol.

set dbhexe="C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\dbh.exe"

if not exist %dbhexe% (echo. && echo ERROR: dbh.exe not found at !dbhexe! && goto DONE) 

REM Check input arguments.
if [%1]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 symbol
echo.
echo Example:
echo   %~nx0 CTextSearcher::searchFileWithTextExtraction
echo.
goto DONE

:GOOD_INPUT_ARGS
set arg_symbol=%1
set arg_dirname="."

goto END_FUNCTION_DEFS

REM Function to recursively find all .pdb files in the current directory.
REM http://ss64.com/nt/for.html
:FUNC_FIND_PDB_FILES 
set indirname=%1
set outfilename=%2
if exist %outfilename% del %outfilename%
if not exist %indirname% (echo ERROR: No such directory %indirname% && exit /b 1)
FOR /f "tokens=*" %%G IN ('dir %indirname%\*.pdb /s /b 2^>nul') DO (echo "%%G" >> %outfilename%)
exit /b 0
goto :eof

REM Function to run dbh.exe against each pdb file and look for the symbol.
:FUNC_SEARCH_PDB_FILES
set symbol=%1
if not exist pdbfiles.txt (echo ERROR: No such input file pdbfiles.txt && exit /b 1)
for /f "tokens=*" %%A in (pdbfiles.txt) do (call :search_pdb_file %%A)
del pdbfiles.txt
exit /b 0
goto :eof
:search_pdb_file
set pdbfile=%1
echo.
echo Searching %pdbfile% for %symbol% ...
%dbhexe% %pdbfile% dump | findstr %symbol%
goto :eof

:END_FUNCTION_DEFS

call :FUNC_FIND_PDB_FILES   %arg_dirname% "pdbfiles.txt" || goto DONE
if not exist "pdbfiles.txt" (echo. && echo No pdb files found. && goto DONE)

call :FUNC_SEARCH_PDB_FILES %arg_symbol%  "pdbfiles.txt" || goto DONE

:DONE
echo.
echo Finished. 
echo.