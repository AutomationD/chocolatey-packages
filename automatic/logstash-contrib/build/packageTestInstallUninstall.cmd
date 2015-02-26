@echo off
call config.cmd
cd %OUTPUTDIR%\%NAME%
for /f "delims=" %%x in ('dir /od /b *.*') do set recent=%%x
echo Entering %recent%
cinst logstash -source ""%cd%;http://chocolatey.org/api/v2/""