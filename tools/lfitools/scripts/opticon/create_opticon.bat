@echo off
REM Description:
REM     Script to generate an opticon file for image overlay.
REM	    The opticon file will contain a single document, with
REM     2500 separate TIF pages. Each page 1974KB in size.
REM
REM More details on opticon format here:
REM     https://www.veritas.com/support/en_US/article.000020310

REM Check input arguments.
if [%3]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 docID pageCount 161KB^|1974KB
echo.
echo Example:
echo   %~nx0 0.7.200.505 2500 161KB
echo.
goto DONE

:GOOD_INPUT_ARGS

:GOOD_INPUT_ARGS
set docID=%1
set pageCount=%2
set imageSizeKB=%3

REM Remove any surrounding double quotes.
set x=%docID:"=%
set docID=%x%
set x=%pageCount:"=%
set pageCount=%x%
set x=%imageSizeKB:"=%
set imageSizeKB=%x%

REM Create first line of opticon csv file.
echo %docID%,,images_%imageSizeKB%\000001_image.tif,Y,,,%pageCount%           > opticon_with_%imageSizeKB%_pages.csv
REM Create remaining lines of opticon csv file.
.\lfgen.exe 2 %pageCount% %docID%,,images_%imageSizeKB%\%%06lu_image.tif,,,, >> opticon_with_%imageSizeKB%_pages.csv

REM Create copy of image file for each page.
if exist images_%imageSizeKB%\. (
   rd /q /s images_%imageSizeKB%
)
mkdir images_%imageSizeKB%
.\lfcopy.exe image_%imageSizeKB%.tif 1 %pageCount% "images_%imageSizeKB%\%%06lu_image.tif"
:DONE
