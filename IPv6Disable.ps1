#### Disabling IPv6 and rebooting the machine ####
#### To remotely disable IPv6 winRM will have to be enabled ####

#Credentials used to connect to remote computer
$adminUser = "DOMAIN\USERNAME"
$adminPwd = "PASSWORD"
$compName = "REMOTECOMPUTERNAME"

 
$secPwd = ConvertTo-SecureString $adminPwd -AsPlainText -Force
$remoteCreds = New-Object System.Management.Automation.PSCredential ($adminUser, $secPwd)
$ServerSession = New-PSSession -ComputerName $compName -Authentication CredSSP -Credential $remoteCreds
 
Invoke-Command -Session $ServerSession -ScriptBlock 
{
	# Disable IPv6
	$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
	New-ItemProperty -Path $regPath -Name "DisabledComponents" -Value "0xFFFFFFFF" -PropertyType "DWORD" | Out-Null
	
}

# Restarting computer so change will take affect
Restart-Computer -ComputerName $env:computername -Force