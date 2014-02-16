<#
.Synopsis
This increments the third component of a four part build string.

.DESCRIPTION
This increments the third component of a four part build string.
1.0.0.0 becomes 1.0.1.0
We use the fourth for patching
#>
function Invoke-IncrementBuildNumber([string]$filename)
{
    $data = Get-Content $filename
    $m = $data | select-string "(?<fullname>[0-9]*\.[0-9]*\.(?<name>[0-9]*)\.[0-9])"
    [int]$build = $m.Matches[0].Groups["name"].Value
    $prevnum = $m.Matches[0].Groups["fullname"].Value
    $parts = $prevnum.Split(".")
    $parts[2] = ($build + 1).ToString()
    $newnum = $parts -join "."
    Set-Content -Path $filename -Value $data.Replace($prevnum, $newnum)
}


