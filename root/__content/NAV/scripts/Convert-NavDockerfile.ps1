[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]$SourceNavDockerfileFullPath,

    [Parameter(Mandatory=$true)]
    [String]$NavVersion
)

$dir = Split-Path -Path $SourceNavDockerfileFullPath
$content = Get-Content $SourceNavDockerfileFullPath -Raw
$destNavDockerfileName = Split-Path -Path $SourceNavDockerfileFullPath -Leaf -Resolve
$destNavDockerfileName = $destNavDockerfileName + '.tmp'
$destNavFilePath = Join-Path $dir $destNavDockerfileName

$pattern = '\bARG NAV_VERSION\b'
$content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, '#ARG NAV_VERSION')
$pattern = '\b\:\$NAV_VERSION\b'
$content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $(':' + $NavVersion))

Set-Content -Path $destNavFilePath -Value $content -Force

return $destNavFilePath