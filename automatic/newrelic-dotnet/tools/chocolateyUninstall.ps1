$packageName = 'newrelic-dotnet' # arbitrary name for the package, used in messages

try {

  # http://stackoverflow.com/questions/450027/uninstalling-an-msi-file-from-the-command-line-without-using-msiexec
  $msiArgs = "/X {1E9129D9-6FFB-4223-A6CC-E6D7BC21C38C} /qb"
  
  Start-ChocolateyProcessAsAdmin "$msiArgs" 'msiexec'

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}