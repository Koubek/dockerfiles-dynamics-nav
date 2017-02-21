set /p host=<..\__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName:/=_%

docker stop %ContainerName%