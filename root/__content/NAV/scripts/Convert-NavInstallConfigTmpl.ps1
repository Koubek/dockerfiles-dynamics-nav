[CmdletBinding()]
param (
    
    [Parameter(Mandatory=$true)]
    [String]$NavConfigTmplFullPath,

    [Parameter(Mandatory=$true)]
    [String]$NavConfigDestFullPath

)

$navVersion = & (Join-Path $PSScriptRoot Get-NavVersionMajor.ps1)
$navVersion = -join ($navVersion, "0")

(Get-Content $NavConfigTmplFullPath).replace('[DOCKER.NAV_VERSION]', $navVersion) | Set-Content $NavConfigDestFullPath -Force