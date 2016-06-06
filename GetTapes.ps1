#Imports Backup Exec Powershell Module
import-module bemcli

If(!$Module){
    Import-Module bemcli
}

#Email Variables
$SmtpServer = 'relayserver@test.com'
$From = 'BackupExec@test.com'
$To = 'emailtorecievereport@test.com'
$Subject = 'Weekly Tapes'

#Perfoms a tape scan on the Robotic Library
Get-BERoboticLibraryDevice "Robotic Library 0001" | Submit-BEScanJob

#This pauses the script while the inventory job runs, without the email sends before the scan is complete
Start-Sleep -s 30

#This Looks at the tapes in the Tape Library to generate a report of all the tapes
$Tape = Get-BERoboticLibrarySlot -RoboticLibraryDevice "Robotic Library 0001" | Select-Object -ExpandProperty Media | Select-Object Name, MediaSet, AppendableUntilDate, IsFull | ConvertTo-HTML 

#Generated for the email report body
$Email = "<p> $Tape </p>"

#Emails the report generated above
Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SmtpServer -BodyAsHtml -Body $Email