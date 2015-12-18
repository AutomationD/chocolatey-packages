$url='https://github.com/CHERTS/esp8266-devkit/releases/download/v2.0.8/Espressif-ESP8266-DevKit-v2.0.8-x86.exe'
$packageName = 'esp8266-udk'
$installerType = 'exe'
$silentArgs = '/VERYSILENT'
$installDir = 'c:/Espressif'
$symLinkName = $(Join-Path $installDir 'sdk') 
$symLinkTarget = $(Join-Path $installDir 'ESP8266_SDK')

function Test-ReparsePoint([string]$path) {
  $file = Get-Item $path -Force -ea 0
  return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}



if ((Test-Path -path $installDir)) {
  Write-Debug "$installDir found - cleaning up"
  if (Test-ReparsePoint -path $symLinkName) {
    Write-Debug "Removing sdk symlink"  
    Start-ChocolateyProcessAsAdmin "reparsepoint delete $symLinkName" "fsutil.exe"
  }
  Write-Debug "Cleaning up $$symLinkName"
  Start-ChocolateyProcessAsAdmin "del /Q /S /F $symLinkName" "cmd.exe"  

  if ((Test-Path -path $(Join-Path $installDir "unins000.exe"))) {
    Remove-Item $(Join-Path $installDir "unins000.exe")
  }
  # Write-Debug "Cleaning up $installDir"
  # Start-ChocolateyProcessAsAdmin "del /Q /S /F $installDir" "cmd.exe"

} else {
  Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"
  Install-ChocolateyEnvironmentVariable "ESP_HOME" "$installDir"
  Write-Debug "Set ESP_HOME to $installDir"

  Write-Debug "Creating sdk symlink"
  Start-ChocolateyProcessAsAdmin "if(Test-Path $symLinkName){Remove-Item $symLinkName}; $env:comspec /c mklink /D $symLinkName $symLinkTarget" -validExitCodes @(0,121)
  #Start-ChocolateyProcessAsAdmin "mklink.exe /D $(Join-Path $installDir 'sdk') $(Join-Path $installDir 'ESP8266_SDK')" "cmd.exe"
}


