set /p host=<..\__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName:/=_%

docker rm %ContainerName%
docker run -d --hostname=NAVSERVER -e "sql_server=sql_ip\sqlexpress" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" --name %ContainerName% %host%/%ImageName%
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' %ContainerName%