
$packageName = 'sming'
$packageVersion = '1.1.0'
$url="https://github.com/anakod/Sming/archive/${packageVersion}.zip"
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'sming'

Install-ChocolateyZipPackage "$packageName" $url $installDir
Copy-Item $installDir/Sming-$packageVersion/* $installDir/ -Force -Recurse
Remove-Item $installDir/Sming-$packageVersion -force -Recurse

Install-ChocolateyEnvironmentVariable "SMING_HOME" "$installDir\Sming"
Write-Debug "Set SMING_HOME to $installDir\Sming"

Update-SessionEnvironment