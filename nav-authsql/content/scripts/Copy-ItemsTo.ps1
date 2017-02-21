param(
    [Parameter(Mandatory=$true)]
    [String]$ParentDirectory,
    [Parameter(Mandatory=$false)]
    [string[]]$FileNames,
    [Parameter(Mandatory=$true)]
    [String]$TargetDirectory
)

if (!$FileNames) {
    $FileNames = Get-ChildItem -Path $ParentDirectory -File
}

foreach ($fileName in $FileNames) {
	try {
        Write-Host "Copying file: " $fileName
        $fullName = (Get-ChildItem -Path $ParentDirectory -Filter $fileName -Recurse).FullName
        Copy-Item -Path $fullName -Destination $TargetDirectory
        Write-Host "File: " $fileName " copied successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "Copy File Error: " $fileName " => " $_.Exception.Message -ForegroundColor Red
    }
}
