FROM microsoft/dotnet-framework:3.5

MAINTAINER Jakub Vanak

# Docker run variables to create and configure new instance.
ENV db_file _
ENV srv_name "SERVER1"
ENV svc_port_proto '2407/tcp'
ENV license_file _
ENV delete_license 'false'
ENV cache_size '100000'
ENV use_commit_cache 'no'

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Install NAV server.
RUN powershell -executionpolicy RemoteSigned c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\Server\Microsoft Dynamics NAV Classic Database Server.msi'

# Expose the default NAV ports.
EXPOSE 2407

CMD powershell -executionpolicy RemoteSigned c:\install\content\scripts\Run-Server.ps1 \
    -DbFullPath ${env:db_file} \
    -ServerName ${env:srv_name} \
    -PortPro ${env:svc_port_proto} \
    -LicenseFile ${env:license_file} \
    -DeleteProvidedLicense ${env:delete_license} \
    -CacheSize ${env:cache_size} \
    -UseCommitCache ${env:use_commit_cache} \
    -Verbose
