@echo off
call config.cmd
echo Cleaning up downloaded files (to prepare a new debug revision)
::forfiles -p "%WORKDIR%" -m "%NAME%*%VERSION%*" -c "cmd /c del @path"
forfiles -p "%WORKDIR%" -m "*%NAME%*" -c "cmd /c del @path"

::forfiles -p "%WORKDIR%" -m "logstash*" -c "cmd /c IF @isdir == TRUE rd /S /Q @path"
:: FOR /D %%p IN ("%WORKDIR%\%NAME%*%VERSION%*") DO rmdir "%%P" /s /q

echo Cleaning chocolatey lib directory in order to prevent cached packages
forfiles -p "%ChocolateyInstall%\lib" -s -m "%NAME%*%VERSION%*" -c "cmd /c rd /Q /S @path"
forfiles -p "%ChocolateyInstall%\lib-bad" -s -m "%NAME%*%VERSION%*" -c "cmd /c rd /Q /S @path"

PowerShell.exe  -ExecutionPolicy RemoteSigned -Command "& '.\versionBump.ps1'"
Ketarin.exe --shimgen-waitforexit /silent /log=C:\ProgramData\chocolateypackageupdater\ketarin.%mydate%_%mytime%.log
