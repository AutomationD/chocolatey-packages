#In order perform an unattended installation the setup.iss file must be in the same directory as the installer
$url="{{DownloadUrl}}"

$package_name = 'moxi'
$package_dir  = "c:\${package_name}"

if (!(Test-Path -path ${package_dir})) {
	echo "Creating $package_dir"
	New-Item "${package_dir}" -Type Directory | Out-Null
}

Install-ChocolateyZipPackage $package_name $url $package_dir