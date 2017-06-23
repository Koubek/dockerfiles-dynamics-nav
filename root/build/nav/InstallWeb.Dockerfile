ARG NAV_VERSION
FROM navdvd:$NAV_VERSION

LABEL maintainer "Jakub Vanak, Tobias Fenster"

# Docker run variables to create and configure new instance.
ENV nav_server _
ENV nav_instance _
ENV nav_client_port _
ENV nav_web_instance NAVWEB

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Add missing registry to be able run main setup.exe (to cheat prerequisite checks).
RUN powershell c:\install\content\Scripts\Add-MissingRegistry.ps1; \
    # Set product version (convert installation config file template to the real config file).
    c:\install\content\Scripts\Convert-NavInstallConfigTmpl.ps1 c:\install\content\configs\Install-NavComponentConfig-web.tmpl.xml c:\install\content\configs\Install-NavComponentConfig-web.xml; \
    # Add IIS and related features.
    c:\install\content\Scripts\Install-IIS.ps1; \
    # Install NAV prerequisites (or at least pretend to), NAV Server and NAV default instance (will be stopped and disabled).
    Start-Process -Wait -FilePath 'C:\install\content\DynamicsNavDvd\Prerequisite Components\Microsoft Visual Studio 2010 Tools For Office Redist\vstor_redist.exe' -ArgumentList "/qs", "/q"; \
    c:\install\content\scripts\Install-Msi.ps1 'C:\install\content\DynamicsNavDvd\Prerequisite Components\IIS URL Rewrite Module\rewrite_2.0_rtw_x64.msi'

RUN powershell Import-Module c:\install\content\DynamicsNavDvd\NavInstallationTools.psm1 -Force; \
    Install-NAVComponent -ConfigFile c:\install\content\configs\Install-NavComponentConfig-web.xml

RUN powershell Remove-Item -Recurse -Force 'C:\install\content\DynamicsNavDvd'

# Expose the default IIS ports.
EXPOSE 80 443

CMD powershell c:\install\content\Scripts\New-WebInstance.ps1 \
    -NAVSERVER %nav_server% \ 
    -NAVINSTANCE %nav_instance% \
    -NAVCLIENTPORT %nav_client_port% \
    -NAVWEBINSTANCE %nav_web_instance%