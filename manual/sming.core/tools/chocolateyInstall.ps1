$url='https://github.com/anakod/Sming/archive/master.zip'
$packageName = 'sming'
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'sming'

Install-ChocolateyZipPackage "$packageName" $url $installDir
Copy-Item $installDir/Sming-master/* $installDir/ -Force -Recurse
Remove-Item $installDir/Sming-master -force -Recurse
Install-ChocolateyEnvironmentVariable "SMING_HOME" "$installDir"
Write-Debug "Set SMING_HOME to $installDir"

Update-SessionEnvironment