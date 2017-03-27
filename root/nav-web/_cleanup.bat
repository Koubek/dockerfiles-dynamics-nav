call _presetvars.bat

docker rm -f %ContainerName%
docker rmi -f %host%/%ImageName%