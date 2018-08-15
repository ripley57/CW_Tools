@echo off
REM Description:
REM   Script to collect Windows Perfmon data for each physical disk.
REM
REM Run the following to see how to call this script:
REM     my_disk_perfmon.bat -h
REM
REM Comments:
REM   o By default, this script will only setup a data collection set for
REM     monitoring the C drive. To monitor the D and E drives, edit this
REM     script by setting my_monitor_d_disk="yes" and my_monitor_e_disk="yes".
REM
REM   o If you want to change the counters that are monitored, the easiest
REM     way to determine their names is to launch the perfmon.exe GUI and
REM     create your own new data collection set, as follows:
REM       - Launch perfmon.exe using "Run > perfmon".
REM       - Expand "Data Collector Sets".
REM       - Right-click on "User Defined" and select "New > Data Collector Set".
REM	  - Select "Create manually (Advanced)" and click the "Next" button.
REM	  - Select "Performance Counter" under "Create data logs" and then click
REM         the "Next" button.
REM	  - Click the "Add..." button to select the counters to add.
REM	  - To add counters related to disk performance, scroll down and expand
REM	    "PhysicalDisk".
REM	  - Select a counter, e.g. "Disk Read Bytes/sec", and also select the
REM         disk drive letter, e.g. "0 C". Then press the "Add >>" button.
REM       - Click the "OK" button when you have finished adding counters.
REM       - Accept or change the "Sample interval" value.
REM       - Click the "Finish" button.
REM       - Back in the main Perfmon window, select "User Defined" again and
REM         right-click on the new data collector set. Select "Save Template..."
REM         to save the counter settings to an XML file.
REM       - Open the XML and copy the name of the counter, e.g.
REM         "\PhysicalDisk(0 C:)\% Disk Read Time".
REM       - Paste the name of the counter into the counters text file for the
REM	    corresponding disk.
REM
REM   o If you examine the counter text files, e.g. my_c_perfmon_counters.txt,
REM     you will see that the C drive is assumed to correspond to (0 C:), the D
REM     drive corresponds to (1 D:), and the E drive is (2 E:). These are
REM     assumptions made by this script. If unsure, follow the steps in the
REM     previous comment to see what the Perfmon UI displays for each disk.
REM
REM JeremyC 28/05/2014.

REM Set the current directory to be the location of the script, side files
REM used by the script, and also the location of the Perfmon output files.
set my_script_dir=%~dp0

REM IMPORTANT: Change the following lines to specify the disks to monitor.
set my_monitor_c_disk="yes"
set my_monitor_d_disk="no"
set my_monitor_e_disk="no"

goto runit

:usage
echo.
echo Description:
echo   Collect Perfmon data for one or more physical disks.
echo.
echo   IMPORTANT: By default this script only configures
echo              counters to monitor the C disk drive.
echo              To also enable monitoring of D and E disk
echo              drives, see the instructions in the script.
echo.
echo Usage:
echo   %~nx0 start_time end_time
echo.
echo Example usage:
echo   %~nx0 "5/28/2014 6:00:00AM" "5/28/2014 8:00:00AM"
echo.
echo Some useful logman.exe commands:
echo 1. List current data collection sets:
echo    logman.exe
echo 2. List the settings of a specific collection set:
echo    logman.exe my_c_perfmon
echo 3. Start a specific data collection set:
echo    logman.exe start my_c_perfmon
echo 4. Stop a specific data collection set:
echo    logman.exe stop my_c_perfmon
echo 5. Delete a specific data collection set:
echo    logman.exe delete my_c_perfmon
echo 6. Update the start time for a scheduled collection:
echo    logman.exe my_c_perfmon update -b "5/29/2014 06:00:00AM"
echo 7. Update the stop time for a scheduled collection:
echo    logman.exe my_c_perfmon update -3 "5/29/2014 09:00:00AM"
echo.
exit /b 1

:runit
IF [%1]==[] (
  goto usage
)
IF [%1]==[/?] (
  goto usage
)
IF [%1]==[-h] (
  goto usage
)
  
REM Data collection set scheduled start and stop times. 
REM These are used for all the data collections sets created in this script.
set my_perfmon_common_startdatetime=%1
set my_perfmon_common_enddatetime=%2

REM Some more common settings.
set my_perfmon_common_logformat=csv
set my_perfmon_common_maxlogsizemb=250

REM Perform settings for disk c.
set my_c_perfmon=my_c_perfmon
set my_c_perfmon_counters=%my_script_dir%\my_c_perfmon_counters.txt
set my_c_perfmon_logfile=%my_script_dir%\my_c_perfmon_output.log

REM Perform settings for disk d.
set my_d_perfmon=my_d_perfmon
set my_d_perfmon_counters=%my_script_dir%\my_d_perfmon_counters.txt
set my_d_perfmon_logfile=%my_script_dir%\my_d_perfmon_output.log

REM Perform settings for disk e.
set my_e_perfmon=my_e_perfmon
set my_e_perfmon_counters=%my_script_dir%\my_e_perfmon_counters.txt
set my_e_perfmon_logfile=%my_script_dir%\my_e_perfmon_output.log

REM Create perfmon data collector set for disk c.
IF %my_monitor_c_disk%=="yes" (
   echo Creating data collector set for disk c...
   logman.exe create counter "%my_c_perfmon%" -cf "%my_c_perfmon_counters%" -o "%my_c_perfmon_logfile%" -f "%my_perfmon_common_logformat%" -max "%my_perfmon_common_maxlogsizemb%" -v mmddhhmm -b "%my_perfmon_common_startdatetime%" -e "%my_perfmon_common_enddatetime%"
)

REM Create perfmon data collector set for disk d.
IF %my_monitor_d_disk%=="yes" (
   echo Creating data collector set for disk d...
   logman.exe create counter "%my_d_perfmon%" -cf "%my_d_perfmon_counters%" -o "%my_d_perfmon_logfile%" -f "%my_perfmon_common_logformat%" -max "%my_perfmon_common_maxlogsizemb%" -v mmddhhmm -b "%my_perfmon_common_startdatetime%" -e "%my_perfmon_common_enddatetime%"
)

REM Create perfmon data collector set for disk e.
IF %my_monitor_e_disk%=="yes" (
  echo Creating data collector set for disk e...
  logman.exe create counter "%my_e_perfmon%" -cf "%my_e_perfmon_counters%" -o "%my_e_perfmon_logfile%" -f "%my_perfmon_common_logformat%" -max "%my_perfmon_common_maxlogsizemb%" -v mmddhhmm -b "%my_perfmon_common_startdatetime%" -e "%my_perfmon_common_enddatetime%" 
)

echo Finished.
