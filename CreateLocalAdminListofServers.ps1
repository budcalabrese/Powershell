###### This script goes through a list of server creates a new local account, sets the  ######      
######  password to not expire, and adds the account to the local administrators group  ######

#Declaring Variables
$Username = 'Test3'
$Password = "testing123!"
$ServerList = Get-Content C:\temp\serverlist.txt

#For loop that goes through the list of servers and does the account magic
foreach ($Server in $ServerList) {
    try {
        $Computer = [ADSI]"WinNT://$Server"
        $NewUser = $Computer.Create('User',"$Username") 
        $NewUser.SetPassword($Password)
        $NewUser.SetInfo()
        $NewUser.UserFlags.value = $NewUser.UserFlags.value -bor 0x10000
        $NewUser.SetInfo() 
        $AdminUser = [ADSI]"WinNT://$Server/$Username,user"
        $AdminGroup = [ADSI]"WinNT://$Server/Administrators,group"
        $AdminGroup.add($AdminUser.path)
        }
    catch {
        Write-Host "Error creating $Username on computer $Server :  $($Error[0].Exception.Message)"
    }
}