@echo off
call config.cmd
SET SCRIPTDIR=%CD%
echo Entering %OUTPUTDIR%\%PACKAGENAME%
cd %OUTPUTDIR%\%PACKAGENAME%

echo Checking for latest version
for /f "delims=" %%x in ('dir /t:c /od /b *.*') do set recent=%%x
echo Latest version found: %recent%
echo Swtiching back to script dir
cd /d %SCRIPTDIR%

echo Installing %PACKAGENAME% from %OUTPUTDIR%\%PACKAGENAME%\%recent%
cinst %PACKAGENAME% -source ""%OUTPUTDIR%\%PACKAGENAME%\%recent%""