. '.\_createlinks.ps1'
. '.\_presetvars.ps1'

docker rmi $($repo + '/' + $sqlImageName)