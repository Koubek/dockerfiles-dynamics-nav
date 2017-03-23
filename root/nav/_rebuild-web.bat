call _presetvars.bat
call _createlinks.bat

docker rm %ContainerName%
docker build -t %host%/%ImageName% -f Dockerfile-web .