. '.\_createlinks.ps1'

$content = (Get-Item _run.detached.bat | Get-Content)
$hosts = . .\gMSA\scripts\Get-HostnamesFromRunCmd.ps1 $content
. .\gMSA\scripts\Create-gMSA.ps1 $hosts