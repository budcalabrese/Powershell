##This Script allows you to turn off clutter for ll of your users###
##To Disable Clutters only for users who have it enabled uncomment line 18   

#Prompts for your user crendtials 
$UserCredential = Get-Credential

#Remove all existing Powershell sessions  
Get-PSSession | Remove-PSSession  

#Connects to Office 365 Exchange online using your crendtials above
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Imports Office 365 Exchange session commands into your local Windows PowerShell session.
Import-PSSession $ExchangeSession -AllowClobber | Out-Null

#Disables Clutter for mailboxes that have it enabled
#Get-Mailbox | ?{-not (Get-Clutter -Identity $_.Alias).IsEnabled} | %{Set-Clutter -Identity $_.Alias -Enable $false}

#Disbales Clutter for all users' mailboxes (Bulk)
Get-Mailbox -ResultSize Unlimited | Set-Clutter -Enable $False

#Ends the Office 365 Exchange online connection
Remove-PSSession $ExchangeSession 




