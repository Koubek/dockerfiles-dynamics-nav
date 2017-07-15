param(
    [Parameter(Mandatory=$true)]
    [String]$SERVERINSTANCE
)

$currDir = Split-Path $MyInvocation.MyCommand.Definition

$process = 'msiexec.exe'
$params = " SERVERINSTANCE=" + $SERVERINSTANCE
$arguments = '/i "C:\\NAVDVD\\ServiceTier\\Microsoft Dynamics NAV Service.msi" /quiet /qn /norestart /log "C:\install\nav\LOG\installnst.log"' + $params

# Copy Missing Files
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\install\nav\ExtraDependencies' -TargetDirectory ($env:windir + '\System32')
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\NAVDVD\ServiceTier\System64Folder' -FileNames @("NavSip.dll") -TargetDirectory 'C:\Windows\SysWOW64'

$res = Start-Process -FilePath $process -ArgumentList $arguments -Wait -PassThru

while ($res.HasExited -eq $false) {
    Write-Host "Waiting for $process..."
    Start-Sleep -s 1
}

$exitCode = $res.ExitCode

# Change service startup type to Disabled (we don`t want to run main and unconfigured default instance) and stop it.
Write-Host "Trying stop and disable the default instance. Please, be patient, this may take a while." -ForegroundColor Green
$navSvc = Get-Service '*MicrosoftDynamicsNavServer*' 
Set-Service $navSvc.Name -StartupType Disabled
Stop-Service $navSvc.Name

# Install languages
& (Join-Path $currDir Install-Languages.ps1)