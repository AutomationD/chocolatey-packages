@echo off
call config.cmd
echo Cleaning up downloaded file (to package a new debug revision)
forfiles -p "%WORKDIR%" -m "%NAME%*%VERSION%*" -c "cmd /c del @path"

echo Cleaning chocolatey lib directory in order to prevent cached packages
forfiles -p "%ChocolateyInstall%\lib\" -s -m "%NAME%*%VERSION%*" -c "cmd /c del @path"
forfiles -p "%ChocolateyInstall%\lib-bad\" -s -m "%NAME%*%VERSION%*" -c "cmd /c del @path"



PowerShell.exe  -ExecutionPolicy RemoteSigned -Command "& '.\versionBump.ps1'"




"%ChocolateyInstall%\lib\ketarin.1.7.0\tools\Ketarin.exe" /silent /log=C:\ProgramData\chocolateypackageupdater\ketarin.%mydate%_%mytime%.log
