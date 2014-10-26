function Install-AzureStorageModule()
{    
    $azureStoragePath = (get-module Posh-AzureStorage | select Path) -replace "Posh-AzureStorage.psm1","" -replace "@{Path=","" -replace "}",""
    Invoke-NugetCommand "install WindowsAzure.Storage -Version 2.1.0.4 -OutputDirectory $azureStoragePath"
}

function AzureStorageModule-Init()
{
    $azureStoragePath = (get-module Posh-AzureStorage | select Path) -replace "Posh-AzureStorage.psm1","" -replace "@{Path=","" -replace "}",""

    if ($script:loadedAssemblies -notcontains "Microsoft.WindowsAzure.Storage") 
    {
        write-host "Loading"

        $a = [System.Reflection.Assembly]::LoadFile("$azureStoragePath\WindowsAzure.Storage.2.1.0.4\lib\net40\Microsoft.WindowsAzure.Storage.dll")
        $script:loadedAssemblies = @("Microsoft.WindowsAzure.Storage")
    }
}

#
#   Get-AzureCloudStorageAccount -connectionString "UseDevelopmentStorage=true"
#
function Get-AzureCloudStorageAccount([string]$connectionString)
{
    [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($connectionString)
}

function Get-AzureQueueList()
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  ConfirmImpact='Medium')]


    Param
    (

        [Parameter(ParameterSetName='Parameter Set 1', 
                   Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Microsoft.WindowsAzure.Storage.CloudStorageAccount]
        $cloudStorageAccount,

        [Parameter(ParameterSetName='Another Parameter Set', 
                   Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]
        $connectionString
    )

    AzureStorageModule-Init

    if ($connectionString -ne $null)
    {
        $cloudStorageAccount = Get-AzureCloudStorageAccount $connectionString
    }

    $cloudQueueClient = $cloudStorageAccount.CreateCloudQueueClient();

    $cloudQueueClient.ListQueues()

}

#function Get-AzureTableStorageData()
#{
#
#}

Export-ModuleMember -Function Install-AzureStorageModule
Export-ModuleMember -Function Get-AzureCloudStorageAccount
Export-ModuleMember -Function Get-AzureQueueList

