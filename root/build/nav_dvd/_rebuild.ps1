. (Join-Path $PSScriptRoot '_presetvars.ps1')
. (Join-Path $PSScriptRoot '_createlinks.ps1')

Write-Verbose "BUILDING NAV DVD CONTENT IMAGE: $navDvdImageName"
docker build -t $navDvdImageName -f (Join-Path $PSScriptRoot 'Dockerfile') $PSScriptRoot
