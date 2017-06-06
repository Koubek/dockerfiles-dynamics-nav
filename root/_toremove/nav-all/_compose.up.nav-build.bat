call _presetvars.bat

call _createlinks.bat
call ..\nav-web\_createlinks.bat
call ..\nav\_createlinks.bat
call ..\sql\_createlinks.bat

set NAV_VERSION=%NavVersion%

echo docker-compose -f docker-compose.yml -f docker-compose.nav-build.yml -f docker-compose.configs.yml build --build-arg NAV_VERSION=%NavVersion% nav
echo docker-compose -f docker-compose.yml -f docker-compose.nav-build.yml -f docker-compose.configs.yml build --build-arg NAV_VERSION=%NavVersion% web
echo docker-compose -f docker-compose.yml -f docker-compose.nav-build.yml -f docker-compose.configs.yml build sql
docker-compose -f docker-compose.yml -f docker-compose.nav-build.yml -f docker-compose.configs.yml up -d

powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_web_1
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_nav_1
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_sql_1

powershell -command "Out-File \"$env:windir\System32\drivers\etc\hosts\" -inputObject ((docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_web_1) + ' navallweb1')"
powershell -command "Out-File -Append \"$env:windir\System32\drivers\etc\hosts\" -inputObject ((docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_nav_1) + ' navall_nav_1')"
powershell -command "Out-File -Append \"$env:windir\System32\drivers\etc\hosts\" -inputObject ((docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_sql_1) + ' navall_sql_1')" 