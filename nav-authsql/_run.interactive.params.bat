set /p host=<__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName:/=_%

docker run -ti --rm --hostname=NAVSERVER -e "sql_server=sql_ip\sqlexpress" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" %host%/%ImageName%