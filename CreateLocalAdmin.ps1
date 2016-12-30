###### This script creates a new local account, sets the password to       ######      
###### not expire, and adds the account to the local administrators group  ######

#Declaring Variables
$Username = 'Test3'
$Password = "testing123!"
$Computername = $env:COMPUTERNAME
$ADSIComp = [ADSI]"WinNT://$Computername" 
$AdminUser = [ADSI]"WinNT://$Computername/$username,user"
$AdminGroup = [ADSI]"WinNT://$Computername/Administrators,group"

#Creating user account
$NewUser = $ADSIComp.Create('User',$Username) 

#Setting password 
$NewUser.SetPassword(($_password))
$NewUser.SetInfo()

#Setting password to not expire
$NewUser.UserFlags.value = $NewUser.UserFlags.value -bor 0x10000
$NewUser.SetInfo() 

#Adding user to local admin group
$AdminGroup.add($AdminUser.path)