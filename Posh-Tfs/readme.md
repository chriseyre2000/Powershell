This is yet another posh-tfs script.

These only fully work from within a folder that has been mapped to tfs.

This is not based on other version - the prompt function is not very practical for a remote tfs server - especially if your codebase is large.
I do have a prompt function but it is not installed by default. 

It merely exposes command line tf functions through powershell.
It also avoids the need to play with your path.

There is a second module posh tfpt that wraps the tfs power tools.
This is useful for writing queries against tfs work items.