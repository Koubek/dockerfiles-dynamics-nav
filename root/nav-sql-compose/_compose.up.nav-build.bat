call _createlinks.bat
call ..\nav\_createlinks.bat
call ..\sql\_createlinks.bat

docker-compose -f docker-compose.yml -f docker-compose.nav-build.yml -f docker-compose.configs.yml up -d

call _compose.inspect.ips.bat