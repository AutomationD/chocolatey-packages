# $package_version = "{{PackageVersion}}"
$url="{{DownloadUrl}}"

$package_name = 'logstash-contrib'
$package_dir="c:\logstash"


Write-Host "Making sure there are no traces of an old installation temp files. Cleaning up ${package_dir}\${package_name}-*\*"
Get-ChildItem "${package_dir}" | Where-Object {$_.Name -ilike "${package_name}*"} | Remove-Item -Recurse
Get-ChildItem "${package_dir}" | Where-Object {$_.Name -ilike "${package_name}Install*"} | Remove-Item




Get-ChocolateyWebFile "${package_name}" $(Join-Path $package_dir "${package_name}Install.tar.gz") $url $url
Get-ChocolateyUnzip $(Join-Path $package_dir "${package_name}Install.tar.gz") "${package_dir}"
Get-ChocolateyUnzip $(Join-Path $package_dir "${package_name}Install.tar") "${package_dir}"

Write-Host "Moving files from ${package_dir}\${package_name}-*\* to ${package_dir}"

Copy-Item "${package_dir}\${package_name}-*\*" "${package_dir}" -Force -Recurse


Write-Host "Cleaning up temp files & directories created during this install"
Remove-Item "${package_dir}\${package_name}*" -Recurse -Force
Remove-Item "${package_dir}\${package_name}Install*" -Recurse -Force


Write-ChocolateySuccess $package_name