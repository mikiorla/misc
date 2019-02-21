$sw_all = [system.diagnostics.stopwatch]::startNew()

#$subnets = Import-Csv D:\_ps\input\DDOR_subnets.txt
#$file = Get-Item D:\_ps\input\AD_Computers_Without_DNS_record.txt
#$fileContent = gc $file

 
$ipsub = “192.168.2”  
[int]$startRange = 1  
[int]$endRange = 254  
$ping = New-Object System.Net.Networkinformation.ping
$counter = $startRange 
$startRange..$endRange | % {
Write-Progress -Activity "Scaning subnet $ipsub" -Status "Scaning ip $($counter) of $($endRange)" -PercentComplete (($Counter/$endRange) * 100)
 $a = $ping.Send("$ipsub.$_" , 500)
 if ($a.Status -eq "Success")
 { write-host -f green "$ipsub.$_"}

 #else {    write-host -f red "$firstThree.$_  $($a.Status)"     }
 $counter++
  }

$sw_all.Elapsed
