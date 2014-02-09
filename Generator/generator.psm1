function Invoke-Generator() 
{
    [CmdletBinding()]
	param(
       [Parameter(Mandatory=$true)]
       [string]$generator,

       [Switch]$Force = $false,
       
       [Parameter(ValueFromRemainingArguments = $true)]
       [object[]]$paramList
    )
  
    $templateScript = "$PSScriptRoot\$generator\$generator.ps1"

    if(!(test-path $templateScript))
    {
        throw "Unable to find template '$generator'"
        #write-error "Unable to find template '$generator'" -Category InvalidArgument -ErrorId 404 -RecommendedAction "Check Generator Name"
        #return
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



