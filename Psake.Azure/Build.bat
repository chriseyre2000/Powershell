@rem configuration can be Release or Debug
powershell .\psake.ps1 "default.ps1" "BuildAndPublish" "4.5.1" "$false" "" "@{'configuration'='Release'}"