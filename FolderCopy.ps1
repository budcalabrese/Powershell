#This script copies a source directory to a new location using BITS

function CopyFiles
{
    #Set copy variables
    $Source = "Source folder to copy"
    $Destination = "Destination location"
    $Folders = Get-ChildItem -Name -Path $Source -Directory -Recurse
    
    Import-Module BitsTransfer

    #Start Bits Transfer for all items in each directory. Creates each directory if they do not exist at destination.
    Start-BitsTransfer -Source $Source\*.* -Destination $Destination
    foreach ($i in $folders)
    {
        $exists = Test-Path $Destination\$i
        if ($exists -eq $false) {New-Item $Destination\$i -ItemType Directory}
        Start-BitsTransfer -Source $Source\$i\*.* -Destination $Destination\$i
    }
}

function Email
{
    #Email message variables
    $smtpServer = "mailrelay@V-BLOG.com"
    $from = "PowerShell@V-BLOG.com"
    $emailaddress = "user@V-BLOG.com"
    $subject = "Copy of Folder Complete"
    $body = "<p>Copy of Folder Complete</p>"

    #Sends a email after completing the transfer using the variables above    
    Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High
}

CopyFiles
Email