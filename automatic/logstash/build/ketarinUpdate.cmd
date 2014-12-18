@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)

"c:\ProgramData\chocolatey\lib\ketarin.1.7.0\tools\Ketarin.exe" /silent /log=C:\ProgramData\chocolateypackageupdater\ketarin.%mydate%_%mytime%.log
