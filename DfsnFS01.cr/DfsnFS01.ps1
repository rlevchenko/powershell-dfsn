<#
.Description
       Adds File Server and DFS services.
       Configures required namespace and replication group between 2 File Servers 
       Only 2 arguments: share name for files and domain admin password
       + adds requeried shares for failover witness and skype share (1 per namespace)

.NOTES
       Name: DFS Namespace, 2 Tiers
       Author : Roman Levchenko
       WebSite: www.rlevchenko.com
       Prerequisites: domain infrastructure, defined args,srv-fs-02

#>
#Variables
Start-Transcript -Path C:\result.txt
$pass = $args[0] #VMM argument
$sharename = $args[1] #VMM argument
$netbios = (Get-ADDomain -Identity (gwmi WIN32_ComputerSystem).Domain).NetBIOSName
$domain = (gwmi WIN32_ComputerSystem).Domain
$secpass = convertto-securestring $pass -asplaintext -force
$credential = New-Object System.Management.Automation.PsCredential -ArgumentList "$domain\Administrator", $secpass
$pcname = hostname
#DFSN Configuration
New-Item -Path C:\share\$sharename -Type Directory
New-Item -Path C:\share\skype -Type Directory
New-Item -Path C:\share\sqlcl -Type Directory
#General DFS namespace
New-ADGroup -Name "DFSUsers" -GroupScope Global -DisplayName "DFS Users" -Credential $credential;
New-SmbShare -Path C:\share\$sharename -Name $sharename -FullAccess "$domain\Administrator" -ReadAccess "$domain\DFSUsers";
Set-SMBPathACL -ShareName $sharename;
New-DfsnRoot -TargetPath \\$pcname\$sharename -Path \\$netbios\$sharename -Type DomainV2 -EnableAccessBasedEnumeration $true -GrantAdminAccounts "$domain\Administrator" -Confirm:$false;
New-DfsReplicationGroup -GroupName DFSReplication -Confirm:$false -DomainName $domain;
New-DfsReplicatedFolder -GroupName DFSReplication -FolderName $sharename -DomainName $domain -Confirm:$false;
Add-DfsrMember -GroupName DFSReplication -ComputerName SRV-FS-02 -Confirm:$false -DomainName $domain;
Add-DfsrMember -GroupName DFSReplication -ComputerName $pcname -Confirm:$false -DomainName $domain;
Add-DfsrConnection -SourceComputerName $pcname -GroupName DFSReplication -DestinationComputerName SRV-FS-02 -DomainName $domain -Confirm:$false;
Set-DfsrMembership -GroupName DFSReplication -FolderName $sharename -ComputerName $pcname -PrimaryMember $true -ContentPath c:\share\$sharename -DomainName $domain -Force;
Set-DfsrMembership -GroupName DFSReplication -FolderName $sharename -ComputerName SRV-FS-02 -PrimaryMember $false -ContentPath c:\share\$sharename -DomainName $domain -Force
Start-Sleep -Seconds 10
#DFS Namespace for skype
New-SmbShare -Path C:\share\skype -Name skype -FullAccess "Everyone"
Set-SMBPathACL -ShareName skype;
New-DfsnRoot -TargetPath \\$pcname\skype -Path \\$netbios\skype -Type DomainV2 -EnableAccessBasedEnumeration $true -Confirm:$false;
New-DfsReplicationGroup -GroupName SkypeReplication -Confirm:$false -DomainName $domain;
New-DfsReplicatedFolder -GroupName SkypeReplication -FolderName skype -DomainName $domain -Confirm:$false;
Add-DfsrMember -GroupName SkypeReplication -ComputerName SRV-FS-02 -Confirm:$false -DomainName $domain;
Add-DfsrMember -GroupName SkypeReplication -ComputerName $pcname -Confirm:$false -DomainName $domain;
Add-DfsrConnection -SourceComputerName $pcname -GroupName SkypeReplication -DestinationComputerName SRV-FS-02 -DomainName $domain -Confirm:$false;
Set-DfsrMembership -GroupName SkypeReplication -FolderName skype -ComputerName $pcname -PrimaryMember $true -ContentPath c:\share\skype -DomainName $domain -Force;
Set-DfsrMembership -GroupName SkypeReplication -FolderName skype -ComputerName SRV-FS-02 -PrimaryMember $false -ContentPath c:\share\skype -DomainName $domain -Force
Start-Sleep -Seconds 10
#Witness Namespace for SQL Cluster
New-SmbShare -Path C:\share\sqlcl -Name sqlcl -FullAccess "Everyone"
Set-SMBPathACL -ShareName sqlcl;
New-DfsnRoot -TargetPath \\$pcname\sqlcl -Path \\$netbios\sqlcl -Type DomainV2 -EnableAccessBasedEnumeration $true -Confirm:$false;
New-DfsReplicationGroup -GroupName WitnessReplication -Confirm:$false -DomainName $domain;
New-DfsReplicatedFolder -GroupName WitnessReplication -FolderName sqlcl -DomainName $domain -Confirm:$false;
Add-DfsrMember -GroupName WitnessReplication -ComputerName SRV-FS-02 -Confirm:$false -DomainName $domain;
Add-DfsrMember -GroupName WitnessReplication -ComputerName $pcname -Confirm:$false -DomainName $domain;
Add-DfsrConnection -SourceComputerName $pcname -GroupName WitnessReplication -DestinationComputerName SRV-FS-02 -DomainName $domain -Confirm:$false;
Set-DfsrMembership -GroupName WitnessReplication -FolderName sqlcl -ComputerName $pcname -PrimaryMember $true -ContentPath c:\share\sqlcl -DomainName $domain -Force;
Set-DfsrMembership -GroupName WitnessReplication -FolderName sqlcl -ComputerName SRV-FS-02 -PrimaryMember $false -ContentPath c:\share\sqlcl -DomainName $domain -Force

