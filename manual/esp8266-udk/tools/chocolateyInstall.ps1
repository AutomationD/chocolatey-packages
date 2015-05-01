$url='http://programs74.ru/get.php?file=EspressifESP8266DevKit'
$packageName = 'esp8266-udk'
$installerType = 'exe'
$silentArgs = '/VERYSILENT'
$installDir = 'c:/Espressif'

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"

Install-ChocolateyEnvironmentVariable "ESP_HOME" "$installDir"
Write-Debug "Set ESP_HOME to $installDir"
