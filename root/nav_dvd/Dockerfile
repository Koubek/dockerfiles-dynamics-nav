FROM microsoft/dotnet-framework:3.5

LABEL maintainer "Jakub Vanak, Tobias Fenster"

# Temporary workaround for Windows DNS client weirdness.
RUN powershell Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

COPY NAVDVD "c:/install/content/DynamicsNavDvd"
WORKDIR C:\\install\\content