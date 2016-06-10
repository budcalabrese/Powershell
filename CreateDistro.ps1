#####Creates a Distribution List & adss members from a CSV########
#####The CSV needs one header named members with email addresses## 

#Gathering Variables
$DLName = Read-Host "Enter Distribution List Name"
$Email = Read-Host "Enter Distribution List Email"
$Owner = Read-Host "Enter Distribution List Requesters Email Address"
$UserList = "C:\temp\userlist.csv" 

#Prompts for your user crendtials 
$UserCredential = Get-Credential

#Remove all existing Powershell sessions  
Get-PSSession | Remove-PSSession  

#Connects to Office 365 Exchange online using your crendtials above
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Imports Office 365 Exchange session commands into your local Windows PowerShell session.
Import-PSSession $Session -AllowClobber | Out-Null

#Creates the distribution list using the supplied variables
New-DistributionGroup `
 -Name "$DLName" `
 -DisplayName "$DLName" `
 -PrimarySmtpAddress "$Email" `
 -RequireSenderAuthenticationEnabled $False `
 -ManagedBy "$Owner"

#Adding users to the new Distribution List
Import-Csv $UserList| foreach {Add-DistributionGroupMember -Identity $DLName -Member $_.members}