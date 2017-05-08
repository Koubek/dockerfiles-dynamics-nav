$currDir = Split-Path $MyInvocation.MyCommand.Definition
$srvFileName = 'SERVER.exe'
$searchIn = Join-Path $currDir '..\Server\'

$navVersion = Get-ChildItem -Path $searchIn -Filter $srvFileName -Recurse | Select-Object -First 1 | ForEach-Object { $_.VersionInfo.ProductVersion }

if (!$navVersion) {
   throw '[ERROR -> Probably missing MS Dynamics NAV Database Server installation content. Check this path: ' + $searchIn + ' ]'
}

return $navVersion;