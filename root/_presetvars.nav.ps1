Remove-Item (Join-Path $PSScriptRoot '__imageversion.nav.txt')
& (Join-Path $PSScriptRoot '__content\NAV\scripts\Get-NavVersion.ps1') (Join-Path $PSScriptRoot '__content_user\NAVDVD') > (Join-Path $PSScriptRoot '__imageversion.nav.txt')

$versionArgSupported = [System.Version] $($(docker version --format '{{.Server.Version}}').SubString(0, 5)) -ge [System.Version] "17.05"

$repo = Get-Content (Join-Path $PSScriptRoot '__privatereponame.txt')
Write-Verbose "REPO: $repo"
$imageName = Get-Content (Join-Path $PSScriptRoot '__imagename.nav.txt')
Write-Verbose "BASE IMAGE NAME: $imageName"
$navVersion = Get-Content (Join-Path $PSScriptRoot '__imageversion.nav.txt')
Write-Verbose "NAV VERSION: $navVersion"

$navDvdImageName = 'navdvd:' + $navVersion
$installedNavImageName = 'navinstalled:' + $navVersion

$navImageNameWin = $imageName + '-win:' + $navVersion
$navImageNameSql = $imageName + '-sql:' + $navVersion
$navWebImageName = $imageName + '-web:' + $navVersion

$imageName = $imageName + ':' + $navVersion

$defaultNavContainerNameWin = $navImageNameWin.Replace(':', '_')
$defaultNavContainerNameSql = $navImageNameSql.Replace(':', '_')
$defaultNavWebContainerName = $navWebImageName.Replace(':', '_')

# Use as a standard environment variables in docker-compose files 
# => docker-compose can use them so the images are defined in this way.
$env:repo = $repo
$env:navImageNameWin = $navImageNameWin
$env:navImageNameSql = $navImageNameSql
$env:navWebImageName = $navWebImageName