<#
.Synopsis
   Extracts the name and version number from a Nuget package name in the form PACKAGE.NAME.1.2.4
#>
function Parts() 
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string]
        $full
    )


    $name = ($full -split "\." | % { if( $_ -notMatch "[0-9]+") {$_} } ) -join "."
    $version = ($full -split "\." | % { if( $_ -Match "[0-9]+") {$_} } ) -join "."
    
    $result = new-object PSObject 
    $result | Add-Member -MemberType NoteProperty -Name id -Value $name 
    $result | Add-Member -MemberType NoteProperty -Name version -Value $version
  
    return $result
}




#dir -Recurse D:\dev\AzureTraining\Loggingv2\*.config

# From project file find the assemblies with explicit hint paths:

[xml]$data = get-content D:\dev\AzureTraining\Loggingv2\LoggingWorkerRole\LoggingWorkerRole.csproj
#These are the assemblies that have hint paths with exlicit numbers
$data.Project.ItemGroup.Reference.HintPath | % { $_ -split "\\" | select -Skip 2 -First 1 | Parts} | where id -NE "" | sort id




#This gets the version number
#("Microsoft.Data.Edm.5.2.0" -split "\." | % { if( $_ -Match "[0-9]+") {$_} } ) -join "."




#..\packages\Microsoft.Data.Edm.5.2.0\lib\net40\Microsoft.Data.Edm.dll
#..\packages\Microsoft.Data.OData.5.2.0\lib\net40\Microsoft.Data.OData.dll
#..\packages\Microsoft.WindowsAzure.ConfigurationManager.2.0.0.0\lib\net40\Microsoft.WindowsAzure.Configuration.dll
#..\packages\WindowsAzure.Storage.2.0.5.1\lib\net40\Microsoft.WindowsAzure.Storage.dll
#..\packages\System.Spatial.5.2.0\lib\net40\System.Spatial.dll


#These are what nuget will fetch
[xml]$data = get-content D:\dev\AzureTraining\Loggingv2\LoggingWorkerRole\packages.config
$data.packages.package 

#id                                          version                                    targetFramework                           
#--                                          -------                                    ---------------                           
#Microsoft.Data.Edm                          5.2.0                                      net45                                     
#Microsoft.Data.OData                        5.2.0                                      net45                                     
#Microsoft.WindowsAzure.ConfigurationManager 2.0.0.0                                    net45                                     
#System.Spatial                              5.2.0                                      net45                                     
#WindowsAzure.Storage                        2.0.5.1                                    net45  


#These are the redirects
[xml]$data = get-content D:\dev\AzureTraining\Loggingv2\LogViewerWebRole\web.config

$data.configuration.runtime.assemblyBinding.dependentAssembly | select @{Name="id"; Expression={$_.assemblyIdentity.Name}},
                                                                       @{Name="oldVersion"; Expression={$_.bindingRedirect.oldVersion}},
                                                                       @{Name="version"; Expression={$_.bindingRedirect.newVersion}} 

# Now we have the pieces it should be simple to build a comparison tool

<#
.Synopsis
   Identifies that a mapping is applied
.Example
   IsInRange -range "1.0.0.0-4.0.0.0" -testValue "4.0.1.0"
#>
function IsInRange([string]$range, [string]$testValue) {

    $valueVersion = [Version]::Parse($testValue)
    $lowVersion = [Version]::Parse(  ( $range -split "-" | select -first 1 ) )
    $highVersion = [Version]::Parse(  ( $range -split "-" | select -first 1 -Skip 1 ) )

    if( $value -le $lowRange) {
        return $false
    }

    if ( $value -gt $highRange) {
        return $false
    }

    return $true
}