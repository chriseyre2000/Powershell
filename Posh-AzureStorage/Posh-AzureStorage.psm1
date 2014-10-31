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
		
		$edmlib    = "$azureStoragePath\Microsoft.Data.Edm.5.2.0\lib\net40\Microsoft.Data.Edm.dll"
		$spatial   = "$azureStoragePath\System.Spatial.5.2.0\lib\net40\System.Spatial.dll"                                                 
		$odata     = "$azureStoragePath\Microsoft.Data.OData.5.2.0\lib\net40\Microsoft.Data.OData.dll"                                     
		$azurelib  = "$azureStoragePath\windowsazure.storage.2.1.0.4\lib\net40\Microsoft.WindowsAzure.Storage.dll"             

		try
		{
		  Add-Type -path "$edmlib" 
		  Add-Type -path "$spatial"
		  Add-Type -path "$odata"
		  Add-Type -path "$azurelib" 
		}
		catch
		{
			write-host $_.Exception.Message
			write-host $_.Exception.LoaderExceptions
		}    
        $script:loadedAssemblies = @("Microsoft.WindowsAzure.Storage")
    }
}

#
#   Get-AzureCloudStorageAccount -connectionString "UseDevelopmentStorage=true"
#
function Get-AzureCloudStorageAccount([string]$connectionString)
{
    AzureStorageModule-Init
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

#function Get-AzureTableList()
#{
#    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
#                  ConfirmImpact='Medium')]
#
#
#    Param
#    (
#
#        [Parameter(ParameterSetName='Parameter Set 1', 
#                   Mandatory=$true,
#                   ValueFromPipeline=$true,
#                   ValueFromPipelineByPropertyName=$true)]
#        [Microsoft.WindowsAzure.Storage.CloudStorageAccount]
#        $cloudStorageAccount,
#
#        [Parameter(ParameterSetName='Another Parameter Set', 
#                   Mandatory=$true,
#                   ValueFromPipeline=$true,
#                   ValueFromPipelineByPropertyName=$true)]
#        [String]
#        $connectionString
#    )
#
#    AzureStorageModule-Init
#
#    if ($connectionString -ne $null)
#    {
#        $cloudStorageAccount = Get-AzureCloudStorageAccount $connectionString
#    }
#
#    $cloudTableClient = $cloudStorageAccount.CreateCloudTableClient();
#    try
#    {
#        $cloudTableClient.ListTables("");
#    }
#    catch
#    {
#			write-host $_.Exception.Message
#            write-host $_.Exception.InnerException.Message    
#    }
#}

Export-ModuleMember -Function Install-AzureStorageModule
Export-ModuleMember -Function Get-AzureCloudStorageAccount
Export-ModuleMember -Function Get-AzureQueueList
#Export-ModuleMember -Function Get-AzureTableList

