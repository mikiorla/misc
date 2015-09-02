
Get-Alias g*
Get-Alias gcm

gcm -Name *certificate*

New-SelfSignedCertificate -DnsName dpm.ktehnika.co.rs -CertStoreLocation Cert:\LocalMachine\My

#list certificates in specific path
gci Cert:\LocalMachine\My | fl 
gci Cert:\LocalMachine\My -DnsName *dpm* 

$previusLocation = Get-Location
Set-Location -Path cert:\LocalMachine\My
gci -Path E2583C245EEC1439E5084E5FFE0687E87DEA0F5D
Set-Location $previusLocation