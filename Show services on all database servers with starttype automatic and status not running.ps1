# Show services on all database servers with starttype automatic and status not running
# Run from beheer.rambeheer.local
# Do not save the script (gives error script cannot be loaded because running scripts is disabled on this system)
Import-Module ActiveDirectory
$skippedServers = @() # empty array
$skippedServices = @('RemoteRegistry','ShellHWDetection','sppsvc','SQLTELEMETRY$RUMC','SQLTELEMETRY$RWS1')
Get-Service -computerName (
                            Get-ADComputer -Filter * -SearchBase "OU=SCCM,OU=Servers,OU=Computers,OU=DB,DC=db,DC=ecumulus,DC=nl" -Server "DBPRSVDC1" | Select-Object -Expand name | Where-Object {$_ -notin $skippedServers}
                          ) `
    | Where-Object {$_.StartType -eq "automatic" -and $_.status -ne "running"} `
    | Where-Object {$_.Name -notin $skippedServices} | Select-Object MachineName, Name, StartType, Status | Out-Gridview