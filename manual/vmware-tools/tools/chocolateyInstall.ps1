$url='http://packages.vmware.com/tools/esx/5.5latest/windows/x86/VMware-tools-9.4.12-2627939-i386.exe'
$url64='http://packages.vmware.com/tools/esx/5.5latest/windows/x64/VMware-tools-9.4.12-2627939-x86_64.exe'
$packageName = 'vmware-tools'
$fileType = 'exe'
$silentArgs = '/S /v /qn'

Install-ChocolateyPackage $packageName $fileType "$silentArgs" "$url" "$url64"