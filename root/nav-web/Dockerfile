FROM microsoft/dotnet-framework:3.5

MAINTAINER Jakub Vanak

ENV chocolateyUseWindowsCompression false
# Docker run variables to create and configure new instance.
ENV nav_server _
ENV nav_instance _
ENV nav_client_port _
ENV nav_web_instance NAVWEB

# Temporary workaround for Windows DNS client weirdness.
RUN powershell Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Add missing registry to be able run main setup.exe (to cheat prerequisite checks).
RUN powershell c:\install\content\Scripts\Add-MissingRegistry.ps1

# Add IIS and related features.
RUN powershell c:\install\content\Scripts\Install-IIS.ps1

# Install NAV prerequisites (or at least pretend to), NAV Server and NAV default instance (will be stopped and disabled).
RUN powershell Start-Process -Wait -FilePath 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft Visual Studio 2010 Tools For Office Redist\vstor_redist.exe' -ArgumentList "/qs", "/q"
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\IIS URL Rewrite Module\rewrite_2.0_rtw_x64.msi'

RUN powershell Import-Module c:\install\content\DynamicsNavDvd\NavInstallationTools.psm1 -Force; \
    Install-NAVComponent -ConfigFile c:\install\content\configs\Install-NavComponentConfig-web.xml

# Expose the default IIS ports.
EXPOSE 80 443

CMD powershell c:\install\content\Scripts\New-WebInstance.ps1 \
    -NAVSERVER %nav_server% \ 
    -NAVINSTANCE %nav_instance% \
    -NAVCLIENTPORT %nav_client_port% \
    -NAVWEBINSTANCE %nav_web_instance%