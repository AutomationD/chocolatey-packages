#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

#Items that could be replaced based on what you call chocopkgup.exe with
#{{PackageName}} - Package Name (should be same as nuspec file and folder) |/p
#{{PackageVersion}} - The updated version | /v
#{{DownloadUrl}} - The url for the native file | /u
#{{PackageFilePath}} - Downloaded file if including it in package | /pp
#{{PackageGuid}} - This will be used later | /pg
#{{DownloadUrlx64}} - The 64bit url for the native file | /u64


function getVersionFromUrl($url) {
    $f = $URL.Substring($url.LastIndexOf("/") + 1)
    $n = [System.IO.Path]::GetFileNameWithoutExtension($f)
    $pos = $n.LastIndexOf("-")
    $ver =  $n.Substring($pos+1)
    return $ver    
}

function getBaseUrl($url){
    return $URL.Substring(0,$url.LastIndexOf("/"))
}



$version = getVersionFromUrl("{{DownloadUrl}}")
$base_url = getBaseUrl("{{DownloadUrl}}")

$package_root = Join-Path $(Get-BinRoot) "mongodb"
$package_name = "mongodb.core.2.6"
$package_version = "2.6"
$package_dir=Join-Path $package_root $package_version
$bin_dir = $(Join-Path $package_dir "bin")
$log_dir = $(Join-Path $package_dir "log")
$log_file = $(Join-Path $log_dir "${package_name}.log")

$current_datetime = Get-Date -format yyyyddMMhhmm
$package_backup_dir = "${package_dir}_old_${current_datetime}"

$is_win7_2008r2_or_greater = [Environment]::OSVersion.Version -ge (new-object 'Version' 6,1)
$is_64bit = $(Get-WmiObject Win32_Processor).AddressWidth -eq 64

if ($is_64bit) {
    if ($is_win7_2008r2_or_greater) {
        $package_file_name = "mongodb-win32-x86_64-2008plus-${version}"
        
    } else {
        $package_file_name = "mongodb-win32-x86_64-${version}"
    }
}
else {
	$package_file_name = "mongodb-win32-i386-${version}"
}



$url = "{{DownloadUrl}}"
$url64="${base_url}/${package_file_name}.zip"


try {
    if (!((Test-Path -path ${package_backup_dir})) -and (Test-Path -Path ${package_dir})) {
    
        New-Item "${package_backup_dir}" -Type Directory | Out-Null
        
		Write-Host "Backing up current ${package_name} installation from ${package_dir}\* to ${package_backup_dir}."        
		Copy-Item -Recurse "${package_dir}\*" ${package_backup_dir} -Exclude *-old*

        Write-Host "Uninstalling current version of ${package_name}"
        cuninst $package_name

        if ($LastExitCode -ne 0) {
            Write-Host "Uninstaller not found. Current version probably doesn't have it. Executing built-in uninstall"
            try {
                Remove-Item -recurse $(Join-Path $package_dir "\") -exclude *.conf.*, *-bak*, *-old*                
                Write-ChocolateySuccess $package_name
            } catch {
                Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
                throw
            }
        }
    } else {
        Write-Host "Uninstaller was found. Uninstall finished."
        if (Test-Path -path ${package_backup_dir}){
            Write-Error "Can't create more than 1 backup per minute (I know that's stupid). Please try in 1 minute."
        }
        
    }
	
	# Write-Host "Making sure ${package_dir} is in place"
    # if (!(Test-Path -path $package_dir)) {New-Item $package_dir -Type Directory  | Out-Null}
	
	
	Write-Host "Installing ${package_name} from ${url} / ${url64}"
    Install-ChocolateyZipPackage "${package_name}" $url "${package_root}" $url64

	
	#Write-Host "Moving $(Join-Path $root_dir $package_file_name) to ${package_dir}"
    
	Rename-Item $(Join-Path $package_root $package_file_name) $package_dir -Force
    #Remove-Item $(Join-Path ${root_dir} ${package_file_name}) -Force -Recurse

    
    Write-Host "Making sure ${log_dir} is in place"
    if (!(Test-Path -path $log_dir)) { New-Item $log_dir -Type Directory  | Out-Null }

    Write-Host "Placing _version file"
    $versionfilecontent = @"
Chocolatey package: {{PackageName}} v{{PackageVersion}}
MongoDB: v${version}
"@
    Set-Content $(Join-Path $package_dir "_version") $versionfilecontent -Encoding ASCII -Force
    Write-ChocolateySuccess $package_name

} catch {
    Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
    throw
}

