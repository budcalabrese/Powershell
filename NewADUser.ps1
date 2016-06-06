#Import the Active Directory module; Continue if already installed
Import-Module ActiveDirectory

#Gathering variables for new account creation
$FirstName = Read-Host "Enter First Name"
$LastName = Read-Host "Enter Last Name"
$AccountName = Read-Host "Enter account name (Example jsmith)"
$Title = Read-Host "Enter Job Title"
$CopyUser = Read-Host "Enter a user to copy permissions from (Example jsmith)"
$Password = Read-Host "Enter password for new account" -AsSecureString

#Creates a new Active Directory user account using the variables above
New-ADUser `
 -Name ("$FirstName $LastName") `
 -SamAccountName  ("$AccountName") `
 -GivenName "$FirstName" `
 -Surname "$LastName" `
 -DisplayName ("$FirstName $LastName") `
 -AccountPassword $Password `
 -UserPrincipalName "$AccountName@V-Blog.local" `
 -EmailAddress "$AccountName@V-Blog.local" `
 -Title "$Title" `
 -Enabled $true

#Copies group membership of one user to the new user created above
Get-ADUser -Identity $CopyUser -Properties memberof |
Select-Object -ExpandProperty memberof |
Add-ADGroupMember -Members $AccountName -PassThru |
Select-Object -Property SamAccountName