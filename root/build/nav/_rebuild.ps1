. (Join-Path $PSScriptRoot '_createlinks.ps1')
. (Join-Path $PSScriptRoot '_presetvars.ps1')

# Base NAV DVD content image (we won`t to avoid sending a context when the image already exists).
if (((docker images -q $navDvdImageName) | Measure-Object).Count -eq 0) {
    # Build NAVDVD image only if does not exist (maybe we could add -Force parameter to rebuild with force).
    Write-Verbose "NAV DVD CONTENT IMAGE DOES NOT EXIST..."
    . '..\nav_dvd\_rebuild.ps1'
} else {
    Write-Verbose "NAV DVD CONTENT IMAGE ALREADY EXISTS."
}

$convScriptPath = 'content\scripts\Convert-NavDockerfile.ps1'

# Base NAV installation.
if ($versionArgSupported -eq $true) {
    docker build -t $installedNavImageName --build-arg NAV_VERSION=$navVersion -f InstallNav.Dockerfile .
} else {
    (Get-ChildItem InstallNav.Dockerfile).FullName
    docker build -t $installedNavImageName -f (. $convScriptPath (Get-ChildItem InstallNav.Dockerfile).FullName $navVersion) .
}

# Create NAV image for SQL Authentication.
if ($versionArgSupported -eq $true) {
    docker build -t $($repo + '/' + $navImageNameSql) --build-arg NAV_VERSION=$navVersion -f NavSqlAuth.Dockerfile .
} else {
    docker build -t $($repo + '/' + $navImageNameSql) -f (. $convScriptPath (Get-ChildItem NavSqlAuth.Dockerfile).FullName $navVersion) .
}

# Create NAV image for WIN Authentication.
if ($versionArgSupported -eq $true) {
    docker build -t $($repo + '/' + $navImageNameWin) --build-arg NAV_VERSION=$navVersion -f NavWinAuth.Dockerfile .
} else {
    docker build -t $($repo + '/' + $navImageNameWin) -f (. $convScriptPath (Get-ChildItem NavWinAuth.Dockerfile).FullName $navVersion) .
}

# Install NAV with WEB
if ($versionArgSupported -eq $true) {
    docker build -t $($repo + '/' + $navWebImageName) --build-arg NAV_VERSION=$navVersion -f InstallWeb.Dockerfile .
} else {
    docker build -t $($repo + '/' + $navWebImageName) -f (. $convScriptPath (Get-ChildItem InstallWeb.Dockerfile).FullName $navVersion) .
}