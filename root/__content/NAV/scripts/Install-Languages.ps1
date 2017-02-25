$currDir = Split-Path $MyInvocation.MyCommand.Definition
$dvdPath = "C:\install\content\DynamicsNavDvd\"
$langMasterDirName = 'Installers'
$langMasterDirPath = Join-Path $dvdPath $langMasterDirName
$serviceDirName = 'Server'

if (!(Test-Path $langMasterDirPath)) {
    $langMasterDirPath
    Write-Host "There is not the master language folder '"$langMasterDirName"' so exiting the language installation process."
    return;
}

$langDirs = Get-ChildItem -Path $langMasterDirPath | Where-Object {$_.FullName -match "\b\w{2}\b"}

foreach ($dir in $langDirs) {
    Write-Host "Searching for language installer of the language" $dir.Name
    $langPath = $dir.FullName

    $serverInstallerPath =  Get-ChildItem -Path $langPath -Filter 'Server.Local.*.msi' -Recurse
    if ($serverInstallerPath) {
        Write-Host "Installing language from" $dir.Name", using installer file" $serverInstallerPath.FullName        
        & (Join-Path $currDir Install-Msi.ps1) -MsiFullPath $serverInstallerPath.FullName
        Write-Host "Language" $dir.Name "has beeen installed successfully" -ForegroundColor Green
    } else {
        Write-Host "Installer of the language" $dir.Name "probably doesn`t exist inside the folder" $langPath -ForegroundColor Red
    }
}
