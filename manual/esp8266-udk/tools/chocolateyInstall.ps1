$url='https://github.com/CHERTS/esp8266-devkit/releases/download/v2.0.9/Espressif-ESP8266-DevKit-v2.0.9-x86.exe'
$packageName = 'esp8266-udk'
$installerType = 'exe'
$silentArgs = '/VERYSILENT'
$installDir = 'c:/Espressif'


Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"

Install-ChocolateyEnvironmentVariable "ESP_HOME" "$installDir"
Write-Debug "Set ESP_HOME to $installDir"

Write-Debug "Creating sdk symlink"
$symLinkName = $(Join-Path $installDir 'sdk') 
$symLinkTarget = $(Join-Path $installDir 'ESP8266_SDK')
Start-ChocolateyProcessAsAdmin "if(Test-Path $symLinkName){Remove-Item $symLinkName}; $env:comspec /c mklink /D $symLinkName $symLinkTarget" -validExitCodes @(0,121)
#Start-ChocolateyProcessAsAdmin "mklink.exe /D $(Join-Path $installDir 'sdk') $(Join-Path $installDir 'ESP8266_SDK')" "cmd.exe"
