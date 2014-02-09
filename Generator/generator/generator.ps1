<#
.Synopsis
   Generator - used to create other generators.
.NOTES
   This is an unusual generator - it put the generated generator into the generators directory.
.ROLE
   This is part of the generator framework.
.DESCRIPTION
   This is a generator used to create other generators.
   It accepts a single parameter that of the name of the generator to be created.
#>
param(

[switch]$Force

)

$Name = $args | select -first 1

if ($name -eq $null) {
    throw "Please enter a name."
}

write-host "$name '$args'" 

if(!(test-path -PathType Container "$PSScriptRoot\..\$Name")) {
    
    new-item -ItemType directory -Path "$PSScriptRoot\..\$Name"
}

$filename = "$PSScriptRoot\..\$Name\$Name.ps1"

$template = @"

<#
.Synopsis
   This is a template for $name.
.NOTES
   You need to implment some deatils here.
.ROLE
   This is part of the generator framework.
#>

param(
[switch]$Force
)

#TODO: Please update the template

# The following is a sample template.

#$template = `@"
#       Readme for `$($args)
#"`@
#
#
#$filename = "readme.md"
#
#
#Save-Protected -filename $filename -force $Force -action {
#    $template |  out-file -FilePath $filename
#}
"@

Save-Protected -filename $filename -force $Force -action {
    $template |  out-file -FilePath $filename
}