[CmdletBinding()]
param (

)

. (Join-Path $PSScriptRoot '_createlinks.ps1')
. (Join-Path $PSScriptRoot '_presetvars.ps1')

# --hostname => Must match gMSA account name!!! Create gMSA before!!!
# --name => Optional but usefull to identify the container.
# --security-opt => Necessary to run and use WinAuth (integrate with AD). Create gMSA before!!!
# --restart => Change or remove restart policy if needed.
# --label => These flags are not necessary, update them if interested or delete them in other case.
# -e => Expose the ports.

$containerId = docker run -d --hostname=NAVSERVER --name=navserver `
    -v $PSScriptRoot\Add-ins:'C:\Program Files\Microsoft Dynamics NAV\Service\Add-ins\Docker-Share' `
    -e "sql_server=sql_ip\sql_instance" -e "sql_db=navdbname" `
    -e "import_cronus_license=false" -e "config_instance=false" `
    --expose 7045-7049 `
    --security-opt "credentialspec=file://credentialspecfile.json" `
    --restart=always `
    --label com.mycompany.container-type=navserver `
    --label com.mycompany.navserver-version=2016/2017 `
    --label com.mycompany.navserver-cu=1/2../X `
    ${repo}/${navImageNameWin}

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerId
