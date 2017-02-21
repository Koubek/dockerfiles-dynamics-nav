call _presetvars.bat

docker rm %ContainerName%
docker build -t %host%/%ImageName% .