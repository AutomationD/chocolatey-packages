$url='https://github.com/CHERTS/esp8266-devkit/releases/download/v2.0.9/Espressif-ESP8266-DevKit-v2.0.9-x86.exe'
$packageName = 'esp8266-udk'
$installerType = 'exe'
$silentArgs = '/VERYSILENT'
$installDir = 'c:/Espressif'
$symLinkName = $(Join-Path $installDir 'sdk') 


function Test-ReparsePoint([string]$path) {
  $file = Get-Item $path -Force -ea 0
  return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}


if ((Test-Path -path $symLinkName)) {
  if (Test-ReparsePoint -path $symLinkName) {
    Write-Debug "Removing sdk symlink"  
    Start-ChocolateyProcessAsAdmin "reparsepoint delete $symLinkName" "fsutil.exe"
  } 
  Write-Debug "Cleaning up $$symLinkName"
  Start-ChocolateyProcessAsAdmin "del /Q /S /F $symLinkName" "cmd.exe"
}




if ((Test-Path -path $(Join-Path $installDir "unins000.exe"))) {
  $uninstallExe = "unins000.exe"
} elseif ((Test-Path -path $(Join-Path $installDir "unins001.exe"))) {
  $uninstallExe = "unins001.exe"
} else {
  Write-Debug "Can't find neither unins000.exe or unins001.exe. Deleting everything"
  Remove-item -recurse -force $installDir
}

if ( $uninstallExe ) {
  Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $(Join-Path $installDir $uninstallExe)
}







# Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"

# Install-ChocolateyEnvironmentVariable "ESP_HOME" "$installDir" \
# Write-Debug "Set ESP_HOME to $installDir"

# Write-Debug "Creating sdk symlink"
# $symLinkName = $(Join-Path $installDir 'sdk') 
# $symLinkTarget = $(Join-Path $installDir 'ESP8266_SDK')
# Start-ChocolateyProcessAsAdmin "$(Join-Path ${installDir})" "/SILENT"
# #Start-ChocolateyProcessAsAdmin "mklink.exe /D $(Join-Path $installDir 'sdk') $(Join-Path $installDir 'ESP8266_SDK')" "cmd.exe"
