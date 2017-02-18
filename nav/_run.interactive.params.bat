set /p host=<__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName:/=_%

docker run -ti --rm --hostname=NAVSERVER -v %cd%\content\scripts:c:\scripts -e "sql_server=sqlip\sqlexpress" -e "sql_db=navdbname" -e "sql_user=user" -e "sql_pwd=pwd" %host%/%ImageName%