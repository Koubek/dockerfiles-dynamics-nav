mkdir %~dp0\content
mklink /J %~dp0\content\scripts %~dp0\..\__content\SQL\scripts
mklink /J %~dp0\SQLDB %~dp0\..\__content\SQL\DB