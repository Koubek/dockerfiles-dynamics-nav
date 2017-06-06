param(
    [Parameter(Mandatory=$true)]
    [String]$NAVSERVER,
    [Parameter(Mandatory=$true)]
    [String]$NAVINSTANCE,
    [Parameter(Mandatory=$true)]
    [String]$NAVCLIENTPORT,
    [Parameter(Mandatory=$true)]
    [String]$NAVWEBINSTANCE
)

##############################################################################
# THIS IS IMPROVED TESTING VERSION FOR TESTING WHICH SEEMS TO BE WORKING NOW #
##############################################################################

#Copy-Item 'C:\scripts\_SHARE\WebServerInstance.ps1' 'C:\install\content\DynamicsNavDvd\WebClient\Microsoft Dynamics NAV\100\Web Client\bin\'
#& 'C:\install\content\scripts\Install-Msi.ps1' -MsiFullPath 'C:\install\content\DynamicsNavDvd\WebClient\Microsoft Dynamics NAV Web Client.msi'
# 0ED65CB18D285E4EF3975AE2FCB55E693549709B

$certPath = 'C:\install\content\navcert.pfx'
$thumbprint = (Get-PfxCertificate -FilePath $certPath).Thumbprint
$certStoreLocation = 'Cert:\LocalMachine\Root'

$navAdminToolFile = Get-ChildItem -Path $env:ProgramFiles -Filter NavAdminTool.ps1 -Recurse
$navAdminToolFullName = $navAdminToolFile.FullName

$verbosePreference = "SilentlyContinue"
& $navAdminToolFullName
$verbosePreference = "Continue"

$instance = Get-NAVWebServerInstance $NAVWEBINSTANCE
if (($instance | Measure-Object).Count -lt 1) {

  New-NAVWebServerInstance -ClientServicesCredentialType NavUserPassword -ClientServicesPort $NAVCLIENTPORT `
    -DnsIdentity NAVSERVER -Server $NAVSERVER -ServerInstance $NAVINSTANCE -WebServerInstance $NAVWEBINSTANCE -Verbose

  Import-PfxCertificate $certPath -CertStoreLocation $certStoreLocation -Verbose

  $defaultNavWebSite = Get-Website '*Microsoft Dynamics NAV*Web Client*'
  if (($defaultNavWebSite | Measure-Object).Count -eq 0) {
    throw "Default Microsoft Dynamics NAV Web Client web site does not exist."
  }

  # TO-DO: Obtain $websitename dynamically.
  $defaultNavWebSite = $defaultNavWebSite | Select-Object -First 1
  $websitename = $defaultNavWebSite.Name
  New-WebBinding -Name $websitename -IPAddress * -Port 443 -Protocol https -Verbose
  $certificate = Get-Item ($certStoreLocation + '\' + $thumbprint)
  $certificate | New-Item "IIS:\SSLBindings\0.0.0.0!443" -Verbose

}

$lastCheck = (Get-Date).AddSeconds(-2)

Get-NetIPAddress | Format-Table
Write-Verbose "NAV Web Server instance should be running..."

Start-Process "C:\\install\\content\\bin\\ServiceMonitor.exe" -ArgumentList "w3svc" -Wait

Write-Verbose "w3svc has been stopped, exiting..."