##This Script will run through all of your mailboxes and tell you the clutter status## 

#Setting Variables  
$OutputFile = "C:\temp\ClutterDetails.csv"   #The CSV Output file that is created, change for your purposes  

#Prompts for your user crendtials 
$UserCredential = Get-Credential

#Remove all existing Powershell sessions  
Get-PSSession | Remove-PSSession  

#Connects to Office 365 Exchange online using your crendtials above
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Imports Office 365 Exchange session commands into your local Windows PowerShell session.
Import-PSSession $ExchangeSession -AllowClobber | Out-Null

#Prepare Output file with headers  
Out-File -FilePath $OutputFile -InputObject "UserPrincipalName,SamAccountName,ClutterEnabled" -Encoding UTF8  

#Gather all mailboxes from Office 365
write-host "Retrieving Mailboxes"
$objUsers = get-mailbox -ResultSize Unlimited | select UserPrincipalName, SamAccountName  
  
#Iterate through all users      
Foreach ($objUser in $objUsers)  
{      
    #Prepare UserPrincipalName variable  
    $strUserPrincipalName = $objUser.UserPrincipalName  
    $strSamAccountName = $objUser.SamAccountName  
         
    #Get Clutter info to the users mailbox  
    $strClutterInfo = $(get-clutter -Identity $($objUser.UserPrincipalName)).isenabled   
     
    #Prepare the user details in CSV format for writing to file  
    $strUserDetails = "$strUserPrincipalName,$strSamAccountName,$strClutterInfo" 
      
    #Append the data to file  
    Out-File -FilePath $OutputFile -InputObject $strUserDetails -Encoding UTF8 -append  
}  