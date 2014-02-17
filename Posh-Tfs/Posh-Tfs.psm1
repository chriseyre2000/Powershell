<#
.Synopsis
A collection of powershell tfs utilities.

.DESCRIPTION

Adds tfs functions that are missing from the IDE.
This uses the tf.exe that is installed on the users machine.
It only works in a folder already mapped to tfs for an already authentcated user.

#>


#Module variables to assist tfs 
$vstools = Get-ChildItem env:vs*tools | select -Last 1 value
$tfpath = "$($vstools.Value)..\ide\tf.exe"

<#
.Synopsis
Checks out a specific file
#>
function Invoke-tfsCheckOut([string]$filename)
{
    . $tfpath checkout $filename 
}

<#
.Synopsis
Checks in a specific file
#>
function Invoke-tfsCheckIn([string]$filename, [string]$comment)
{
    . $tfpath checkin $filename /comment:$comment
}

<#
.Synopsis
Querys the tfs help for a given topic
#>
function Get-tfsHelp([string]$topic)
{
    . $tfpath help $topic 
}

<#
.Synopsis
Sets the tfs workspace
#>
function set-tfsworkspace([string]$server)
{
    . $tfpath workspaces /collection:$server
}

<#
.Synopsis
Gets the current tfs connections
#>
function Get-tfsConnections()
{
    . $tfpath connections | select -Skip 1 | convertfrom-csv -Delimiter " " -Header "Server","User" | select -Skip 1
}

<#
.Synopsis
Lists the workspaces belonging to the current user
#>
function Get-tfsWorkspaces()
{
    $data = . $tfpath workspaces
    
    write-host $data[0]
    
    $data | select -skip 1
}


<#
.Synopsis
Gets files changed,added and removed.

.DESCRIPTION
Detects changes between filesystem and tfs.
This is something that the vs ide is not good at.
#>
function Get-tfsStatus()
{
    . $tfpath status "$pwd\*" /recursive
}

<#
.Synopsis
Includes files in the tfs checkin system.
#>
function add-tfsitem([string]$filename)
{
    . $tfpath add $filename
}

#Another wip 
#function get-tfsfolderdiff()
#{
#    . $tfpath folderdiff $/
#}

<#
.Synopsis
Gets the latest source from tfs.
#>
function get-tfslatest()
{
    . $tfpath get /recursive
}

<#
.Synopsis
Gets details about a specific changeset
#>
function get-tfschangeset()
{
    param(
    [string]$changesetNumber
    )

    if ($changesetNumber -eq $null)
    {
        . $tfpath changeset /latest
    }
    else
    {
        . $tfpath changeset $changesetNumber
    }
}

<#
.Synopsis
Updates comments in the changeset
#>
function Update-TfsChangesetComment()
{
    param
    (
    [Parameter(Mandatory=$true)]
    [string]$changesetNumber,
    [Parameter(Mandatory=$true)]
    [string]$comment
    )
    . $tfpath changeset $changesetNumber /comment:$comment   
}

function out-tfsprompt()
{
    $dict = Get-tfsstatus | Select-String -Pattern ".* (?<Change>add|edit|delete)(\w*)(?<Path>.*)" | select -ExpandProperty Matches | % { $_.Groups["Change"].Captures.Value } | group -NoElement

    $add  = $dict | where Name -eq add | select -ExpandProperty Count
    $edit = $dict | where Name -eq edit | select -ExpandProperty Count
    $delete = $dict | where Name -eq delete | select -ExpandProperty Count
    if ($add -eq $null) { $add = 0 }
    if ($edit -eq $null) { $edit = 0}
    if ($delte -eq $null) { $delete = 0} 

    "PS $pwd [+$add ~$edit -$delete]> "
}

# This can be a little too slow
#function prompt()
#{
#    out-tfsprompt
#}

#<#
#.Synopsis
#Updates comments and notes in the changeset
#This is a work in progress. Currently I can't identify the required fields.
##>
#function Update-TfsChangesetNote()
#{
#    param
#    (
#    [Parameter(Mandatory=$true)]
#    [string]$changesetNumber,
#    [Parameter(Mandatory=$true)]
#    [string]$notekey,
#    [Parameter(Mandatory=$true)]
#    [string]$notevalue
#
#    
#    )
#    . $tfpath changeset $changesetNumber /notes:`("$notekey"="$notevalue"`)
#}

<#
.Synopsis
Get details about revision and changeset details.
#>
function get-tfsinfo()
{
    param (
        [string]$itemspec = "*",
        [string]$versionspec
    )

    if ($versionspec -eq $null)
    {
        . $tfpath info $itemspec
    }
    else 
    {
        . $tfpath info $itemspec /version:$versionspec
    }
}


<#
.Synopsis
Get details about revision and changeset details. Recursively
#>
function get-tfsinforecursive()
{
    param (
        [string]$itemspec = "*",
        [string]$versionspec
    )

    if ($versionspec -eq $null)
    {
        . $tfpath info $itemspec /recursive
    }
    else 
    {
        . $tfpath info $itemspec /version:$versionspec /recursive
    }
}

function get-tfshistory()
{
    param (
        [string]$itemspec = "*",
        [string]$versionspec
    )

    if ($versionspec -eq $null)
    {
        . $tfpath history $itemspec
    }
    else 
    {
        . $tfpath history $itemspec /version:$versionspec
    }
}

function get-tfsworkfold($item)
{
    . $tfpath workfold $item
}

function invoke-tfsundo($itemspec)
{
    . $tfpath undo $itemspec
}

function invoke-tfsundelete($itemspec)
{
    . $tfpath undelete $itemspec
}

function invoke-tfsrollback($itemspec)
{
    . $tfpath rollback $itemspec
}