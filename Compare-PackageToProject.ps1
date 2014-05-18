


function Compare-PackageToProject()
{
<#
.Synopsis
Compare the contents of the packages.config with the help paths in the csproj file to see if there are differences.
Please note that some differences are to be expected.

.EXAMPLE
dir -Recurse *.Csproj  | % {Compare-PackageToProject -Verbose $_}
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=1,ValueFromPipelineByPropertyName=$True)]
        [string]$FullName
    )

    Write-Verbose $FullName

    $directory = (Get-ChildItem -Path $FullName).Directory

    [xml]$package = get-content $directory\packages.config
    $pkgdata = $package.packages.package | select @{Name="Path";Expression = {$_.Id + "." + $_.Version}}
   

    $filename = $FullName

    write-host $filename

    [xml]$project = get-content $filename
    $projdata = $project.Project.ItemGroup.Reference.HintPath | select -Unique @{Name="Project";Expression={("$_" -split "\\")[2] }}

    Compare-Object $pkgdata $projdata 
} 