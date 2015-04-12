$packageName = 'sming'
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'sming'

$mingw_get = Join-Path "$binRoot" "/mingw64/bin/mingw-get.exe"

Update-SessionEnvironment
Write-Host "Installing required mingw packages"
Write-Debug $env:Path

Start-ChocolateyProcessAsAdmin "install mingw32-base" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-mgwport" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-pdcurses" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-make" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-autoconf" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-automake" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-base" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install mingw32-gdb" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install gcc" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install gcc-c++" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install libz" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install bzip2" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-base" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-coreutils" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-coreutils-ext" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-gcc-bin" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-wget-bin" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-m4" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-bison-bin" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-flex-bin" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-gawk" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-sed" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-autoconf" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-automake" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-mktemp" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-patch" "${mingw_get}"
Start-ChocolateyProcessAsAdmin "install msys-libtool" "${mingw_get}"