$package_version = "2.6.1"

$package_name = 'mongodb.core.2.6'
$package_dir=Join-Path "c:\mongodb" $package_version

$bin_dir = $(Join-Path $package_dir "bin")
$log_dir = $(Join-Path $package_dir "log")
$log_file = $(Join-Path $log_dir "${package_name}.log")

$current_datetime = Get-Date -format yyyyddMMhhmm
$package_backup_dir = "${package_dir}-old_${current_datetime}"

$is_win7_2008r2_or_greater = [Environment]::OSVersion.Version -ge (new-object 'Version' 6,1)
$is_64bit = $(Get-WmiObject Win32_Processor).AddressWidth -eq 64

if ($is_64bit) {
    if ($is_win7_2008r2_or_greater) {
        $package_file_name = "mongodb-win32-x86`_64-2008plus-${package_version}"
        
    } else {
        $package_file_name = "mongodb-win32-x86`_64-${package_version}"
    }
}



$url="http://downloads.mongodb.org/win32/${package_file_name}.zip"


try {
    
    
    if (!(Test-Path -path ${package_backup_dir}) -and (Test-Path -Path ${package_dir})) {
    
        New-Item "${package_backup_dir}" -Type Directory | Out-Null
        Write-Host "Backing up current ${package_name} installation from ${package_dir}\* to ${package_backup_dir}."
        #Write-Host "Copy Recursively ${package_dir} to ${package_backup_dir} "
        Copy-Item -Recurse "${package_dir}\*" ${package_backup_dir} -Exclude *-old*

        Write-Host "Uninstalling current version of ${package_name}"
        cuninst $package_name

        if ($LastExitCode -ne 0) {
            Write-Host "Uninstaller not found. Current version probably doesn't have it. Executing built-in uninstall"
            try {
                Remove-Item -recurse $(Join-Path $package_dir "\*") -exclude *.conf.*, *-bak*, *-old*                

                Write-ChocolateySuccess $package_name
            } catch {
                Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
                throw
            }
        }
    } else {
        if (Test-Path -path ${package_backup_dir}){
            Write-Error "Can't create more than 1 backup per minute (I know that's stupid). Please try in 1 minute."
        }
        
    }

    Install-ChocolateyZipPackage "${package_name}" $url $package_dir


    Move-Item "$(Join-Path ${package_dir} ${package_file_name}\*)" "${package_dir}" -Force
    Remove-Item $(Join-Path ${package_dir} ${package_file_name}) -Force -Recurse

    Write-Host "Making sure ${package_dir} is in place"
    if (!(Test-Path -path $package_dir)) {New-Item $package_dir -Type Directory  | Out-Null}

    Write-Host "Making sure ${log_dir} is in place"
    if (!(Test-Path -path $log_dir)) { New-Item $log_dir -Type Directory  | Out-Null }

    Write-ChocolateySuccess $package_name

} catch {
    Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
    throw
}