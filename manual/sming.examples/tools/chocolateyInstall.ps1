Update-SessionEnvironment
$packageName = 'sming.examples'
$packageVersion = '1.0.5'
$url="https://github.com/anakod/Sming/archive/${packageVersion}.zip"
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'sming.examples'
$eclipseWorkspace = Join-Path $env:HOMEPATH "sming.examples"

function Install-ChocolateyDesktopLinkWithName {
<#
.SYNOPSIS
This adds a shortcut on the desktop to the specified file path.
.PARAMETER TargetFilePath
This is the location to the application/executable file that you want to add a shortcut to on the desktop.  This is mandatory.
.EXAMPLE
Install-ChocolateyDesktopLink -TargetFilePath "C:\tools\NHibernatProfiler\nhprof.exe"
This will create a new Desktop Shortcut pointing at the NHibernate Profiler exe.
#>
param(
  [string] $targetFilePath,
  [string] $shortcutArguments,
  [string] $shortcutName
)
  Write-Debug "Running 'Install-ChocolateyDesktopLink' with targetFilePath:`'$targetFilePath`'";
  
  if(!$targetFilePath) {
    Write-ChocolateyFailure "Install-ChocolateyDesktopLink" "Missing TargetFilePath input parameter."
    return
  }
  
  

  Write-Debug "Creating Shortcut..."
  
  try {
    $desktop = $([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory))
    $link = Join-Path $desktop "$([System.IO.Path]::GetFileName($shortcutName)).lnk"
    $workingDirectory = $([System.IO.Path]::GetDirectoryName($targetFilePath))

    $wshshell = New-Object -ComObject WScript.Shell
    $lnk = $wshshell.CreateShortcut($link)
    $lnk.TargetPath = $targetFilePath
    $lnk.Arguments = $shortcutArguments
    $lnk.WorkingDirectory = $workingDirectory
    $lnk.Save()

    Write-Debug "Desktop Shortcut created pointing at `'$targetFilePath`'."

    Write-ChocolateySuccess "Install-ChocolateyShortcut completed"
  } 
  catch {
    Write-ChocolateyFailure "Install-ChocolateyDesktopLink" "There were errors attempting to create shortcut. The error message was '$_'."
  } 
}

if (Get-Command "eclipse.exe" -ErrorAction SilentlyContinue) { 
    $eclipseExe = $(gcm "eclipse.exe" | Select-Object -ExpandProperty Definition)
    $eclipseExeC = $(gcm "eclipsec.exe" | Select-Object -ExpandProperty Definition)
    Install-ChocolateyZipPackage "$packageName" $url $installDir
    Copy-Item $installDir/Sming-$packageVersion/* $installDir/ -Force -Recurse
    Remove-Item $installDir/Sming-$packageVersion -force -Recurse

    Write-Host "Importing Examples"
    Start-ChocolateyProcessAsAdmin "-nosplash -data `"$eclipseWorkspace`" -application org.eclipse.cdt.managedbuilder.core.headlessbuild -importAll $installDir" "`"$eclipseExeC`""

    Write-Host "Creating shortcut to '$eclipseExe' -data $eclipseWorkspace"
    Install-ChocolateyDesktopLinkWithName "$eclipseExe" "-data `"$eclipseWorkspace`"" "Sming Examples"

    Update-SessionEnvironment
} else {
    Write-ChocolateyFailure $packageName "Can't find eclipse.exe in the PATH. Please make sure to add it.`nWe need this because we create eclipse workspace with examples for you`
    **There are few things to try:`n`
    choco install eclipse-cpp`
    choco update eclipse-cpp`
    choco install eclipse-cpp -source 'https://www.myget.org/F/kireevco-chocolatey/"
}
