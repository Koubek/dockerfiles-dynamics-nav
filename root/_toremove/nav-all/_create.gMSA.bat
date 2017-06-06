call _createlinks.bat

powershell -command "$content = (Get-Item *.yml | Get-Content); $hosts = . .\gMSA\scripts\Get-HostnamesFromComposeFiles $content; . .\gMSA\scripts\Create-gMSA.ps1 $hosts"