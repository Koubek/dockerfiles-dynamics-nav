set /p host=<__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName:/=_%

docker rm -f %ContainerName%
docker run -it --name %ContainerName% %host%/%ImageName%
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' %ContainerName%