$packageName = '__NAME__' # arbitrary name for the package, used in messages

try {

  # http://stackoverflow.com/questions/450027/uninstalling-an-msi-file-from-the-command-line-without-using-msiexec
  $msiArgs = "/X __MSI_GUID__ /qb"
  
  Start-ChocolateyProcessAsAdmin "$msiArgs" 'msiexec'

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}