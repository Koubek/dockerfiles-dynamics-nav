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
    [boolean]$RECONFIGUREEXISTINGINSTANCE=$false
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
if ($navInstance) {
    $instanceExist = $true
} else {
    $instanceExist = $false
}

if (!$instanceExist) {    
    # Create new instance (to be able give it custom name during the runtime).
    Write-Host "Adding new instance"

    $navInstance = New-NAVServerInstance -ServerInstance $SERVERINSTANCE -DatabaseServer $DBSERVER -DatabaseName $DBNAME -ClientServicesCredentialType NavUserPassword `
        -ManagementServicesPort 7045 -ClientServicesPort 7046 -SOAPServicesPort 7047 -ODataServicesPort 7048 -Verbose

    $navSvc = Get-Service $navInstance.ServerInstance

} else {
    Write-Host "Instance" $SERVERINSTANCE "already exists"

    $navSvc = Get-Service $navInstance.ServerInstance

    if ($navSvc.StartType -eq 'Disabled') {
        Write-Host "Changing StartType of the existing instance"
        Set-Service $navSvc.Name -StartupType Automatic
    }
}

if ((!$instanceExist) -or ($RECONFIGUREEXISTINGINSTANCE)) {
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