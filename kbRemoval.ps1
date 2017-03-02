$myComputers = Get-Content "c:\scripts\test.txt" 


function Uninstall-Hotfix {
[cmdletbinding()]
param(
$computername = $env:computername,
[string] $HotfixID
)            

$hotfixes = Get-WmiObject -ComputerName $computername -Class Win32_QuickFixEngineering | select hotfixid            

if($hotfixes -match $hotfixID) {
    $hotfixID = $HotfixID.Replace("KB","")
    Write-host "Found the hotfix KB $HotfixID on" $computer
    Write-Host "Uninstalling the hotfix"
    $UninstallString = "cmd.exe /c wusa.exe /uninstall /KB:$hotfixID /quiet /norestart"
    ([WMICLASS]"\\$computername\ROOT\CIMV2:win32_process").Create($UninstallString) | out-null            

    while (@(Get-Process wusa -computername $computername -ErrorAction SilentlyContinue).Count -ne 0) {
        Start-Sleep 3
        Write-Host "Waiting for update removal to finish ..."
    }
write-host "Completed the uninstallation of $hotfixID on" $computer
}
else {            

write-host "Given hotfix($hotfixID) not found on" $computer
return
     }            
 }

ForEach ($computer in $myComputers) { 
    Uninstall-HotFix -ComputerName $computer -HotfixID KB3125574 
 }