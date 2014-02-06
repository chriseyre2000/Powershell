#
$edmlib    = "D:\dev\github\Powershell\Azure\Microsoft.Data.Edm.5.6.0\lib\net40\Microsoft.Data.Edm.dll"
$azurelib  = "d:\dev\github\powershell\azure\windowsazure.storage.3.0.2.0\lib\net40\Microsoft.WindowsAzure.Storage.dll"             
$odata     = "D:\dev\github\powershell\azure\Microsoft.Data.OData.5.6.0\lib\net40\Microsoft.Data.OData.dll"                                     
$dataserviceclient = "D:\dev\github\powershell\azure\Microsoft.Data.Services.Client.5.6.0\lib\net40\Microsoft.Data.Services.Client.dll"                 
$configmgr = "D:\dev\github\powershell\azure\Microsoft.WindowsAzure.ConfigurationManager.1.8.0.0\lib\net35-full\Microsoft.WindowsAzure.Configuration.dll"
$json = "D:\dev\github\powershell\azure\Newtonsoft.Json.5.0.8\lib\net40\Newtonsoft.Json.dll"                                               
$spatial = "D:\dev\github\powershell\azure\System.Spatial.5.6.0\lib\net40\System.Spatial.dll"                                                 

#
try
{
  Add-Type -path "$json"
  Add-Type -path "$spatial"  
  Add-Type -path "$edmlib" 
  Add-Type -path "$azurelib" 
  Add-Type -path "$dataserviceclient"
  Add-Type -path "$odata"    
  Add-Type -path "$configmgr"

}
catch
{
    write-host $_.Exception.Message
    write-host $_.Exception.LoaderExceptions
}

#This is currently not working against the emulator as the storage api is not implemented there yet!
$connectionString = "UseDevelopmentStorage=true;"

#$connectionString = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;"
$tableName = "WADLogsTable"

$filterString = "PartitionKey gt '$("0" + [System.DateTime]::UtcNow.AddYears(-1).Ticks)'"

$storageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($connectionString)
$tableClient = $storageAccount.CreateCloudTableClient()
$cloudTable = $tableClient.GetTableReference($tableName)


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


