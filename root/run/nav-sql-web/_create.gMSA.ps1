[CmdletBinding()]
param (

)

. (Join-Path $PSScriptRoot '_createlinks.ps1')

$content = (Get-Item *.yml | Get-Content)
$hosts = . .\gMSA\scripts\Get-HostnamesFromComposeFiles $content

Write-Verbose "The hosts localised in the docker-compose files: $hosts"

. .\gMSA\scripts\Create-gMSA.ps1 $hosts