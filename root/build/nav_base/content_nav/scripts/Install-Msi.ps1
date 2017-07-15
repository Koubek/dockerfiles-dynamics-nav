param(
    [Parameter(Mandatory=$true)]
    [String]$MsiFullPath
)

$process = 'msiexec.exe'
$msiFileBaseName = [io.path]::GetFileNameWithoutExtension($MsiFullPath)
$arguments = '/i "' + $MsiFullPath + '" /quiet /qn /norestart /log "C:\install\nav\LOG\Install_' + $msiFileBaseName + '.log"'

$res = Start-Process -FilePath $process -ArgumentList $arguments -Wait -PassThru

while ($res.HasExited -eq $false) {
    Write-Host "Waiting for $process..."
    Start-Sleep -s 1
}

Write-Host "EXIT CODE:" $res.ExitCode

$exitCode = $res.ExitCode