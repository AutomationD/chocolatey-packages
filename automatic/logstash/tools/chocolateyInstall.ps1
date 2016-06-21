# $package_version = "{{PackageVersion}}"
$url="{{DownloadUrl}}"

$package_name = 'logstash'
$service_name = "Logstash"
$package_dir="c:\${package_name}"

$current_datetime = Get-Date -format yyyyddMMhhmm
$package_backup_dir = "${package_dir}-old_${current_datetime}"

$bin_dir = $(Join-Path $package_dir "bin")
$log_dir = $(Join-Path $package_dir "log")
$config_dir = $(Join-Path $package_dir "conf.d")
$config_sample_dir = $(Join-Path $package_dir "conf.d.sample")

$log_file = $(Join-Path $log_dir "${package_name}.log")
$cmd_file = $(Join-Path $bin_dir "${package_name}.cmd")
$config_file = $(Join-Path $config_dir "${package_name}.conf")
$config_sample_file = $(Join-Path $config_dir "${package_name}.conf.sample")


## Additional Parameters ##
$autostart_enabled = $false
$backup_enabled = $true
$config_enabled = $false
if (![string]::IsNullOrEmpty($env:chocolateyPackageParameters))
{
  if ($env:chocolateyPackageParameters.ToLower().Contains("autostart") -or $env:chocolateyPackageParameters.ToLower().Contains("backup") -or $env:chocolateyPackageParameters.ToLower().Contains("config") )
  {   
    # Getting Parameters
    $rawTxt =  [regex]::escape($env:chocolateyPackageParameters)
    $params = $($rawTxt -split ';' | ForEach-Object {
       $temp= $_ -split '='
       "{0}={1}" -f $temp[0].Substring(0,$temp[0].Length),$temp[1]
    } | ConvertFrom-StringData)


    if ($params.autostart -eq 'true')
    {     
      Write-Host "Found 'autostart' parameter enabled."
      $autostart_enabled = $true
      
    }
    else
    {
      Write-Host "Found 'autostart' parameter disabled."
      $autostart_enabled = $false
    }
    
    if ($params.backup -eq 'true')
    {     
      Write-Host "Found 'backup' parameter enabled."
      $backup_enabled = $true      
    }
    else
    {
      Write-Host "Found 'backup' parameter disabled."
      $backup_enabled = $false
    }
    
    if ($params.config -eq 'true')
    {     
      Write-Host "Found 'config' parameter enabled. Sample config will be saved as conf.d\logstash.conf"
      $config_enabled = $true      
    }
    else
    {
      Write-Host "Found 'config' parameter disabled."
      $config_enabled = $false
    }
  }
}

try {                                                                                                           
  if (Test-Path -path $package_dir) {
    if (!(Test-Path -path ${package_backup_dir})) {
    
      if ($backup_enabled)
      {
        New-Item "${package_backup_dir}" -Type Directory | Out-Null
        Write-Host "Backing up current ${package_name} installation to ${package_backup_dir}."
        Copy-Item -Recurse "${package_dir}\*" ${package_backup_dir} -Exclude *-old*
      }
      
      Write-Host "Uninstalling current version of ${package_name}"
      cuninst logstash      

      if ($LastExitCode -ne 0) {
        if (Get-Service "$service_name" -ErrorAction SilentlyContinue) {
          try {
              if ($(Get-Service "$service_name" -ErrorAction SilentlyContinue).Status -eq "Running") {
                Start-ChocolateyProcessAsAdmin "\\localhost stop `"${service_name}`"" "sc.exe"
                Start-Sleep 2
              }
              
              if ($(Get-Service "$service_name"  -ErrorAction SilentlyContinue).Status -ne "Running") {
                Remove-Item -recurse $(Join-Path $package_dir "\*") -exclude *.conf.*, *-bak*, *-old*
              }
          } catch {
            Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
            throw
          }
        }
      } else {
        Write-Host "Done uninstalling ${package_name}"
      }
    } else {
      Write-Error "Can't create more than 1 backup per minute (I know that's stupid). Please try in 1 minute."
    }


        Write-Host "Continuing ${package_name} installation"
    }

    
    
    # Sample dir (not used now)
    #Write-Host "Making sure ${config_sample_dir} is in place"
    #if (!(Test-Path -path $config_sample_dir)) {New-Item $config_sample_dir -Type Directory  | Out-Null}

    Write-Host "Making sure ${config_dir} is in place"
    if (!(Test-Path -path $config_dir)) {New-Item $config_dir -Type Directory  | Out-Null}


    Write-Host "Making sure ${package_dir} is in place"
    if (!(Test-Path -path $package_dir)) {New-Item $package_dir -Type Directory  | Out-Null}

    Write-Host "Making sure ${log_dir} is in place"
    if (!(Test-Path -path $log_dir)) { New-Item $log_dir -Type Directory  | Out-Null }

    Write-Host "Installing ${package_name} from ${url} to ${package_dir}"
    Install-ChocolateyZipPackage "${package_name}" $url $package_dir
    Move-Item "$(Join-Path ${package_dir} logstash-*\*)" "${package_dir}" -Force
    Remove-Item "$(Join-Path ${package_dir} logstash-*)" -Force


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
      if ($config_enabled)
      {
        echo "Dropping a ${config_file} file (so you can start ${package_name} service right away."
        Set-Content $config_file $confcontent -Encoding ASCII -Force    
      }
      else
      {
        echo "Dropping a sample ${package_name}.conf.sample file - rename it to logstash.conf if you want to use it!"
        Set-Content $config_sample_file $confcontent -Encoding ASCII -Force       
      }   
    }

    if ($serviceinfo = Get-Service "${service_name}" -ErrorAction SilentlyContinue)
    {
      if ($serviceinfo.status -ne 'Running')
      {
        if ($serviceinfo.status -eq 'Stopped')
        {
          echo "${service_name} service found and is stopped."
          
          echo "Deleting ${service_name} Service"          
          Start-ChocolateyProcessAsAdmin "\\localhost delete `"${service_name}`"" "sc.exe"
          
          echo "Installing ${service_name} Service"
          Start-ChocolateyProcessAsAdmin "install ${service_name} ${cmd_file}" nssm
        }
      }
      else
      {
        echo "Stopping ${service_name} Service"
        Start-ChocolateyProcessAsAdmin "\\localhost stop `"${service_name}`"" "sc.exe"
        
        echo "Deleting "${service_name}" Service"
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

    #Write-ChocolateySuccess $package_name
    
    if ($autostart_enabled)
    {
      Write-Host "Starting ${service_name}"
      Start-ChocolateyProcessAsAdmin "Start-Service ${service_name}"
    }

} catch {
    #Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
    throw
}