#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName = 'mongodb.core.2.2' # arbitrary name for the package, used in messages
$packageDirectory = 'mongodb'
$mongoVersion = '2.2.7'


$isWin7_2008R2_OrGreater = [Environment]::OSVersion.Version -ge (new-object 'Version' 6,1)
$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64

$fileName = "mongodb-win32-i386-$mongoVersion.zip"
if ($is64bit) {
    if ($isWin7_2008R2_OrGreater) {
        $fileName = "mongodb-win32-x86`_64-2008plus-$mongoVersion.zip"
    } else {
        $fileName = "mongodb-win32-x86`_64-$mongoVersion.zip"
    }
}

$url = "http://downloads.mongodb.org/win32/$fileName"

## Where we will install mongodb to: 
$binRoot = "$env:systemdrive"
if($env:chocolatey_bin_root -ne $null) {
	$binRoot = $env:chocolatey_bin_root
}

$mongoDir = $(join-path $(join-path $binRoot $packageDirectory) $mongoVersion)

# download and unpack a zip file
Install-ChocolateyZipPackage $packageName "$url" $binRoot



try { #error handling is only necessary if you need to do anything in addition to/instead of the main helpers
  # other helpers - using any of these means you want to uncomment the error handling up top and at bottom.
  # downloader that the main helpers use to download items
  #Get-ChocolateyWebFile "$packageName" 'DOWNLOAD_TO_FILE_FULL_PATH' "$url" "$url64"
  # installer, will assert administrative rights - used by Install-ChocolateyPackage
  #Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" '_FULLFILEPATH_' -validExitCodes $validExitCodes
  # unzips a file to the specified location - auto overwrites existing content
  #Get-ChocolateyUnzip "FULL_LOCATION_TO_ZIP.zip" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  # Runs processes asserting UAC, will assert administrative rights - used by Install-ChocolateyInstallPackage
  #Start-ChocolateyProcessAsAdmin 'STATEMENTS_TO_RUN' 'Optional_Application_If_Not_PowerShell' -validExitCodes $validExitCodes
  # add specific folders to the path - any executables found in the chocolatey package folder will already be on the path. This is used in addition to that or for cases when a native installer doesn't add things to the path.
  #Install-ChocolateyPath 'LOCATION_TO_ADD_TO_PATH' 'User_OR_Machine' # Machine will assert administrative rights
  # add specific files as shortcuts to the desktop
  #$target = Join-Path $MyInvocation.MyCommand.Definition "$($packageName).exe"
  #Install-ChocolateyDesktopLink $target
  
  #------- ADDITIONAL SETUP -------#
  # make sure to uncomment the error handling if you have additional setup to do
    
    $zipFileName = [io.path]::GetFileNameWithoutExtension($fileName)
    $scriptPath = $(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "$zipFileName")
    Write-Host "Script Path: $scriptPath" 
    
    
	$renameFrom = $($(join-path $binRoot $zipFileName)+"\")
	
	Write-Host "Renaming '$renameFrom' to $mongoDir"    
	robocopy $renameFrom  $($mongoDir+"\") /MIR /MOVE /NFL /NDL /NJH /NJS /nc /ns /np

    $dataDir = $(join-path $mongoDir 'data')
    if(!$(test-path $dataDir)){mkdir $dataDir}
    
    $dataDbDir = $(join-path $dataDir 'db')
    if (!$(test-path $dataDbDir)){mkdir $dataDbDir}

    $logsDir = $(join-path $mongoDir 'log')
    if(!$(test-path $logsDir)){mkdir $logsDir}

    $binDir = join-path $env:chocolateyinstall 'bin'

    #$mongoBats = Get-ChildItem -Path $mongoDir -Filter mongo*.bat

    #$batchFileName = Join-Path $mongoDir 'mongo.bat'
    #$executable = join-path $mongoDir 'bin\mongo.exe'
    #"@echo off
    #$executable %*" | Out-File $batchFileName -encoding ASCII

    
	#$batchFileName = Join-Path $mongoDir 'MongoRotateLogs.bat'
    #"@echo off
    #$executable --eval `'db.runCommand(`"logRotate`")`' mongohost:27017/admin" | Out-File $batchFileName -encoding ASCII


  
  # the following is all part of error handling
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}

