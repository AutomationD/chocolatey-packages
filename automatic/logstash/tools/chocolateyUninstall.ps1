$package_name = 'logstash'
$service_name = "Logstash"
$package_dir="c:\$package_name"

try {
    
    if ($(Get-Service "$service_name" -ErrorAction SilentlyContinue).Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "Stop-Service ${service_name} -Force"
        Start-Sleep 2
    }
    
    if ($(Get-Service "$service_name"  -ErrorAction SilentlyContinue).Status -ne "Running") {
        Write-Host "Deleting ${service_name} Service"        
		Start-ChocolateyProcessAsAdmin "\\localhost delete ${service_name}" "sc.exe"

        Write-Host "Cleaning ${package_dir} directory"
        Remove-Item -recurse $(Join-Path $package_dir "\*") -exclude *.conf, *-bak*, *-old*
    }

    Write-ChocolateySuccess $package_name
} catch {
    Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
    throw
}