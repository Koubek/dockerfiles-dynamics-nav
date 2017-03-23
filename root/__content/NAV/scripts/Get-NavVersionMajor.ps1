$currDir = Split-Path $MyInvocation.MyCommand.Definition
$navVersion = Get-ChildItem -Path (Join-Path $currDir '..\DynamicsNavDvd\') -Filter setup.exe | Select-Object -First 1 | %{ $_.VersionInfo.FileMajorPart }
if (!$navVersion) {
   $navVersion = '[ERROR -> Missing NAV DVD]'
}

return $navVersion;