$packageName = 'srecord'
$packageVersion = '1.64'
$url="http://downloads.sourceforge.net/project/srecord/srecord-win32/${packageVersion}/srecord-${packageVersion}-win32.zip"
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'mingw64\bin'

Install-ChocolateyZipPackage "$packageName" $url $installDir