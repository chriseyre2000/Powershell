$tfptpath = "$($env:TFSPowerToolDir)tfpt.exe"

function get-tfpthelp($command)
{
    . $tfptpath help $command
}

function get-workitem($command)
{
    . $tfptpath workitem $command
}

#Warning this is not reliable.
#function update-workitem([int]$id,[Hashtable]$fields)
#{
#    $updatedFields = ( $fields | select -ExpandProperty keys | % { $_ + " = " + $fields.$_  + ";" } ) -join ""
#    . $tfptpath workitem /update $id /fields:$updatedFields
#}


function select-mytfsworkitems($wiql)
{
    . $tfptpath query | ConvertFrom-Csv -Delimiter `t | Where ID -NotMatch "Q.*"
}


<# 

.EXAMPLE 1 

select-tfsworkitemquery "select ID,State,[Work Item Type] from WorkItems where Id > 0"

.EXAMPLE 2
select-tfsworkitemquery "select ID,[Remaining Work] from WorkItems where [Work Item Type] = 'Task'"  | measure -sum "Remaining Work" | select Sum
Calculates the work remaining on all tasks.

.EXAMPLE 3
select-tfsworkitemquery "select ID,[Remaining Work] from WorkItems where [Work Item Type] = 'Task' asof '2014-02-21 12:30'"
Calculates the work remaining on all tasks as of 21st Feb 2014 at 12:30.

.EXAMPLE 4
select-tfsworkitemquery "select ID,[Remaining Work] from WorkItems where [Work Item Type] = 'Task'" and [Iteration Path] = 'Project XXX\Sprint 42'  | measure -sum "Remaining Work" | select Sum
This gives the information required for a burn down chart.

#>
function select-tfsworkitemquery($wiql)
{
    . $tfptpath query /wiql:"$wiql" | ConvertFrom-Csv -Delimiter `t | Where ID -NotMatch "Q.*"
}


#tfpt addprojectportal	Add or move portal for an existing team project
#tfpt addprojectreports	Add or overwrite reports for an existing team project
#tfpt annotate		Display line-by-line change information for a file
#tfpt bind		Convert VSS-bound solutions into TFS-bound solutions
#tfpt branches		Convert, reparent, list, and update branches
#tfpt builddefinition	Clone, Diff or Dump build definitions
#tfpt buildprocesstemplate	Manage build process templates
#tfpt connections	Modifies Team Explorer client connection settings
#tfpt createteamproject	Create a team project
#tfpt getcs		Get only the changes in a particular changeset
#tfpt online		Pend adds, edits, deletes to writable files
#tfpt query		Query for work items
#tfpt review		Review (diff/view) workspace changes
#tfpt scorch		Ensure source control and the local disk are identical
#tfpt searchcs		Search for changesets matching specific criteria
#tfpt treeclean 		Delete files and folders not under version control
#tfpt unshelve		Unshelve into workspace with pending changes
#tfpt uu			Undo changes to unchanged files in the workspace
#tfpt workitem		Create, update, or view work items