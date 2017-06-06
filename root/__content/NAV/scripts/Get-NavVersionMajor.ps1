param (
    [Parameter(Mandatory=$false)]
    [string]$SearchPath = '..\DynamicsNavDvd\'
)

$currDir = Split-Path $MyInvocation.MyCommand.Definition

if ([System.IO.Path]::IsPathRooted($SearchPath) -eq $false) {
    $SearchPath = Join-Path $currDir $SearchPath
}

$navVersion = Get-ChildItem -Path $SearchPath -Filter setup.exe | Select-Object -First 1 | ForEach-Object { $_.VersionInfo.FileMajorPart }

if (!$navVersion) {
   $navVersion = '[ERROR -> Missing NAV DVD]'
}

return $navVersion;