FROM microsoft/mssql-server-2016-express-windows

ENV sa_password _
ENV attach_dbs "[]"
ENV restore_dbs "[]"

COPY SQL\scripts "c:/install/content/scripts"

CMD powershell.exe c:\install\content\scripts\start.ps1 -sa_password %sa_password% -restore_dbs \"%restore_dbs%\" -Verbose