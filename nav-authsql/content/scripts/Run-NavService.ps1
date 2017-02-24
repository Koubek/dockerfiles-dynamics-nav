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
    [String]$IMPORTCRONUSLIC,
    [Parameter(Mandatory=$false)]
    [String]$RECONFIGUREEXISTINGINSTANCE
)

# Setup Environment
$currDir = Split-Path $MyInvocation.MyCommand.Definition
$crtLocation = 'cert:\LocalMachine\My'

$navAdminToolFile = Get-ChildItem -Path $env:ProgramFiles -Filter NavAdminTool.ps1 -Recurse
$navAdminToolFullName = $navAdminToolFile.FullName
& $navAdminToolFullName

$verbosePreference = "Continue"

$navServiceExeFile = Get-ChildItem -Path $env:ProgramFiles -Filter Microsoft.Dynamics.Nav.Server.exe -Recurse
$navServiceExeFileDir = $navServiceExeFile.DirectoryName

$password = ConvertTo-SecureString $DBUSERPWD -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DBUSER, $password
$crt = Import-PfxCertificate c:\install\content\navcert.pfx $crtLocation
$crtId = ($crtLocation + $crt.Thumbprint)
$certThumbprint = $crt.Thumbprint

$instanceExist = $false
$navInstance = Get-NAVServerInstance $SERVERINSTANCE
if ($navInstance -ne $null) {
    $instanceExist = $true
} else {
    $instanceExist = $false
}

if (!$instanceExist) {    
    # Create new instance (to be able give it custom name during the runtime).
    Write-Verbose "Adding new instance"

    $navInstance = New-NAVServerInstance -ServerInstance $SERVERINSTANCE -DatabaseServer $DBSERVER -DatabaseName $DBNAME -ClientServicesCredentialType NavUserPassword `
        -ManagementServicesPort 7045 -ClientServicesPort 7046 -SOAPServicesPort 7047 -ODataServicesPort 7048 -Verbose

    $navSvc = Get-Service $navInstance.ServerInstance

} else {
    Write-Host "Instance" $SERVERINSTANCE "already exists"

    $navSvc = Get-Service $navInstance.ServerInstance

    if ($navSvc.StartType -eq 'Disabled') {
        Write-Verbose "Changing StartType of the existing instance"
        Set-Service $navSvc.Name -StartupType Automatic
    }
}

if ((!$instanceExist) -or ($RECONFIGUREEXISTINGINSTANCE -eq 'true')) {
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName DatabaseServer -KeyValue $DBSERVER
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName DatabaseName -KeyValue $DBNAME

    New-NAVEncryptionKey -KeyPath "c:\install\content\nav.key" -Password $password -Verbose
    Import-NAVEncryptionKey $SERVERINSTANCE -KeyPath "c:\install\content\nav.key" -Password $password -ApplicationDatabaseServer $DBSERVER `
        -ApplicationDatabaseCredentials $cred -ApplicationDatabaseName $DBNAME -Force -Verbose
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName EnableSqlConnectionEncryption -KeyValue true
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName TrustSQLServerCertificate -KeyValue true
    Set-NAVServerConfiguration $SERVERINSTANCE -DatabaseCredentials $cred -Force -Verbose

    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ServicesCertificateThumbprint -KeyValue $certThumbprint
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ServicesCertificateValidationEnabled -KeyValue false
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ClientServicesCredentialType -KeyValue NavUserPassword

    # Set-NAVServerConfiguration $SERVERINSTANCE -KeyName  -KeyValue 
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName CompileBusinessApplicationAtStartup -KeyValue false

    # Certificate permssions
    & (Join-Path $currDir Add-UserToCertificate.ps1) -userName 'NT AUTHORITY\NETWORK SERVICE' -permission read -certStoreLocation $crtLocation -certThumbprint $certThumbprint
}

try {
    # Start NAV Service
    Set-NAVServerInstance $SERVERINSTANCE -Restart
    Write-Verbose "Started NAV Server."

    # Create user if it is not there yet
    if ((Get-NAVServerUser -ServerInstance $SERVERINSTANCE | Where-Object { $_.UserName -eq $NAVUSER}) -eq $null) { 
        Write-Verbose "Creating NAV user."
        $password = ConvertTo-SecureString $NAVUSERPWD -AsPlainText -Force
        New-NAVServerUser -UserName $NAVUSER -Password $password -ServerInstance $SERVERINSTANCE
        New-NavServerUserPermissionSet -UserName $NAVUSER -ServerInstance $SERVERINSTANCE -PermissionSetId SUPER
    }

    # Import Cronus license if requested
    if ($IMPORTCRONUSLIC -eq 'true') {
        Write-Verbose "Importing NAV license."
        $cronusLicenseFile = Get-ChildItem -Path 'C:\install\content\DynamicsNavDvd\SQLDemoDatabase\' -Filter 'Cronus.flf' -Recurse | Select-Object -First 1
        Import-NAVServerLicense -ServerInstance $SERVERINSTANCE -LicenseFile $cronusLicenseFile.FullName -Database NavDatabase
    }

    Get-NetIPAddress | Format-Table

    Write-Verbose "NAV Server should be running..."

    while ($true) 
     {  
         Start-Sleep -Seconds 3600 
     } 
}
catch {
    Write-Host "NAV Server error: " $_.Exception.Message -ForegroundColor Red
    return
}