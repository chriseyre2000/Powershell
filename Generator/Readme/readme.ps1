
param(

[switch]$Force
)


$template = @"
       Readme for $($args)
"@

$filename = "readme.md"

$shouldWrite = !(test-path $filename)

if (!$shouldWrite)
{
    $shouldWrite = $Force
}

if ($shouldWrite)
{
   $template |  out-file -FilePath $filename 
   write-host "written $filename" 
}
else
{
    Write-Host "Unable to write $filename use force"
}

    


