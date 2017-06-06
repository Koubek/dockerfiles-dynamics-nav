param(
    [Parameter(Mandatory=$true)]
    [String]$MsiFullPath
)

$process = 'msiexec.exe'
$logPath = 'C:\install\content\LOG'
$msiFileBaseName = [io.path]::GetFileNameWithoutExtension($MsiFullPath)

if ((Test-Path $logPath) -eq $false)
{
    New-Item -Path $logPath -ItemType Directory
}

$arguments = '/i "' + $MsiFullPath + '" /quiet /qn /norestart /log "' + $logPath + '\Install_' + $msiFileBaseName + '.log"'

$res = Start-Process -FilePath $process -ArgumentList $arguments -Wait -PassThru

while ($res.HasExited -eq $false) {
    Write-Host "Waiting for $process..."
    Start-Sleep -s 1
}

Write-Host "EXIT CODE:" $res.ExitCode

$exitCode = $res.ExitCode