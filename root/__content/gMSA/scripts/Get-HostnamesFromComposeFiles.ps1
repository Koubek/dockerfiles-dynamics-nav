<#

    PATTERN:
        (?<=\bhostname\:\s*(\"?|\'?))\w+\b(?=(\"?|\'?))

    POSSIBILITIES:
        hostname: "test"
        hostname: 'test'
        hostname: test
        hostname:"test"
        hostname:'test'
        hostname:test        

    TESTED ON:
        http://regexstorm.net/tester

#>

param (
    [Parameter(Mandatory=$true)] 
    [Object] $Content
)

$pattern = '(?<=\bhostname\:\s*(\"?|\''?))\w+\b(?=(\"?|\''?))'

$regex = new-object System.Text.RegularExpressions.Regex ($pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

$values = $regex.Matches($Content) | ForEach-Object { $_.Value }

return $values