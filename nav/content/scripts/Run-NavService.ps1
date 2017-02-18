param(
    [Parameter(Mandatory=$true)]
    [String]$SERVERINSTANCE,
    [Parameter(Mandatory=$true)]
    [String]$DBSERVER,
    [Parameter(Mandatory=$true)]
    [String]$DBNAME,
    [Parameter(Mandatory=$true)]
    [String]$DBUSER,
    [Parameter(Mandatory=$true)]
    [String]$DBUSERPWD
)

# Setup Environment
$currDir = Split-Path $MyInvocation.MyCommand.Definition
$crtLocation = 'cert:\LocalMachine\My'
$verbosePreference = "Continue"
$filesToCopy = @("Microsoft.IdentityModel.dll", "Microsoft.ReportViewer.Common.dll", "Microsoft.ReportViewer.DataVisualization.dll", "Microsoft.ReportViewer.ProcessingObjectModel.dll", `
    "Microsoft.ReportViewer.WinForms.dll", "Microsoft.SqlServer.Types.dll")

$navAdminToolFile = Get-ChildItem -Path $env:ProgramFiles -Filter NavAdminTool.ps1 -Recurse
$navAdminToolFullName = $navAdminToolFile.FullName
& $navAdminToolFullName

$navServiceExeFile = Get-ChildItem -Path $env:ProgramFiles -Filter Microsoft.Dynamics.Nav.Server.exe -Recurse
$navServiceExeFileDir = $navServiceExeFile.DirectoryName

$password = ConvertTo-SecureString $DBUSERPWD -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DBUSER, $password
$crt = Import-PfxCertificate c:\install\content\navcert.pfx $crtLocation
$crtId = ($crtLocation + $crt.Thumbprint)
$certThumbprint = $crt.Thumbprint

# Create new instance (to be able give it custom name during the runtime).
New-NAVServerInstance -ServerInstance $SERVERINSTANCE -DatabaseServer $DBSERVER -DatabaseName $DBNAME -ClientServicesCredentialType NavUserPassword `
    -ManagementServicesPort 7045 -ClientServicesPort 7046 -SOAPServicesPort 7047 -ODataServicesPort 7048 `
    -Verbose

New-NAVEncryptionKey -KeyPath "c:\install\content\nav.key" -Password $password -Verbose
Import-NAVEncryptionKey $SERVERINSTANCE -KeyPath "c:\install\content\nav.key" -Password $password -ApplicationDatabaseServer $DBSERVER `
       -ApplicationDatabaseCredentials $cred -ApplicationDatabaseName $DBNAME -Force -Verbose
Set-NAVServerConfiguration -DatabaseCredentials $cred -ServerInstance $SERVERINSTANCE -Force -Verbose

Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ServicesCertificateThumbprint -KeyValue $certThumbprint
Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ServicesCertificateValidationEnabled -KeyValue false
Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ClientServicesCredentialType -KeyValue NavUserPassword

# Certificate permssions
& (Join-Path $currDir Add-UserToCertificate.ps1) -userName 'NT AUTHORITY\NETWORK SERVICE' -permission read -certStoreLocation $crtLocation -certThumbprint $certThumbprint

# Copy Missing Files
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\install\content' -FileNames $filesToCopy -TargetDirectory $navServiceExeFileDir

try {
    # Start NAV Service
    Set-NAVServerInstance $SERVERINSTANCE -Start
    Write-Verbose "Started NAV Server."

    while ($true)
    { 
        Start-Sleep -Seconds 3600
    }
}
catch {
    Write-Host "NAV Server error: " $_.Exception.Message -ForegroundColor Red
    return
}