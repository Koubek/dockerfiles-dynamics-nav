# TO-DO: Assign a version tag to reflect at least the current SQL image version.
if (Test-Path (Join-Path $PSScriptRoot '__imageversion.sql.txt'))
{
    Remove-Item (Join-Path $PSScriptRoot '__imageversion.sql.txt')
}
'latest' > (Join-Path $PSScriptRoot '__imageversion.sql.txt')

$repo = Get-Content (Join-Path $PSScriptRoot '__privatereponame.txt')
Write-Verbose "REPO: $repo"
$sqlImageName = Get-Content (Join-Path $PSScriptRoot '__imagename.sql.txt')
Write-Verbose "SQL IMAGE NAME: $sqlImageName"
$sqlVersion = Get-Content (Join-Path $PSScriptRoot '__imageversion.sql.txt')
Write-Verbose "SQL VERSION: $sqlVersion"

$sqlImageName = $sqlImageName + ':' + $sqlVersion

$env:repo = $repo
$env:sqlImageName = $sqlImageName