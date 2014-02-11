$codePath = "D:\dev\github\Powershell\Azure2"

$edmlib    = "$codePath\Microsoft.Data.Edm.5.2.0\lib\net40\Microsoft.Data.Edm.dll"
$spatial   = "$codePath\System.Spatial.5.2.0\lib\net40\System.Spatial.dll"                                                 
$odata     = "$codePath\Microsoft.Data.OData.5.2.0\lib\net40\Microsoft.Data.OData.dll"                                     
$azurelib  = "$codePath\windowsazure.storage.2.1.0.4\lib\net40\Microsoft.WindowsAzure.Storage.dll"             

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


function Search-AzureTableStorageV2()
{
    param(
        [string]$connectionString = "UseDevelopmentStorage=true;", 
        [string]$tableName = "WADLogsTable", 
        [string]$filterString = $null
    )

    if($filterString -eq $null)
    {
        $filterString = "PartitionKey gt '$("0" + [System.DateTime]::UtcNow.AddYears(-1).Ticks)'"
    }
    
    $storageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($connectionString)
    $tableClient = $storageAccount.CreateCloudTableClient()
    $cloudTable = $tableClient.GetTableReference($tableName)
    #
    #
    $query = New-Object "Microsoft.WindowsAzure.Storage.Table.TableQuery"
    $query.FilterString = $filterString

    try
    {
       $cloudTable.ExecuteQuery($query)
    }
    catch
    {
        write-host $_.Exception
    }
}

