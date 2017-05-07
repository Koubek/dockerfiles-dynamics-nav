call _createlinks.bat

docker-compose up -d

powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_web_1
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_nav_1
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_sql_1

powershell -command "Out-File \"$env:windir\System32\drivers\etc\hosts\" -inputObject ((docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_web_1) + ' navallweb1')"
powershell -command "Out-File -Append \"$env:windir\System32\drivers\etc\hosts\" -inputObject ((docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_nav_1) + ' navall_nav_1')"
powershell -command "Out-File -Append \"$env:windir\System32\drivers\etc\hosts\" -inputObject ((docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' navall_sql_1) + ' navall_sql_1')" 