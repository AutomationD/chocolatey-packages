$packageName = 'bc'
$packageVersion = '1.06-2'
$url="http://downloads.sourceforge.net/project/gnuwin32/bc/${packageVersion}/bc-${packageVersion}.exe"
$binRoot = Get-BinRoot
$installDir = "${binRoot}\mingw64"

Install-ChocolateyPackage 'bc' 'exe' "/SILENT /DIR=${installDir}" $url