$url='http://packages.vmware.com/tools/esx/latest/windows/x86/VMware-tools-9.4.11-2400950-i386.exe'
$url64='http://packages.vmware.com/tools/esx/latest/windows/x64/VMware-tools-9.4.11-2400950-x86_64.exe'
$packageName = 'vmware-tools'
$fileType = 'exe'
$silentArgs = '/S /v /qn'

Install-ChocolateyPackage $packageName $fileType "$silentArgs" "$url" "$url64"