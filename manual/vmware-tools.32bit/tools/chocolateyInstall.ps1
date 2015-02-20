$url='https://packages.vmware.com/tools/esx/latest/windows/x86/VMware-tools-9.4.11-2400950-i386.exe'
$packageName = 'vmware-tools.32bit'
$installerType = 'exe'
$silentArgs = '/S /v "/qn'

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"