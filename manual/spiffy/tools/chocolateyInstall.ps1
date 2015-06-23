$packageName = 'spiffy'
$packageVersion = '1.0.3'
$url="https://bintray.com/artifact/download/kireevco/generic/spiffy-${packageVersion}-win32-x86_64.zip"
$url64="https://bintray.com/artifact/download/kireevco/generic/spiffy-${packageVersion}-win32-x86_64.zip"
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'mingw64\bin'

Install-ChocolateyZipPackage "$packageName" $url $installDir