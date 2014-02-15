This is the starting point for an Azure package and build script.
I want to get the service config values defined in an external file.

Currently this shows how to package azure at the commandline with Psake.

Build.bat is the entry point for the developer.
minimal.build is a sample msbuild script designed to kick off build.bat
default.ps1 is the Psake build script.

You need to edit default.ps1 to replace the project with the one that you are using.

Psake is pronounced SAR-KAY just like the drink. 