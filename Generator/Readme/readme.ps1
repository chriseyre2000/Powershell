<#
.Synopsis
   Readme - generates readme.md files for github.
.NOTES
   This was the first generator created.
.ROLE
   This is part of the generator framework.
.DESCRIPTION
   The arguments passed after the name of the generator form the starting content.
#>

param(
[switch]$Force
)


$template = @"
Readme for $($args)
"@


$filename = "readme.md"


Save-Protected -filename $filename -force $Force -action {
    $template |  out-file -FilePath $filename
}


