ARG NAV_VERSION
FROM navinstalled:$NAV_VERSION

LABEL maintainer "Jakub Vanak, Tobias Fenster"

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
