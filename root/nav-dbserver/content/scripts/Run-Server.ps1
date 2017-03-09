param(
    [Parameter(Mandatory=$true)]
    [String]$DbFullPath,

    [Parameter(Mandatory=$false)]
    [String]$ServerName = 'SERVER1',

    [Parameter(Mandatory=$false)]
    [String]$PortPro = '2498/tcp',

    [Parameter(Mandatory=$false)]
    [String]$LicenseFile,

    [Parameter(Mandatory=$false)]
    [ValidateSet("true", "false")]
    [String]$DeleteProvidedLicense="false",

    [Parameter(Mandatory=$false)]
    [String]$CacheSize="100000",

    [Parameter(Mandatory=$false)]
    [ValidateSet("yes", "no")]
    [String]$UseCommitCache="no"
)

$currDir = Split-Path $MyInvocation.MyCommand.Definition
$serverExe = 'SERVER.exe'
$serverLicenseName = 'FIN.flf'

Get-Process -ProcessName SERVER | Stop-Process -Force

$serverPath = Get-ChildItem -Path (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Dynamics NAV') -Filter $serverExe -Recurse
if ($serverPath -eq $null) 
{
    Write-Error "Cannot find Microsoft Dynamics NAV server in the habitual folder. Trying to widen the search directory..."
    
    $serverPath = Get-ChildItem -Path ${env:ProgramFiles(x86)} -Filter $serverExe -Recurse

    if ($serverPath -eq $null) 
    {
        throw "Cannot find Microsoft Dynamics NAV server."
    }
    else 
    {
        Write-Verbose "$serverExe has been found in $($serverPath.DirectoryName)"
    }
}
$serverFullName = $serverPath.FullName
$serverPath = $serverPath.DirectoryName


# Configure services and hosts
& (Join-Path $currDir Set-Hosts.ps1) remove $ServerName
& (Join-Path $currDir Set-Hosts.ps1) add '127.0.0.1' $ServerName

& (Join-Path $currDir Set-Services.ps1) remove $ServerName
& (Join-Path $currDir Set-Services.ps1) add $ServerName $PortPro


# License
$newLicenseProvided = (!(($LicenseFile -eq $null) -or ($LicenseFile -eq '')))
if ($newLicenseProvided -eq $true)
{
    $newLicenseProvided = Test-Path $LicenseFile
    if ($newLicenseProvided -eq $false)
    {
        Write-Verbose "Provided license file $LicenseFile does not exist or cannot be accessed. Going to check the server directory..."
    }
}
$serverLicenseFullName = (Join-Path $serverPath $serverLicenseName)
$serverLicenseExists = Get-ChildItem -Path $serverPath -Filter $serverLicenseName
if (($newLicenseProvided -eq $false) -and ($serverLicenseExists -eq $false))
{
    throw "There is no $serverLicenseName in the $serverPath folder and you haven`t provided any existing license file."
}
if ($newLicenseProvided)
{
    Copy-Item $LicenseFile $serverLicenseFullName -Force
    Write-Verbose "The license file $LicenseFile has been successfully uploaded as a $serverLicenseFullName"
}
if (($newLicenseProvided -eq $true) -and ($DeleteProvidedLicense -eq $true))
{
    try
    {
        Remove-Item $LicenseFile
    }
    catch
    {
        Write-Error "Cannot delete provided license file. Please, delete it by yourself. Continue..."
    }
}

# Start NAV
$process = """$serverFullName"""
$arguments = 'SERVERNAME=' + $ServerName + ',NETTYPE=tcp,DATABASE=' + $DbFullPath + ',cache=' + $CacheSize + ',COMMITCACHE=' + $UseCommitCache
$cmd = $process + ' ' + $arguments

Write-Host "Starting NAV server..."


try 
{
    cmd.exe /C $cmd
}
catch 
{
    Write-Error "NAV Server error: " $_.Exception.Message -ForegroundColor Red
}

Write-Host 'Exiting NAV server'