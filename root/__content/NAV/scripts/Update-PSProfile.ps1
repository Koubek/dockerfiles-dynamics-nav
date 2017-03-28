if (!(Test-Path $PROFILE)) {
   New-Item -Path $PROFILE -Type File -Force
}

"# Load NAV modules globally
Import-Module c:\install\content\Scripts\Docker.NAV.ModuleManagement\Docker.NAV.ModuleManagement.psm1
" >> $PROFILE