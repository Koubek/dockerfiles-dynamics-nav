echo latest > __imageversion.txt

set /p host=<%~dp0\__privatereponame.txt
set /p Version=<__imageversion.txt
set /p ImageName=<__imagename.txt

set ImageName=%ImageName%:%Version%
set ContainerName=%ImageName::=_%