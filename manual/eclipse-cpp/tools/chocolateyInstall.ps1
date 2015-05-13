$packageName = 'eclipse-cpp'
$packageVersion = '4.4.2'

$32BitUrl = 'https://bintray.com/artifact/download/kireevco/generic/eclipse-cpp-luna-SR2-win32.zip'
$64BitUrl = 'https://bintray.com/artifact/download/kireevco/generic/eclipse-cpp-luna-SR2-win32-x86_64.zip'

$global:installLocation = "C:\Program Files\Eclipse Foundation\$packageVersion"
$checksum = '82695bd4bce4db8a111b1e93d6bfcf23'
$checksumType = 'md5'
$checksum64 = '8eb16092567643ef89da3a352ef878a3'
$checksumType64 = 'md5'

if (!(Test-Path $global:installLocation)) {
    if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
    . "$PSScriptRoot\OverwriteParameters030.ps1"

    OverwriteParameters030

    Install-ChocolateyZipPackage "$packageName" "$32BitUrl" "$global:installLocation" "$64BitUrl" -checksum "$checksum" -checksumType "$checksumType" -checksum64 "$checksum64" -checksumType64 "$checksumType64"

    $eclipseExecutable = "$global:installLocation\eclipse\eclipse.exe"

    Install-ChocolateyDesktopLink "$eclipseExecutable"
    Install-ChocolateyPinnedTaskBarItem "$eclipseExecutable"
} else {
    Write-Host "Eclipse looks already insalled. Using it." -foregroundcolor "green"
}
Write-Host "Ensuring Eclipse is in the PATH"
Install-ChocolateyPath $(Join-Path $global:installLocation "eclipse") 'Machine'
