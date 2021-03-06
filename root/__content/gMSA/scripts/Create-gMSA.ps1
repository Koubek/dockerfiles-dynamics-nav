﻿param (

    [Parameter(Mandatory=$true)]
    [String[]]$hostNames,

    [Parameter(Mandatory=$false)]
    [String]$path,

    [Parameter(Mandatory=$false)]
    [String[]]$principalsAllowedToRetrieveManagedPassword = @( "DockerGMSAGroup" )

)

$currDir = $PSScriptRoot

Import-Module (Join-Path $currDir CredentialSpec.psm1)

foreach ($hostname in $hostNames) {
    $account = $null
    $dnsroot = (Get-ADDomain).DNSRoot
    $dnsHostName = $hostName + '.' + $dnsroot

    $account = Get-ADServiceAccount -Filter { cn -eq $hostName }

    if ($account -eq $null) {
        Write-Verbose "Creating ADServiceAccount..."

        if ([System.String]::IsNullOrEmpty($path) -eq $true) {
            New-ADServiceAccount -name $hostName `
                -DnsHostName $dnsHostName `
                -PrincipalsAllowedToRetrieveManagedPassword $principalsAllowedToRetrieveManagedPassword
        } else {
            New-ADServiceAccount -name $hostName `
                -DnsHostName $dnsHostName `
                -Path $path `
                -PrincipalsAllowedToRetrieveManagedPassword $principalsAllowedToRetrieveManagedPassword
        }

    } else {
        Write-Verbose "ADServiceAccount already exists."
    }

    New-CredentialSpec -Name $hostName -AccountName $hostName
}