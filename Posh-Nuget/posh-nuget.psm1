
function init-poshnuget()
{
    $script:nugetPath = (get-module Posh-Nuget | select Path) -replace "posh-nuget.psm1","nuget.exe" -replace "@{Path=","" -replace "}",""
}

function Get-NugetHelp([string]$details = "")
{
    init-poshnuget
    . $script:nugetPath help $details    
}

function Invoke-NugetCommand([string]$details = "")
{
    write-host "$details"
    
    init-poshnuget
    $detailsArray = $details -split " "
    . $script:nugetPath @detailsArray    
}

Export-ModuleMember -Function Get-NugetHelp
Export-ModuleMember -Function Invoke-NugetCommand