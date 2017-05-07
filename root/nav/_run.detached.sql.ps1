# . (Join-Path $PSScriptRoot '_createlinks.ps1')
. (Join-Path $PSScriptRoot '_presetvars.ps1')

docker rm $defaultNavContainerNameSql
docker run -d --hostname=NAVSERVER -p 7045-7048:7045-7048 -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" -e "nav_user=navuser" -e "nav_user_pwd=pwd" -e "import_cronus_license=false" -e "config_instance=false" --name %ContainerName% %host%/%ImageName%
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' %ContainerName%