#################################################################################
# THIS IS REALLY AN EXPERIMENTAL VERSION FOR TESTING WHICH IS STILL NOT WORKING #
#################################################################################

#Copy-Item 'C:\scripts\_SHARE\WebServerInstance.ps1' 'C:\install\content\DynamicsNavDvd\WebClient\Microsoft Dynamics NAV\100\Web Client\bin\'
#& 'C:\install\content\scripts\Install-Msi.ps1' -MsiFullPath 'C:\install\content\DynamicsNavDvd\WebClient\Microsoft Dynamics NAV Web Client.msi'
# 0ED65CB18D285E4EF3975AE2FCB55E693549709B

$VerbosePreference = "continue"

New-NAVWebServerInstance -ClientServicesCredentialType NavUserPassword -ClientServicesPort 7046 `
  -DnsIdentity NAVSERVER -Server NAVSERVER -ServerInstance NAVSERVICE -WebServerInstance NAV01 -Verbose

Import-PfxCertificate C:\install\content\navcert.pfx -CertStoreLocation Cert:\LocalMachine\Root -Verbose

Get-Website -Verbose
$websitename = 'Microsoft Dynamics NAV 2017 Web Client'
New-WebBinding -Name $websitename -IPAddress * -Port 443 -Protocol https -Verbose
$thumbprint = '0ED65CB18D285E4EF3975AE2FCB55E693549709B'
$certificate = Get-Item cert:\localmachine\My\$thumbprint
$certificate | New-Item "IIS:\SSLBindings\0.0.0.0!443" -Verbose