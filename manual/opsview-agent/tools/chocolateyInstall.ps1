$url='https://s3.amazonaws.com/opsview-agents/Windows/Opsview_Windows_Agent_Win32_28-01-15-1559.msi'
$url64='https://s3.amazonaws.com/opsview-agents/Windows/Opsview_Windows_Agent_x64_28-01-15-1600.msi'
$packageName = 'opsview-agent'
$fileType = 'msi'
$silentArgs = '/qn'

Install-ChocolateyPackage $packageName $fileType "$silentArgs" "$url" "$url64"