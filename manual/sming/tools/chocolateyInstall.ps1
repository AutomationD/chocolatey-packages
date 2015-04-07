$packageName = 'sming'
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'sming'

$mingw_get = '$binRoot/mingw64/bin/mingw-get.exe'

Update-SessionEnvironment
Write-Host "Installing required mingw packages"
Write-Debug $env:Path

& "mingw-get" install mingw32-base
& "mingw-get" install mingw32-mgwport
& "mingw-get" install mingw32-pdcurses
& "mingw-get" install mingw32-make
& "mingw-get" install mingw32-autoconf
& "mingw-get" install mingw32-automake
& "mingw-get" install mingw32-base
& "mingw-get" install mingw32-gdb
& "mingw-get" install gcc
& "mingw-get" install gcc-c++
& "mingw-get" install libz
& "mingw-get" install bzip2
& "mingw-get" install msys-base
& "mingw-get" install msys-coreutils
& "mingw-get" install msys-coreutils-ext
& "mingw-get" install msys-gcc-bin
& "mingw-get" install msys-wget-bin
& "mingw-get" install msys-m4
& "mingw-get" install msys-bison-bin
& "mingw-get" install msys-flex-bin
& "mingw-get" install msys-gawk
& "mingw-get" install msys-sed
& "mingw-get" install msys-autoconf
& "mingw-get" install msys-automake
& "mingw-get" install msys-mktemp
& "mingw-get" install msys-patch
& "mingw-get" install msys-libtool