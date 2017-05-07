# TO-DO: Assign a version tag to reflect at least the current SQL image version.
'latest' > __imageversion.txt

$repo = Get-Content (Join-Path $PSScriptRoot '__privatereponame.txt')
Write-Verbose "REPO: $repo"
$sqlImageName = Get-Content '__imagename.txt'
Write-Verbose "SQL IMAGE NAME: $sqlImageName"
$sqlVersion = Get-Content '__imageversion.txt'
Write-Verbose "SQL VERSION: $sqlVersion"

$sqlImageName = $sqlImageName + ':' + $sqlVersion

$env:repo = $repo
$env:sqlImageName = $sqlImageName