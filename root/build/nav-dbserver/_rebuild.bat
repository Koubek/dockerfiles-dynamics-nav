call _presetvars.navdbserver.bat

docker rm %ContainerName%
docker build -t %host%/%ImageName% .