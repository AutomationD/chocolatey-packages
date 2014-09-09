$package_version = "1.4.2"
$url="https://download.elasticsearch.org/logstash/logstash/logstash-${package_version}.zip"

$package_name = 'logstash'
$service_name = "Logstash"
$package_dir="c:\${package_name}"

$current_datetime = Get-Date -format yyyyddMMhhmm
#$package_backup_dir = Join-Path ${package_dir} "${package_name}-old_${current_datetime}"
$package_backup_dir = "${package_dir}-old_${current_datetime}"

$bin_dir = $(Join-Path $package_dir "bin")
$log_dir = $(Join-Path $package_dir "log")
$config_dir = $(Join-Path $package_dir "conf.d")
$config_sample_dir = $(Join-Path $package_dir "conf.d.sample")

$log_file = $(Join-Path $log_dir "${package_name}.log")
$cmd_file = $(Join-Path $bin_dir "${package_name}.cmd")
$config_file = $(Join-Path $config_dir "${package_name}.conf")
$config_sample_file = $(Join-Path $config_dir "${package_name}.conf.sample")

try {

                                                                                                                if (Test-Path -path $package_dir) {
    if (!(Test-Path -path ${package_backup_dir})) {
    
        New-Item "${package_backup_dir}" -Type Directory | Out-Null
        Write-Host "Backing up current ${package_name} installation to ${package_backup_dir}."
        #Write-Host "Copy Recursively ${package_dir} to ${package_backup_dir} "
        Copy-Item -Recurse "${package_dir}\*" ${package_backup_dir} -Exclude *-old*

        Write-Host "Uninstalling current version of ${package_name}"
        cuninst logstash

        if ($LastExitCode -ne 0) {
            try {
    
                if ($(Get-Service "$service_name" -ErrorAction SilentlyContinue).Status -eq "Running") {
                    #Start-ChocolateyProcessAsAdmin "\\localhost stop `"${service_name}`"" "sc.exe"
                    Start-ChocolateyProcessAsAdmin "Stop-Service ${service_name} -Force"
                    Start-Sleep 2
                }
    
    
    
                if ($(Get-Service "$service_name"  -ErrorAction SilentlyContinue).Status -ne "Running") {
                    Remove-Item -recurse $(Join-Path $package_dir "\*") -exclude *.conf.*, *-bak*, *-old*
                }

                Write-ChocolateySuccess $package_name
            } catch {
                Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
                throw
            }
        }
    } else {
        Write-Error "Can't create more than 1 backup per minute (I know that's stupid). Please try in 1 minute."
    }


        Write-Host "Continuing ${package_name} installation"
    }

    
    
    #Write-Host "Making sure ${config_sample_dir} is in place"
    #if (!(Test-Path -path $config_sample_dir)) {New-Item $config_sample_dir -Type Directory  | Out-Null}

    Write-Host "Making sure ${config_dir} is in place"
    if (!(Test-Path -path $config_dir)) {New-Item $config_dir -Type Directory  | Out-Null}


    Write-Host "Making sure ${package_dir} is in place"
    if (!(Test-Path -path $package_dir)) {New-Item $package_dir -Type Directory  | Out-Null}

    Write-Host "Making sure ${log_dir} is in place"
    if (!(Test-Path -path $log_dir)) { New-Item $log_dir -Type Directory  | Out-Null }

    Install-ChocolateyZipPackage "${package_name}" $url $package_dir
    Move-Item "$(Join-Path ${package_dir} logstash-${package_version}\*)" "${package_dir}" -Force
    Remove-Item $(Join-Path ${package_dir} logstash-${package_version}) -Force


    if (!(Test-Path ($cmd_file)))
    {
      $cmdcontent = @"
cd /d ${package_dir}
bin/logstash.bat agent --config ${config_dir} --log ${log_file}
"@
        echo "Dropping a ${package_name}.cmd file"
        Set-Content $cmd_file $cmdcontent -Encoding ASCII -Force
    }


    if (!(Test-Path ($config_sample_file)))
    {
      $confcontent = @"
input {
    stdin {}
}

output {
    stdout {}
}
"@  

        echo "Dropping a sample ${package_name}.conf.sample file - rename it to logstash.conf if you want to use it!"
        Set-Content $config_sample_file $confcontent -Encoding ASCII -Force
    }


    if ($serviceinfo = Get-Service "${service_name}" -ErrorAction SilentlyContinue)
    {
	    if ($serviceinfo.status -ne 'Running')
	    {
		    if ($serviceinfo.status -eq 'Stopped')
		    {
			    echo "${service_name} service found and is stopped."
			    echo "Deletinng ${service_name} Service"

			    #Start-ChocolateyProcessAsAdmin sc.exe \\localhost delete "${service_name}"
                Start-ChocolateyProcessAsAdmin "\\localhost delete `"${service_name}`"" "sc.exe"

                echo "Installing ${service_name} Service"
			    Start-ChocolateyProcessAsAdmin "install ${service_name} ${cmd_file}" nssm
		    }
	    }
	    else
	    {
		    echo "Stoping ${service_name} Service"
		    Start-ChocolateyProcessAsAdmin "\\localhost stop `"${service_name}`"" "sc.exe"
		    Start-ChocolateyProcessAsAdmin echo "Deleting "${service_name}" Service"
		    Start-ChocolateyProcessAsAdmin "\\localhost delete `"${service_name}`"" "sc.exe"
		    echo "Installing ${service_name} Service"
		    Start-ChocolateyProcessAsAdmin "install ${service_name} ${cmd_file}" nssm

	    }
    }
    else
    {
	    echo "No ${service_name} Service detected"
        echo "Installing ${service_name} Service"
    

	    Start-ChocolateyProcessAsAdmin "install ${service_name} ${cmd_file}" nssm
    }

    Write-ChocolateySuccess $package_name
    
    #Autostart disabled
    #Start-ChocolateyProcessAsAdmin "Start-Service ${service_name}"

} catch {
    Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
    throw
}
