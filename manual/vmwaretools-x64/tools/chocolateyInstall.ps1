$url='https://packages.vmware.com/tools/esx/latest/windows/x64/VMware-tools-9.4.11-2400950-x86_64.exe'
$packageName = 'vmwaretools-x64'
$installerType = 'exe'
$silentArgs = '/S /v "/qn'

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"