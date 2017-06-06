#
# Powershell script for adding/removing/showing entries to the services file.
#

$file = "C:\Windows\System32\drivers\etc\services"

function add-service([string]$filename, [string]$servicename, [string]$protoport) {
	remove-service $filename $servicename
	$servicename + "`t`t" + $protoport | Out-File -encoding ASCII -append $filename
}

function remove-service([string]$filename, [string]$servicename) {
	$c = Get-Content $filename
	$newLines = @()
	
	foreach ($line in $c) {
		$bits = [regex]::Split($line, "\t+")
		if (($bits.count -eq 2) -or ($bits.count -eq 3) -or ($bits.count -eq 4)) {
			if ($bits[0] -ne $servicename) {
				$newLines += $line
			}
		} else {
			$newLines += $line
		}
	}
	
	# Write file
	Clear-Content $filename
	foreach ($line in $newLines) {
		$line | Out-File -encoding ASCII -append $filename
	}
}

function print-services([string]$filename) {
	$c = Get-Content $filename
	
	foreach ($line in $c) {
		$bits = [regex]::Split($line, "\t+")
		#if ($bits.count -ge 2) {
			Write-Host $bits[0] `t`t $bits[1]
		#}
	}
}

try {
	if ($args[0] -eq "add") {
	
		if ($args.count -lt 3) {
			throw "Not enough arguments for add."
		} else {
			add-service $file $args[1] $args[2]
		}
		
	} elseif ($args[0] -eq "remove") {
	
		if ($args.count -lt 2) {
			throw "Not enough arguments for remove."
		} else {
			remove-service $file $args[1]
		}
		
	} elseif ($args[0] -eq "show") {
		print-services $file
	} else {
		throw "Invalid operation '" + $args[0] + "' - must be one of 'add', 'remove', 'show'."
	}
} catch  {
	Write-Host $error[0]
	Write-Host "`nUsage: service add <servicename>	<protoport> `n       service remove <servicename>	`n       services show"
}