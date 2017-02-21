del __imageversion.txt
powershell .\_Get-NavVersion.ps1 > __imageversion.txt

set /p host=<..\__privatereponame.txt
set /p NavVersion=<__imageversion.txt
set /p ImageName=<__imagename.txt

set ImageName=%ImageName%:%NavVersion%
set ContainerName=%ImageName::=_%