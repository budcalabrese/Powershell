## On older versions of PowerShell using the ADSI you can run into into issues ##
########### This script moves a local user to the local admins group ###########

#Getting list of server
$ServerList = Get-Content C:\temp\serverlist2.txt

#For loop goes through the list of servers and adds the user to the admin group
foreach ($Server in $ServerList) {
    try { 
        Invoke-Command -ComputerName $Server -ScriptBlock {NET LOCALGROUP "Administrators" /ADD "testadmin"}
        }
    catch {
        Write-Host "Error adding Local Admin on computer $Server :  $($Error[0].Exception.Message)"
    }
}
