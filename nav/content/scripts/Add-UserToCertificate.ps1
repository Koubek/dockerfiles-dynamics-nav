param(
    [string]$userName,
    [string]$permission,
    [string]$certStoreLocation,
    [string]$certThumbprint
);
# check if certificate is already installed
$certificateInstalled = Get-ChildItem $certStoreLocation | Where thumbprint -eq $certThumbprint

# download & install only if certificate is not already installed on machine
if ($certificateInstalled -eq $null)
{
    $message="Certificate with thumbprint:"+$certThumbprint+" does not exist at "+$certStoreLocation
    Write-Host $message -ForegroundColor Red
    exit 1;
}else
{
    try
    {
        $rule = new-object security.accesscontrol.filesystemaccessrule $userName, $permission, allow
        $root = "c:\programdata\microsoft\crypto\rsa\machinekeys"
        $l = ls $certStoreLocation
        $l = $l |? {$_.thumbprint -like $certThumbprint}
        $l |%{
            $keyname = $_.privatekey.cspkeycontainerinfo.uniquekeycontainername
            $p = [io.path]::combine($root, $keyname)
            if ([io.file]::exists($p))
            {
                $acl = get-acl -path $p
                $acl.addaccessrule($rule)
                echo $p
                set-acl $p $acl
            }
        }
    }
    catch
    {
        Write-Host "Caught an exception:" -ForegroundColor Red
        Write-Host "$($_.Exception)" -ForegroundColor Red
        exit 1;
    }
}

exit $LASTEXITCODE