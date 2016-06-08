##This Script allows you to turn off clutter for ll of your users 
##To check which users have Clutter enabled uncomment line 14
##To Disable Clutters only for users who have it enabled uncomment line 19   
 
#Prompts for your user crendtials 
$UserCredential = Get-Credential

#Imports the Azure Active Directory module
Import-Module MSOnline

#Connects to O365 Exchange online using your crendtials above
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Imports O365 Exchange session commands into your local Windows PowerShell session.
Import-PSSession $ExchangeSession

#Used to check Clutter status on Mailboxes
#$hash=$null;$hash=@{};$mailboxes=get-mailbox;foreach($mailbox in $mailboxes) {$hash.add($mailbox.alias,(get-clutter -identity $mailbox.alias.tostring()).isenabled)};$hash | ft

#Disables Clutter for mailboxes that have it enabled
#Get-Mailbox | ?{-not (Get-Clutter -Identity $_.Alias).IsEnabled} | %{Set-Clutter -Identity $_.Alias -Enable $false}

#Disbales Clutter for all users' mailboxes (Bulk)
Get-Mailbox -ResultSize Unlimited | Set-Clutter -Enable $False

#Ends the O365 Exchange online connection
Remove-PSSession $ExchangeSession 
