

#region SSH commands
show host-groups
show volumes
show volumes -csv
show volume-mapping [-volume-number volume_numbers | -volume-name volume_names ] [-mode {all| host-lun | default}]
show raid-groups

show host-wwn-names
set host-wwn-name -host-number 0 -name RX600_0

show host-path-state

create volume -name 'RDM cli' -rg-name 'RG50' -type open -size 50gb
create volume -rg-name RG50 -name dell2900data -type open -size 300gb

expand volume -volume-name 'RDM cli' -rg-name 'RG50' -size 5gb

show lun-groups
set lun-group -lg-name 'LG1' -volume-number 6 -lun 7

### remove LUN from LUN-group
#delete lun-group {-lg-number lg_numbers | -lg-name lg_names } [-lun luns]
#delete lun-group -lg-name 'LG1' -lun 7

#show volumes -type open|standard|sdv|sdpv|tpv|ftv|wsv
show volumes
#delete volume -volume-number 3,4


show thin-provisioning
show thin-pro-pools

#endregion

#region PS SMIS commands
#http://blogs.msdn.com/b/san/archive/2012/06/26/an-introduction-to-storage-management-in-windows-server-2012.aspx
#http://blogs.technet.com/b/filecab/archive/2012/06/25/introduction-to-smi-s.aspx#3506345 
#http://blogs.technet.com/b/filecab/archive/2012/07/06/3507632.aspx
Register-SmisProvider -ConnectionUri https://smis.contoso.com:5989 
Update-StorageProviderCache –DiscoveryLevel Full
Get-StorageProvider
Get-StorageSubSystem
Get-PhysicalDisk

#__copy these folders from server 2012 to client 8 machine in same location
#  C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.Windows.StorageManagementService.Configuration.Cmdlets
#  C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.Windows.StorageManagementService.Configuration.Cmdlets.Resources
#__copy SMISConfig module files 
Import-Module SMISConfig
Get-Command -Module SMISConfig
Register-SmisProvider -ConnectionUri http://192.168.0.230:5988
Search-SmisProvider
#endregion

#region Enter PS session on server with Storage Features installed
Enter-PSSession -ComputerName vmm
Register-SmisProvider -ConnectionUri http://192.168.0.230:5988
Unregister-SmisProvider
Search-SmisProvider
Update-StorageProviderCache –DiscoveryLevel Full
Get-StorageProvider
Get-StorageSubSystem
Get-PhysicalDisk

