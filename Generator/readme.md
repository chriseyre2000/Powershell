#Generator
This is a generator based upon an old monorail spcaffolding tool in boo.

To get started use import-module .\generator.psm1

##Example

Change to an empty directory.
Use the following command:

    invoke-generator readme -m "This is a test readme"

This will create a readme.md file in the current directory.

It won't overrwrite by default:

    invoke-generator readme -m "This is a test readme - update will fail"

It can be made to overwrite:

   invoke-generator readme -m "This is a test readme - update will work" -Force
	
Generators are kept in the generator folder.
To remove one just delete the folder.


