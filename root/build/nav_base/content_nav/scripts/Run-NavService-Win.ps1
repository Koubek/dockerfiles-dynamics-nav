param(
    [Parameter(Mandatory=$true)]
    [String]$SERVERINSTANCE,
    [Parameter(Mandatory=$true)]
    [String]$DBSERVER,
    [Parameter(Mandatory=$true)]
    [String]$DBNAME,
    [Parameter(Mandatory=$true)]
    [String]$IMPORTCRONUSLIC,
    [Parameter(Mandatory=$false)]
    [String]$NAVWINUSER,
    [Parameter(Mandatory=$false)]
    [String]$RECONFIGUREEXISTINGINSTANCE
)

# Setup Environment
$currDir = Split-Path $MyInvocation.MyCommand.Definition

$navAdminToolFile = Get-ChildItem -Path $env:ProgramFiles -Filter NavAdminTool.ps1 -Recurse
$navAdminToolFullName = $navAdminToolFile.FullName

$verbosePreference = "SilentlyContinue"
& $navAdminToolFullName
$verbosePreference = "Continue"

$navServiceExeFile = Get-ChildItem -Path $env:ProgramFiles -Filter Microsoft.Dynamics.Nav.Server.exe -Recurse
$navServiceExeFileDir = $navServiceExeFile.DirectoryName

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

    $navInstance = New-NAVServerInstance -ServerInstance $SERVERINSTANCE -DatabaseServer $DBSERVER -DatabaseName $DBNAME -ClientServicesCredentialType Windows `
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
    Set-NAVServerConfiguration $SERVERINSTANCE -KeyName ServicesCertificateValidationEnabled -KeyValue false
}

try {
    # Start NAV Service
    Set-NAVServerInstance $SERVERINSTANCE -Restart
    Write-Verbose "Started NAV Server."

    # Import Cronus license if requested
    if ($IMPORTCRONUSLIC -eq 'true') {
        Write-Verbose "Importing NAV license."
        $cronusLicenseFile = Get-ChildItem -Path 'C:\NAVDVD\SQLDemoDatabase\' -Filter 'Cronus.flf' -Recurse | Select-Object -First 1
        Import-NAVServerLicense -ServerInstance $SERVERINSTANCE -LicenseFile $cronusLicenseFile.FullName -Database NavDatabase
    }

    if ([System.String]::IsNullOrEmpty($NAVWINUSER) -eq $false) {
        # Create user if it is not there yet
        if ((Get-NAVServerUser -ServerInstance $SERVERINSTANCE | Where-Object { $_.UserName -eq $NAVWINUSER}) -eq $null) { 
            Write-Verbose "Creating NAV user."
            
            New-NAVServerUser -WindowsAccount $NAVWINUSER -ServerInstance $SERVERINSTANCE
            New-NavServerUserPermissionSet -WindowsAccount $NAVWINUSER -ServerInstance $SERVERINSTANCE -PermissionSetId 'SUPER'
        }
    }

    $lastCheck = (Get-Date).AddSeconds(-2)

    Get-NetIPAddress | Format-Table
    Write-Verbose "NAV Server should be running..."

    while ($true) {
        Get-EventLog -LogName Application -Source ("*" + $navInstance + "*") -After $lastCheck | Select-Object TimeGenerated, EntryType, Message
        $lastCheck = Get-Date
        Start-Sleep -Seconds 2
    } 
}
catch {
    Write-Host "NAV Server error: " $_.Exception.Message -ForegroundColor Red
    return
}