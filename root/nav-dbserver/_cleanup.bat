call _presetvars.navdbserver.bat

docker rm %ContainerName%
docker rmi %host%/%ImageName%