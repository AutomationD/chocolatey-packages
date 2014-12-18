For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)

set WORKDIR=c:\ProgramData\Chocolatey\_work
SET OUTPUTDIR=c:\Users\Developer\Documents\GitHub\chocolatey-packages\automatic\_output\
set NAME=logstash

SET VERSION=1.4.2

