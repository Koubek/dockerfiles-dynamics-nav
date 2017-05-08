# Build NAV imaegs.
Push-Location
try {
    Set-Location (Join-Path $PSScriptRoot 'nav')
    . .\_rebuild.ps1
} catch {
    Write-Error $_.Exception.Message
} finally {
    Pop-Location
}

# Build SQL image, required in caso of docker-compose based solution.
Push-Location
try {
    Set-Location (Join-Path $PSScriptRoot 'sql')
    . .\_rebuild.ps1
} catch {
    Write-Error $_.Exception.Message
} finally {
    Pop-Location
}