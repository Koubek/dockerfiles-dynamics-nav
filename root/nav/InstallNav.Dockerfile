ARG NAV_VERSION
FROM navdvd:$NAV_VERSION

LABEL maintainer "Jakub Vanak, Tobias Fenster"

ENV nav_instance "DynamicsNAV"
ENV sql_server _
ENV sql_db _
ENV sql_user _
ENV sql_pwd _
ENV nav_user _
ENV nav_user_pwd _
ENV import_cronus_license false
ENV config_instance false

COPY content "c:/install/content"
WORKDIR C:\\install\\content

# Add missing registry to be able run main setup.exe (to cheat prerequisite checks).
RUN powershell c:\install\content\Scripts\Add-MissingRegistry.ps1; \
    # Install NAV prerequisites (or at least pretend to), NAV Server and NAV default instance (will be stopped and disabled).
    Import-Module c:\install\content\DynamicsNavDvd\NavInstallationTools.psm1 -Force; \
    Install-NAVComponent -ConfigFile c:\install\content\configs\Install-NavComponentConfig.xml;

# To be able load all installed NAV modules using Import-NavModulesGlobally
RUN powershell c:\install\content\Scripts\Update-PSProfile.ps1

# Expose the default NAV ports.
EXPOSE 7045-7049