#############################################################
#### This will expand the Hard Drive of Disk 1 in VMware ####
#############################################################

# Setting the vCenter variables 
$vCenter = 'vCenterServerName'

# Setting Drive Size in GB
$DriveSizeGB = 75

# List of servers to expand
$ServerList = Get-Content 'C:\temp\disk\serverlist.csv'

# Importing the PowerCLI Module
Import-Module VMware.VimAutomation.Vds -ErrorAction Stop
# Connecting to vCenter
Connect-VIServer $VCenter -Credential (Get-Credential) | Out-Null

# Loop to set Hard Drive to $DriveSize variable in VMware. Will output status to a file
ForEach ($Server in $ServerList) {
    Try {
        Get-HardDisk -vm $Server | where {$_.Name -eq "Hard Disk 1"} | 
        Set-HardDisk -CapacityGB $DriveSizeGB -Confirm:$false
        Write-Output "Set drive to $DriveSizeGB on $Server" | Out-File 'C:\temp\disk\disksuccess.csv'
    }
    Catch {
        Write-Output "Could not expand drive on $Server" | Out-File 'C:\temp\disk\diskerror.csv'
    }
}

# Closing the vCenter session
Disconnect-VIServer -Server $vCenter -Confirm:$false

#######################################################################################
#### This expands the C: drive of a Windows box to the maximum free space avaiable ####
#### PowerShell v3 and above is required                                           ####
#######################################################################################

# List of servers to expand
$ServerList = Get-Content 'C:\temp\disk\serverlist.csv'

# ForEach loop to xpand the C: drive for all servers in $ServerList
ForEach ($Server in $ServerList) {
    Try {
        Invoke-Command -ComputerName $Server -ScriptBlock {
        # Scanning the disk bus
        "rescan" | diskpart;
        # Querying what the max allowed size of the drive is set to
        $MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax;
        # Setting the C:\ drive to the maximum size allocated
        Resize-Partition -DiskNumber 0 -PartitionNumber 2 -Size $MaxSize }
        Write-Output "Set drive to $DriveSizeGB on $Server" | Out-File 'C:\temp\diskexpand\disksuccess.csv'
    }
    Catch {
        Write-Output "Could not expand drive on $Server" | Out-File 'C:\temp\diskexpand\diskerror.csv'
    }