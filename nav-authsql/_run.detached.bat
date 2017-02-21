set /p host=<..\__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName::=_%

docker rm %ContainerName%
docker run -d --hostname=NAVSERVER -p 7045-7048:7045-7048 -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" -e "nav_user=navuser" -e "nav_user_pwd=pwd" -e "import_cronus_license=false" --name %ContainerName% %host%/%ImageName%
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' %ContainerName%