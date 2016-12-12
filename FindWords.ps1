## Setting variables ##

$text = "s#*t"
$PathArray = @()
$results = "\\testmachine\c$\temp\results.txt"

Import-Module ActiveDirectory

## Getting the OU Name to Scan ##
$OU = "OU=Servers,DC=V-Blog,DC=local" 

## Window Title ##
$Host.UI.RawUI.WindowTitle = "Processing Computers in OU " + $OU

## Computer name list ##
$ComputerNames = Get-ADComputer -Filter * -SearchBase $OU | Select Name

## Performs the search on all the drives on the machines in the searched OU ##
FOREACH ($Computer in $ComputerNames) {
    $drives = (Get-WmiObject Win32_LogicalDisk -ComputerName $Computer.Name | where DriveType -eq '3' | Select -ExpandProperty DeviceID) -replace ":","$" 
    foreach($drive in $drives) {
    $files = Get-ChildItem "\\$($Computer.Name)\$drive" -Filter "test*.html" -Recurse -ErrorAction SilentlyContinue -File
    $matches = Select-String -path $files.FullName -SimpleMatch $Text
    $PathArray+=($matches.Path | select -Unique)
    }

## Output the results to a text file ##
$PathArray | % {$_} | Add-Content $results 
}