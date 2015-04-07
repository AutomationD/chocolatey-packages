$url = 'https://download.elasticsearch.org/logstash-forwarder/binaries/logstash-forwarder_windows_386.exe'
$url64bit = $url
$packageName = 'logstash-forwarder'
$serviceName = 'Logstash Forwarder'
$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot $packageName
$fileFullPath = Join-Path $installDir "${packageName}.exe"
$stdoutLogFile = Join-Path $installDir "${packageName}.log"
$errorLogFile = $stdoutLogFile
$checksum = '9b8fc3ce684f0fb5e9555560b89923a769efd97e'
$checksumType = 'sha1'
$checksum64 = $checksum
$checksumType64 = $checksumType
$configFile = $null

## Additional Parameters ##
$autostartEnabled = $false



# Arguments
if (![string]::IsNullOrEmpty($env:chocolateyPackageParameters))
{
  if ($env:chocolateyPackageParameters.ToLower().Contains("autostart") -or $env:chocolateyPackageParameters.ToLower().Contains("config"))
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
      $autostartEnabled = $true
      
    }
    else
    {
      Write-Host "Found 'autostart' parameter disabled."
      $autostartEnabled = $false
    }

    if ($params.config) {
      $configFile = Join-Path $installDir $params.config      
    } else {
      $configFile = "${packageName}.conf"
    }
  }
} else {
  $configFile = "${packageName}.conf"
}

$serverCmd = "`"${fileFullPath} -config ${configFile}`""

try {                                                                                                           
    if (!(Test-Path -path $installDir)) {
      New-Item -ItemType directory -Path $installDir
    }

    Write-Host "Installing ${packageName} from ${url} to ${installDir}"
    Get-ChocolateyWebFile $packageName $fileFullPath $url $url64bit `
 -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 `
 -checksumType64 $checksumType64    

    if ($serviceinfo = Get-Service "${serviceName}" -ErrorAction SilentlyContinue)
    {
      if ($serviceinfo.status -ne 'Running')
      {
        if ($serviceinfo.status -eq 'Stopped')
        {
          echo "${serviceName} service found and is stopped."
          
          echo "Deleting ${serviceName} Service"          
          Start-ChocolateyProcessAsAdmin "remove `"${serviceName}`" confirm" nssm
          
          echo "Installing ${serviceName} Service"
          Start-ChocolateyProcessAsAdmin "install `"${serviceName}`" `"${serverCmd}`"" nssm
        }
      }
      else
      {
        echo "Stopping ${serviceName} Service"
        Start-ChocolateyProcessAsAdmin "stop `"${serviceName}`"" nssm
        
        echo "Deleting "${serviceName}" Service"
        Start-ChocolateyProcessAsAdmin "remove `"${serviceName}`" confirm" nssm
        
        echo "Installing ${serviceName} Service"
        Start-ChocolateyProcessAsAdmin "install `"${serviceName}`" `"${serverCmd}`"" nssm
      }
    }
    else
    {
      echo "No ${serviceName} Service detected"
      echo "Installing ${serviceName} Service"
      Start-ChocolateyProcessAsAdmin "install `"${serviceName}`" `"${serverCmd}`"" nssm
    }

    echo "Configuring logs"
    
    Start-ChocolateyProcessAsAdmin "set `"${serviceName}`" AppStdout ${stdoutLogFile}" nssm
    Start-ChocolateyProcessAsAdmin "set `"${serviceName}`" AppStderr ${errorLogFile}" nssm
    
    Write-ChocolateySuccess $packageName
    
    if ($autostartEnabled)
    {
      Write-Host "Starting ${serviceName}"
      Start-ChocolateyProcessAsAdmin "start `"${serviceName}`"" nssm
    }

} catch {
    Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
    throw
}