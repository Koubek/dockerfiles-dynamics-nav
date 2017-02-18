set /p host=<__privatereponame.txt
set /p ImageName=<__imagename.txt
set ContainerName=%ImageName:/=_%

docker run -ti --rm --hostname=NAVSERVER -v %cd%\content\scripts:c:\scripts %host%/%ImageName% powershell