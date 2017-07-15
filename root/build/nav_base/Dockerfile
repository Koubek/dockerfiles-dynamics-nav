FROM microsoft/mssql-server-windows-developer:latest

LABEL maintainer "Jakub Vanak, Tobias Fenster"

# DOCKER VARS - SQL
ENV run_sql "true"
ENV sa_password _
ENV attach_dbs "[]"
ENV restore_dbs "[]"
ENV base_db_folder _
ENV use_hostname_folder "false"
ENV ACCEPT_EULA _

# DOCKER VARS - NAV
ENV run_nav "true"
ENV nav_instance "DynamicsNAV"
ENV sql_server _
ENV sql_db _
ENV sql_user _
ENV sql_pwd _
ENV nav_user _
ENV nav_user_pwd _
ENV import_cronus_license false
ENV config_instance false

# DOCKER VARS - NAV WEB
ENV run_web "true"
ENV nav_server _
ENV nav_instance _
ENV nav_client_port _
ENV nav_web_instance NAVWEB

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Temporary workaround for Windows DNS client weirdness.
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

COPY content_win "c:/install/win"

RUN DISM /Online /Add-Package /PackagePath:c:\install\win\microsoft-windows-netfx3-ondemand-package.cab; \
    Remove-Item c:\install\win\microsoft-windows-netfx3-ondemand-package.cab -Force

# INSTALL IIS + RELATED FEATURES
RUN Install-WindowsFeature Web-Server,web-AppInit,web-Asp-Net45,web-Windows-Auth,web-Dyn-Compression

COPY content_nav "c:/install/nav"
COPY content_sql "c:/install/sql"
