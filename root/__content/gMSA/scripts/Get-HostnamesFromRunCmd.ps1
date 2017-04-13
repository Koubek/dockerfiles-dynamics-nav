<#

    PATTERN: 
        ((?<=\s+-{2}hostname\s*\s*(=\s*|(\"?|\'?)|=\s*(\"|\')*))\w+\b(?=(\"?|\'?)))?((?<=\s+-{1}h{1}\s*(=\s*|(\"?|\'?)|=\s*(\"|\')*))\w+\b(?=(\"?|\'?)))?

    POSSIBILITIES:
     --hostname test name
     --hostname "test" name
     --hostname 'test' name
     --hostname=test name
     --hostname="test" name
     --hostname='test' name
     --hostname = "test" name
     -h test name
     -h "test" name
     -h 'test' name
     -h=test name
     -h="test" name
     -h='test' name
     -h = "test" name
     -h = 'test' name

    TESTED ON:
        http://regexstorm.net/tester

#>

param (
    [Parameter(Mandatory=$true)] 
    [Object] $Content
)

$pattern = '((?<=\s+-{2}hostname\s*\s*(=\s*|(\"?|\''?)|=\s*(\"|\'')*))\w+\b(?=(\"?|\''?)))?((?<=\s+-{1}h{1}\s*(=\s*|(\"?|\''?)|=\s*(\"|\'')*))\w+\b(?=(\"?|\''?)))?'

$regex = new-object System.Text.RegularExpressions.Regex ($pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

$values = $regex.Matches($Content) | ForEach-Object { $_.Value }

return $values