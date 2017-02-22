FROM microsoft/dotnet-framework:3.5

MAINTAINER Jakub Vanak

ENV chocolateyUseWindowsCompression false
# Docker run variables to create and configure new instance.
ENV nav_instance "DynamicsNAV"
ENV sql_server _
ENV sql_db _
ENV sql_user _
ENV sql_pwd _
ENV nav_user _
ENV nav_user_pwd _
ENV import_cronus_license false
ENV config_instance $False

# Temporary workaround for Windows DNS client weirdness.
RUN powershell Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

# Add Windows Features
RUN powershell -Command Install-WindowsFeature Web-Server; \
    powershell -Command Install-WindowsFeature NET-Framework-45-ASPNET; \
    powershell -Command Install-WindowsFeature Web-Asp-Net45; \
    powershell -Command Install-WindowsFeature Web-Filtering; \
    powershell -Command Install-WindowsFeature Web-CGI; \
    powershell -Command Install-WindowsFeature Web-ISAPI-Ext; \
    powershell -Command Install-WindowsFeature Web-ISAPI-Filter; \
    powershell -Command Install-WindowsFeature Web-Mgmt-Tools -IncludeAllSubFeature -IncludeManagementTools; \
    powershell -Command Install-WindowsFeature Web-Net-Ext; \
    powershell -Command Install-WindowsFeature Web-Net-Ext45; \
    powershell -Command Install-WindowsFeature Web-Windows-Auth;

# Install Chocolately client and prerequisite packages.
RUN powershell iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature enable -n allowGlobalConfirmation; \
    choco install microsoft-build-tools

RUN powershell choco install vcredist2010; \
    choco install vcredist2013;

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Install NAV prerequisites and NAV default instance (will be stopped and disabled).
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft Report Viewer\SQLSysClrTypes.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft SQL Server Management Objects\SQLSysClrTypes.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft SQL Server Management Objects\SharedManagementObjects.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft Report Viewer\ReportViewer.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft SQL Server\ReportBuilder3.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft SQL Server\sqlncli64.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\IIS URL Rewrite Module\rewrite_2.0_rtw_x64.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-ServiceTier.ps1 -SERVERINSTANCE "DynamicsNAV"

# Expose the default NAV ports.
EXPOSE 80 7045 7046 7047 7048

CMD powershell c:\install\content\Scripts\Run-NavService.ps1 \
    -SERVERINSTANCE %nav_instance% \
    -DBSERVER %sql_server% \
    -DBNAME %sql_db% \
    -DBUSER %sql_user% \
    -DBUSERPWD %sql_pwd% \
    -NAVUSER %nav_user% \
    -NAVUSERPWD %nav_user_pwd% \
    -IMPORTCRONUSLIC %import_cronus_license% \
    -RECONFIGUREEXISTINGINSTANCE %config_instance%
