call _presetvars.navdbserver.bat

(docker run -d -v %cd%\share:c:\share --hostname=CRONUS -e "srv_name=CRONUS" -e "db_file=C:\share\database.fdb" -e "license_file=C:\share\nav_license.flf" -e "cache_size=50000" -e "use_commit_cache=yes" %host%/%ImageName%) >> cid.out
set /p cid=<cid.out
echo ID %cid%
del cid.out
powershell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' %cid%