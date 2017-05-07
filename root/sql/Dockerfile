FROM microsoft/mssql-server-windows:latest

LABEL maintainer "Jakub Vanak, Tobias Fenster"

# Docker run variables to create and configure new instance.
ENV sa_password _
ENV attach_dbs "[]"
ENV restore_dbs "[]"
ENV base_db_folder _
ENV use_hostname_folder "false"
ENV ACCEPT_EULA _

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Temporary workaround for Windows DNS client weirdness.
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

COPY content "c:/install/content"
WORKDIR C:\\install\\content\\scripts

CMD .\start.ps1 -sa_password $env:sa_password -ACCEPT_EULA $env:ACCEPT_EULA \
    -attach_dbs $env:attach_dbs -restore_dbs $env:restore_dbs \
    -base_db_folder $env:base_db_folder -use_hostname_folder $env:use_hostname_folder \
    -Verbose