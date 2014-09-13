$package_version = "2.6.1"
$package_name = 'mongodb.core.2.6'
$package_dir = Join-Path "c:\mongodb" $package_version


try {
    
    
    
    
    Write-Host "Cleaning ${package_dir} directory"
    Remove-Item -recurse $(Join-Path $package_dir "\*") -exclude *.conf, *-bak*, *-old*
    

    Write-ChocolateySuccess $package_name
} catch {
    Write-ChocolateyFailure $package_name "$($_.Exception.Message)"
    throw
}