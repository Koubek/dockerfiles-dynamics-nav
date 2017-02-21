param(
    [Parameter(Mandatory=$true)]
    [String]$SERVERINSTANCE
)

$filesToCopy = @("Microsoft.IdentityModel.dll", "Microsoft.ReportViewer.Common.dll", "Microsoft.ReportViewer.DataVisualization.dll", "Microsoft.ReportViewer.ProcessingObjectModel.dll", `
    "Microsoft.ReportViewer.WinForms.dll", "Microsoft.SqlServer.Types.dll")
$currDir = Split-Path $MyInvocation.MyCommand.Definition

$process = 'msiexec.exe'
$params = " SERVERINSTANCE=" + $SERVERINSTANCE
$arguments = '/i "C:\\install\\content\\DynamicsNavDvd\\ServiceTier\\Microsoft Dynamics NAV Service.msi" /quiet /qn /norestart /log "C:\\install\\content\\LOG\\installnst.log"' + $params

$res = Start-Process -FilePath $process -ArgumentList $arguments -Wait -PassThru

while ($res.HasExited -eq $false) {
    Write-Host "Waiting for $process..."
    Start-Sleep -s 1
}

# Change service startup type to Disabled (we don`t want to run main and unconfigured default instance) and stop it.
$navSvc = Get-Service '*MicrosoftDynamicsNavServer*' 
Set-Service $navSvc.Name -StartupType Disabled
Stop-Service $navSvc.Name

# Copy missing dlls
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\install\content' -FileNames $filesToCopy -TargetDirectory "c:\windows\system32"

$exitCode = $res.ExitCode