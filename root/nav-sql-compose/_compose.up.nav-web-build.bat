call _createlinks.bat
call ..\nav-web\_createlinks.bat
call ..\sql\_createlinks.bat

docker-compose -f docker-compose.yml -f docker-compose.nav-web-build.yml -f docker-compose.configs.yml up -d

powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navsqlcompose_nav_1
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navsqlcompose_sql_1