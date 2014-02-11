<#
.Synopsis
   Protects a file from overwriting unless forced.
.DESCRIPTION
   This is intended to be used in the generation process 
.EXAMPLE
   From the readme.ps1 generator.

   Save-Protected -filename $filename -force $Force -action { $template |  out-file -FilePath $filename }
.NOTES
   General notes
.COMPONENT
   Generator
.ROLE
   This is part of the generator framework.
#>
function Save-Protected() 
{
    param (
       [Parameter(Mandatory=$true)]
       [string]$filename,

       [Parameter(Mandatory=$true)]
       [bool]$force,

       [Parameter(Mandatory=$true)]
       [ScriptBlock]$action
    )

    $shouldWrite = !(test-path $filename)

    if (!$shouldWrite)
    {
        $shouldWrite = $Force
    }

    if ($shouldWrite)
    {
       #Invoke-Template
       &$action
       #$template |  out-file -FilePath $filename 
       write-host "written $filename" 
    }
    else
    {
        Write-Host "Unable to write $filename use force"
    }

}

<#
.Synopsis
   Invoke a generator to create files.
.DESCRIPTION
   This is the main entry point for the generator.
.EXAMPLE
   Invoke-Generator readme "This is a test readme yet again." -Force
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   This is part of the generator framework.
.FUNCTIONALITY
   This the main entry point for the generator.
#>
function Invoke-Generator() 
{
    [CmdletBinding()]
	param(
       [parameter(Mandatory=$true,
                  ParameterSetName="Generator",
                  Position=0)]
       [string]$generator,

       [parameter(ParameterSetName="Generator", Position=1)]
       [Switch]$Force = $false,
       
       [Parameter(ValueFromRemainingArguments = $true,
                  ParameterSetName="Generator")]
       [Alias("msg")]
       [object[]]$paramList,

       [parameter(Mandatory=$true, ParameterSetName="Documentation")]
       [Switch]$Documentation
    )
  
    if($Documentation)
    {
        Get-ChildItem -Path $PSScriptRoot -Recurse -Include *.ps1 | % { get-help $_.FullName }
        return
    }

    $templateScript = "$PSScriptRoot\$generator\$generator.ps1"

    if(!(test-path $templateScript))
    {
        throw "Unable to find template '$generator'"
    }

    if ($paramList -ne $null)
    {
        $paramList | % { Write-Verbose "Param $_" }
    }
    
   if($force)
   {
     . $templateScript -Force $paramList
   }
   else
   {
      . $templateScript $paramList
   }
}
