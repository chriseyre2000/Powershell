<#
.EXAMPLE
   This shows exposing powershell queries
   
   Search-AzureTableStorageV2 | % { EntityToObject $_ } | select PartitionKey,RowKey,Level,Message | ft -AutoSize
#>

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

function Update-TableStorage()
{
    param(
        [string]$connectionString = "UseDevelopmentStorage=true;", 
        [string]$tableName = "WADLogsTable", 
        $entity
    )

    $storageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($connectionString)
    $tableClient = $storageAccount.CreateCloudTableClient()
    $cloudTable = $tableClient.GetTableReference($tableName)

    $insertOrReplaceOperation = TableOperation.InsertOrReplace($entity);

   // Execute the operation.
   $cloudTable.Execute($insertOrReplaceOperation)

}

function EntityToObject ($item)
{

    $p = new-object PSObject
    $p | Add-Member -Name ETag -TypeName string -Value $item.ETag -MemberType NoteProperty 
    $p | Add-Member -Name PartitionKey -TypeName string -Value $item.PartitionKey -MemberType NoteProperty
    $p | Add-Member -Name RowKey -TypeName string -Value $item.RowKey -MemberType NoteProperty
    $p | Add-Member -Name Timestamp -TypeName datetime -Value $item.Timestamp -MemberType NoteProperty

    $item.Properties.Keys | foreach { $type = $item.Properties[$_].PropertyType; $value = $item.Properties[$_].PropertyAsObject ; Add-Member -InputObject $p -Name $_ -Value $value -TypeName $type -MemberType NoteProperty -Force }
    $p
}