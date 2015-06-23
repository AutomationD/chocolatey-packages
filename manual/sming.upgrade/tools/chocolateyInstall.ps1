$packageName = 'sming.upgrade'
$packageVersion = '1.1.0'
$binRoot = Get-BinRoot

#### SDK Symlink ####
# We need this to make sure Windows, MacOS, Linux users have same experience
$espressifInstallDir = 'c:\Espressif'
$symLinkName = $(Join-Path $espressifInstallDir 'sdk') 
$symLinkTarget = $(Join-Path $espressifInstallDir 'ESP8266_SDK')
Write-Host "Creating a symlink ${symLinkName} -> ${symLinkTarget}"
Start-ChocolateyProcessAsAdmin "if(Test-Path $symLinkName){Remove-Item $ symLinkName}; $env:comspec /c mklink /D $symLinkName $symLinkTarget" -validExitCodes @(0,121)

#### MinGW ####
# We need this to make sure all users have similar paths - for better compatibility
$mingwOldPath = "c:\MinGW"
$mingwNewPath = Join-Path "$binRoot" 'mingw64'
if (!$mingwNewPath) {
  Write-Host "Moving $mingwOldPath -> $mingwNewPath"
  Move-Item $mingwOldPath $mingwNewPath
} else {
  Write-ChocolateyFailure $packageName "$mingwNewPath already exists. Please remove it first."
}

#### Environment Variables ####
# This is required to make Eclipse, make and other tools happy

Install-ChocolateyEnvironmentVariable "SMING_HOME" "$installDir\Sming"
Write-Host "Set SMING_HOME to $installDir\Sming"

Install-ChocolateyEnvironmentVariable "ESP_HOME" "$espressifInstallDir"
Write-Host "Set ESP_HOME to $installDir\Sming"

Write-Debug "Adding mingw & msys to the path"
Install-ChocolateyEnvironmentVariable "PATH" "${$mingwNewPath}\bin;${mingwPath}\msys\1.0\bin;$env:Path" "Machine"

#### Additional packages ####
## This package includes the following packages as dependencies.
## Please install files to their locations in case of manual upgrade:

# [spiffy] https://bintray.com/artifact/download/kireevco/generic/spiffy-1.0.3-win32-x86_64.zip >- unzip -> c:\tools\mingw64\bin\
# [sming.core] https://github.com/anakod/Sming/archive/1.1.0.zip >- unzip -> c:\tools\sming\

Update-SessionEnvironment