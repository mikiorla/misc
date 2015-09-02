
#Get-ADComputer -Filter * -Properties Created, 
#Get-ADComputer -Filter 'Name -like "sf16*"' -Properties Created,LastLogonDate,Modified
Get-ADComputer -Filter * -Properties Created,LastLogonDate,Modified | select Name,LastLogonDate | sort LastLogonDate
#Get-ADComputer -Filter 'Modified -lt "6/1/2015"' -Properties Modified,LastLogonDate | select Name,Modified,LastLogonDate

Get-ADComputer -Filter 'Modified -lt "6/1/2015"' -Properties Modified,LastLogonDate #| Remove-ADComputer -Verbose -Confirm:$false 
Get-ADComputer -Filter 'Modified -lt "6/1/2015"' -Properties Modified,LastLogonDate #| Remove-ADObject -Confirm:$false

#Get-ADUser -Filter 'Name -like "*ipam*"'
#Get-ADGroup -Filter 'Name -like "*ipam*"'
