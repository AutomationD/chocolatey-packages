$packageName = 'logstash-forwarder'
$serviceName = 'Logstash Forwarder'
$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot $packageName

if (Get-Service "$serviceName" -ErrorAction SilentlyContinue) {
  try {  
      
      if ($(Get-Service "$serviceName" -ErrorAction SilentlyContinue).Status -eq "Running") {
          # Start-ChocolateyProcessAsAdmin "Stop-Service \"${service_name}\" -Force"
          Start-ChocolateyProcessAsAdmin "\\localhost stop `"${serviceName}`"" "sc.exe"
          Start-Sleep 2
      }
      
      if ($(Get-Service "$serviceName"  -ErrorAction SilentlyContinue).Status -ne "Running") {
          Write-Host "Deleting ${serviceName} Service"        
  		    Start-ChocolateyProcessAsAdmin "\\localhost delete `"${serviceName}`"" "sc.exe"

          Write-Host "Cleaning ${installDir} directory"
          Remove-Item -recurse $(Join-Path $installDir "\*") -exclude *.conf, *-bak*, *-old*
      }

      Write-ChocolateySuccess $packageName
  } catch {
      Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
      throw
  }
}