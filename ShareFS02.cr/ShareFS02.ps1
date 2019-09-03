<#
.Description
       Creates new share on the second file server. 
       It's required during DFS namespace configuration.
       + shares for witness and skype

.NOTES
       Name: New SMB Share
       Author : Roman Levchenko
       WebSite: www.rlevchenko.com
       Prerequisites: domain infrastructure, defined args

#>

#Variables
$sharename = $args[0] #VMM argument
$domain = (gwmi WIN32_ComputerSystem).Domain
#Create new share
New-Item -Path C:\share\$sharename -Type Directory
New-SmbShare -Path C:\share\$sharename -Name $sharename -FullAccess "$domain\Administrator"
Set-SMBPathAcl -ShareName $sharename
#Shares for witness/skype
New-Item -Path C:\share\skype -Type Directory
New-Item -Path C:\share\sqlcl -Type Directory
New-SmbShare -Path C:\share\sqlcl -Name sqlcl -FullAccess "Everyone"
Set-SMBPathACL -ShareName sqlcl
New-SmbShare -Path C:\share\skype -Name skype -FullAccess "Everyone"
Set-SMBPathACL -ShareName skype