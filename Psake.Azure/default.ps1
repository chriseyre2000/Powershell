properties {
  $testMessage = 'Executed Test!'
  $compileMessage = 'Executed Compile!'
  $cleanMessage = 'Executed Clean!'
}

Framework "4.5.1"

task default -depends Test

task Test -depends Compile, Clean { 
  $testMessage
}

task Compile -depends Clean { 
  $compileMessage
}

task Clean { 
  $cleanMessage
}

task ? -Description "Helper to display task info" {
	Write-Documentation
}

task ReleaseBuild {
  msbuild Azure.PackageMe.sln /t:Rebuild /p:Configuration=Release
}

task Publish {
  msbuild Azure.PackageMe.sln /t:Publish /p:Configuration=Release
}

task DebugBuild {
  msbuild Azure.PackageMe.sln /t:Rebuild /p:Configuration=Debug
}

task DebugPublish {
  msbuild Azure.PackageMe.sln /t:Publish /p:Configuration=Debug
}


task BuildAndPublish -depends ReleaseBuild,Publish

task BuildAndPublishDebug -depends DebugBuild,DebugPublish