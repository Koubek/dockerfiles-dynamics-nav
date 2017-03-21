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

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Install NAV prerequisites (or at least pretend to), NAV Server and NAV default instance (will be stopped and disabled).
RUN regedit /s c:\install\content\scripts\WIF.reg
RUN regedit /s c:\install\content\scripts\WIF64.reg
RUN powershell Import-Module c:\install\content\DynamicsNavDvd\NavInstallationTools.psm1 -Force; \
    Install-NAVComponent -ConfigFile c:\install\content\scripts\Install-NavComponentConfig.xml

# Expose the default NAV ports.
EXPOSE 7045 7046 7047 7048 7049

CMD powershell c:\install\content\Scripts\Run-NavService-Sql.ps1 \
    -SERVERINSTANCE %nav_instance% \
    -DBSERVER %sql_server% \
    -DBNAME %sql_db% \
    -DBUSER %sql_user% \
    -DBUSERPWD %sql_pwd% \
    -NAVUSER %nav_user% \
    -NAVUSERPWD %nav_user_pwd% \
    -IMPORTCRONUSLIC %import_cronus_license% \
    -RECONFIGUREEXISTINGINSTANCE %config_instance%
