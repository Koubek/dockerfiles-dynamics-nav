if ((Test-Path (Join-Path $PSScriptRoot 'SQLDB')) -eq $false) {
    New-Item -ItemType Junction -Path (Join-Path $PSScriptRoot 'SQLDB') -Value (Join-Path $PSScriptRoot '..\__content_user\SQLDB\')
}

if ((Test-Path (Join-Path $PSScriptRoot 'gMSA')) -eq $false) {
    New-Item -ItemType Junction -Path (Join-Path $PSScriptRoot 'gMSA') -Value (Join-Path $PSScriptRoot '..\__content\gMSA')
}
