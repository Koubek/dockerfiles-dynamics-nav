. (Join-Path $PSScriptRoot '_createlinks.ps1')
. (Join-Path $PSScriptRoot '_presetvars.ps1')

docker push $($repo + '/' + $sqlImageName)