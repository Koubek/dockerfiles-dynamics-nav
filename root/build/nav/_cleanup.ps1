. (Join-Path $PSScriptRoot '_createlinks.ps1')
. (Join-Path $PSScriptRoot '_presetvars.ps1')

docker rmi $($repo + '/' + $navImageNameSql)
docker rmi $($repo + '/' + $navImageNameWin)
docker rmi $($repo + '/' + $navWebImageName)