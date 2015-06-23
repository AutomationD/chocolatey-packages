$packageName = 'sming'
$binRoot = Get-BinRoot
$installDir = Join-Path "$binRoot" 'sming'
$mingwPath = "$binRoot\mingw64"
$mingw_get = Join-Path "$binRoot" "/mingw64/bin/mingw-get.exe"

function mingw-install ([string]$mingwPackageName) {    
    Start-ChocolateyProcessAsAdmin "install ${mingwPackageName} --reinstall --recursive" "${mingw_get}" -validExitCodes @(0,121)
    # & "${mingw_get} install ${mingwPackageName}"     
}


Update-SessionEnvironment
Write-Debug $env:Path

Write-Debug "Adding mingw & msys to the path"
Install-ChocolateyPath "${mingwPath}\bin;${mingwPath}\msys\1.0\bin" "Machine"

Write-Host "Installing / updading required mingw packages"
mingw-install "mingw32-base"
mingw-install "mingw32-mgwport"
mingw-install "mingw32-pdcurses"
mingw-install "mingw32-make"
mingw-install "mingw32-autoconf"
mingw-install "mingw32-automake"
mingw-install "mingw32-base"
mingw-install "mingw32-gdb"
mingw-install "gcc"
mingw-install "gcc-c++"
mingw-install "libz"
mingw-install "bzip2"
mingw-install "msys-base"
mingw-install "msys-coreutils"
mingw-install "msys-coreutils-ext"
mingw-install "msys-gcc-bin"
mingw-install "msys-wget-bin"
mingw-install "msys-m4"
mingw-install "msys-bison-bin"
mingw-install "msys-flex-bin"
mingw-install "msys-gawk"
mingw-install "msys-sed"
mingw-install "msys-autoconf"
mingw-install "msys-automake"
mingw-install "msys-mktemp"
mingw-install "msys-patch"
mingw-install "msys-libtool"
mingw-install "msys-make"
Update-SessionEnvironment