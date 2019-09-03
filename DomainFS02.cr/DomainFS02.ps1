<#
.Description
       Script for joining computer to existing domain.
       No RunAS required. Just one ARG for Domain Admin Password.
       Restart is automatic.

.NOTES
       Name: Join to Domain
       Author : Roman Levchenko
       WebSite: www.rlevchenko.com
       Prerequisites: domain infrastructure

#>
#Variables
$DC01 = 'ip'
$DC02 = 'ip'
$pass = $args[0] #VMM argument
$secpass = convertto-securestring $pass -asplaintext -force
$localcred = New-Object System.Management.Automation.PsCredential -ArgumentList "Administrator", $secpass
$test = Test-Connection -ComputerName $DC01 -Count 10 -BufferSize 16 -Quiet
#Join to domain using DC01
IF ($test -match 'True') {
    $domain = (Get-ADDomain -Server $DC01 -Credential $localcred).DNSRoot 
    $credential = New-Object System.Management.Automation.PsCredential -ArgumentList "$domain\Administrator", $secpass
    Add-Computer -Credential $credential -DomainName $domain -Confirm:$false 
}
#Join to domain using DC02
ELSE {
    $domain2 = (Get-ADDomain -Server $DC02 -Credential $localcred).DNSRoot
    $secpass2 = convertto-securestring $pass -asplaintext -force
    $credential2 = New-Object System.Management.Automation.PsCredential -ArgumentList "$domain2\Administrator", $secpass2
    Add-Computer -Credential $credential2 -DomainName $domain2 -Confirm:$false 
}