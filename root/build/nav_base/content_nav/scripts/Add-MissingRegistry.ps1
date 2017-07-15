$navVersion = & (Join-Path $PSScriptRoot Get-NavVersionMajor.ps1)
$navVersion = -join ($navVersion, "0")
(Get-Content (Join-Path $PSScriptRoot ..\regs\WebComponentPrereqs.reg)).replace('[VERSION]', $navVersion) | Set-Content (Join-Path $PSScriptRoot ..\regs\WebComponentPrereqs.reg)

regedit /s (Join-Path $PSScriptRoot ..\regs\WIF.reg)
regedit /s (Join-Path $PSScriptRoot ..\regs\WIF64.reg)
regedit /s (Join-Path $PSScriptRoot ..\regs\WebComponentPrereqs.reg)
