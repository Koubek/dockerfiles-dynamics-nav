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
ENV config_instance false

# Temporary workaround for Windows DNS client weirdness.
RUN powershell Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

# Install Chocolately client and prerequisite packages.
RUN powershell iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature enable -n allowGlobalConfirmation; \
    choco install microsoft-build-tools

RUN powershell choco install vcredist2010; \
    choco install vcredist2013;

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Install NAV prerequisites and NAV default instance (will be stopped and disabled).
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft SQL Server Management Objects\SQLSysClrTypes.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft SQL Server Management Objects\SharedManagementObjects.msi'
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-ServiceTier.ps1 -SERVERINSTANCE "DynamicsNAV"

# Expose the default NAV ports.
EXPOSE 7045 7046 7047 7048

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
