[CmdletBinding()]
param (

)

. (Join-Path $PSScriptRoot '_createlinks.ps1')
. (Join-Path $PSScriptRoot '_presetvars.ps1')

docker-compose -f docker-compose.yml -f docker-compose.configs.yml up 

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navsqlweb_sql_1
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navsqlweb_nav_1
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navsqlweb_web_1