$url='http://programs74.ru/get.php?file=EspressifESP8266DevKit'
$packageName = 'esp8266-udk'
$installerType = 'exe'
$silentArgs = '/VERYSILENT'

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"