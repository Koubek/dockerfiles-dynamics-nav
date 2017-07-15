function Get-NavDvdFolder {
    $navDvdFolder = "C:\NAVDVD"
    return $navDvdFolder
}
function Set-InstallNavComponentConfig {
    $navDvdFolder = Get-NavDvdFolder
    $installConfigFile =  Join-Path $navDvdFolder "Install-NavComponentConfig.xml"
    $installConfig = [xml](Get-Content $installConfigFile)
    $installConfig.SelectSingleNode("//Configuration/Component[@Id='WebClient']").State = "Local"
    $installConfig.SelectSingleNode("//Configuration/Component[@Id='ServiceTier']").State = "Local"
    $installConfig.SelectSingleNode("//Configuration/Component[@Id='Pagetest']").State = "Local"
    $installConfig.SelectSingleNode("//Configuration/Component[@Id='ServerManager']").State = "Local"
    $installConfig.SelectSingleNode("//Configuration/Component[@Id='RoleTailoredClient']").State = "Local"
    $installConfig.SelectSingleNode("//Configuration/Component[@Id='ClassicClient']").State = "Local"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='TargetPath']").Value = "[WIX_ProgramFilesFolder]\Microsoft Dynamics NAV"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='TargetPathX64']").Value = "[WIX_ProgramFilesX64Folder]\Microsoft Dynamics NAV"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='NavServiceServerName']").Value = "localhost"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='NavServiceInstanceName']").Value = "DynamicsNAV"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='NavServiceClientServicesPort']").Value = "7046"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='WebServiceServerPort']").Value = "7047"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='WebServiceServerEnabled']").Value = "true"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='DataServiceServerPort']").Value = "7048"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='DataServiceServerEnabled']").Value = "true"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='NavFirewallOption']").Value = "false"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='WebServerPort']").Value = "80"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='WebClientRunDemo']").Value = "true"
    $installConfig.SelectSingleNode("//Configuration/Parameter[@Id='WebClientDependencyBehavior']").Value = "Install"
    $installConfig.Save($installConfigFile)
    return $installConfigFile
}
function Install-Nav {
    $installConfigFile = Set-InstallNavComponentConfig

    $navDvdFolder = Get-NavDvdFolder
    Import-Module (Join-Path $navDvdFolder "NavInstallationTools.psm1") -Force
    Install-NAVComponent -ConfigFile $installConfigFile
}