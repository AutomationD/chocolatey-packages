$packageName = 'eclipse'

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\Uninstall-ChocolateyZipPackage030.ps1"

Uninstall-ChocolateyZipPackage030 "$packageName"