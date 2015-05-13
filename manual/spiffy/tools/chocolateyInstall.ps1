$packageName = 'spiffy'
$packageVersion = '1.0.1'
$url="https://bintray.com/artifact/download/kireevco/generic/spiffy-${packageVersion}.zip"
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'mingw64\bin'

Install-ChocolateyZipPackage "$packageName" $url $installDir