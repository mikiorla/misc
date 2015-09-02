
$ErrorActionPreference = "SilentlyContinue"
$a = New-Object -comobject Excel.Application
$a.visible = $True

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

#$c.Name = "DG is set"

$c.Columns.Item('A').ColumnWidth = 15
$c.Columns.Item('B').ColumnWidth = 28
$c.Columns.Item('C').ColumnWidth = 15
$c.Columns.Item('D').ColumnWidth = 15

$c.Cells.Item(1,1) = "Server"
$c.Cells.Item(1,2) = "Status"
$c.Cells.Item(1,3) = "IP Address"
$c.Cells.Item(1,4) = "DNS"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True
$d.EntireColumn.AutoFit($True)

#$servers = Get-Content "C:\_scripts\Servers.txt"

$servers = Get-ADComputer -Properties OperatingSystem -Filter {OperatingSystem -like '*server*'} | Select NAme | sort Name #ide uz $computer = $computer.NAme

$i=2
$s=1
$cc=1

foreach ($computer in $servers) 
{ 

$computer = $computer.NAme
	
$c.Cells.Item($i,1)=$computer

# check the machine is pingable
	
$query = "select * from win32_pingstatus where address = '$computer'"
$result = Get-WmiObject -query $query

if ($result.protocoladdress) 
{
# Status Online

#check if RPC is available

$Error.clear()
$os = gwmi Win32_OperatingSystem -computername $computer -ErrorAction SilentlyContinue
if ($Error[0]){

	#RPC is Unavailable!
	$c.Cells.Item( $i,2)="Online but RPC UNAVAILABLE!" 
	$i++
			  }
			  
else 
{ 

	#RPC is Available, continue with WMI 
	$c.Cells.Item( $i,2)="Online, AVAILABLE!"
		
	$netadapterquery = "select * from Win32_NetworkAdapterConfiguration where IPEnabled = True"
	$netadapter = Get-WmiObject -query $netadapterquery -ComputerName $computer 
	
   
	
	foreach ($objIP in $netadapter) #za svaki adapter
	{

        
        if (!($objIP.ServiceName -like "VMnetAdapter") -and !($objIP.IPAddress -like "0.0.0.0" ))
        #if (!($objIP.ServiceName -like "VMnetAdapter") -and !($objIP.IPAddress -like "0.0.0.0" ) -and ($objIP.DefaultIPGateway)) #$c.Name = "DG is set"
	     	{
                     
            
            $c.Cells.Item($i,3)= $objIP.IPAddress[0]
            foreach ($dnsip in $objIP.DNSServerSearchOrder)
			{
             $c.Cells.Item($i,4)= $dnsip
			 $i++
            
            }
	  	
					
			 }
	 	
	} 

}		 
	

}



 else 
  { $c.Cells.Item( $i,2)= "Not Responding"
  $i++
	
  }
 
 
 
 
 }
 

