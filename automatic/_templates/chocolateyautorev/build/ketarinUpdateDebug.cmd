@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)

set WORKDIR=c:\ProgramData\Chocolatey\_work
set NAME=__NAME__
SET VERSION=2.6.6

echo Cleaning up downloaded file (to package a new debug revision)
forfiles -p "%WORKDIR%" -m "%NAME%*%VERSION%*" -c "cmd /c del @path"

echo Cleaning chocolatey lib directory in order to prevent cached packages
forfiles -p "%ChocolateyInstall%\lib\" -s -m "%NAME%*%VERSION%*" -c "cmd /c del @path"
forfiles -p "%ChocolateyInstall%\lib-bad\" -s -m "%NAME%*%VERSION%*" -c "cmd /c del @path"



echo Incrementing revision
PowerShell.exe  -ExecutionPolicy RemoteSigned -Command "& '.\versionBump.ps1'"




Ketarin.exe --shimgen-waitforexit /silent /log=C:\ProgramData\chocolateypackageupdater\ketarin.%mydate%_%mytime%.log
