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
    [String]$DBUSERPWD,
    [Parameter(Mandatory=$true)]
    [String]$NAVUSER,
    [Parameter(Mandatory=$true)]
    [String]$NAVUSERPWD,
    [Parameter(Mandatory=$true)]
    [String]$IMPORTCRONUSLIC
)

# Setup Environment
$currDir = Split-Path $MyInvocation.MyCommand.Definition
$crtLocation = 'cert:\LocalMachine\My'
$verbosePreference = "Continue"

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

try {
    # Start NAV Service
    Set-NAVServerInstance $SERVERINSTANCE -Start
    Write-Verbose "Started NAV Server."

    # Create user if it is not there yet
    if ((Get-NAVServerUser -ServerInstance $SERVERINSTANCE | Where-Object { $_.UserName -eq $NAVUSER}) -eq $null) { 
        $password = ConvertTo-SecureString $NAVUSERPWD -AsPlainText -Force
        New-NAVServerUser -UserName $NAVUSER -Password $password -ServerInstance $SERVERINSTANCE
        New-NavServerUserPermissionSet -UserName $NAVUSER -ServerInstance $SERVERINSTANCE -PermissionSetId SUPER
    }

    # Import Cronus license if requested
    if ($IMPORTCRONUSLIC -eq 'true') {
        Import-NAVServerLicense -LicenseFile 'C:\install\content\DynamicsNavDvd\SQLDemoDatabase\CommonAppData\Microsoft\Microsoft Dynamics NAV\100\Database\Cronus.flf' -Database NavDatabase -ServerInstance $SERVERINSTANCE
    }

    while ($true) 
     {  
         Start-Sleep -Seconds 3600 
     } 
}
catch {
    Write-Host "NAV Server error: " $_.Exception.Message -ForegroundColor Red
    return
}