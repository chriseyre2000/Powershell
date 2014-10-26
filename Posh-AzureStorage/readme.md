* Posh-AzureStorage *

This is a library that will allow the AzureStorage api to be exposed to powershell.
This is based upon the simple to use .net client rather than the more complex restful api.

This has a dependency on posh-nuget.

It requires the following commandlet to be run to enable the rest of the commandlets:

Install-AzureStorageModule

Once that has been run it will allow the following commandlets:

Get-AzureCloudStorageAccount
Get-AzureQueueList
