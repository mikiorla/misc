
$dcred = get-credential -UserName KTEHNIKA\milan -Message "Enter credentials for MILAN" #

$a = New-Object -comobject Excel.Application
$a.visible = $True
#$a.DisplayFullScreen=$true
$b = $a.Workbooks.Add()
#$b.WorkSheets.Item(1).Delete()

#$ktservers = 'wsus','vmm'
$ktservers = Get-ADComputer -Properties OperatingSystem -Filter "OperatingSystem -like '*server*'" | select Name
foreach ($server in $ktservers)
{

$Error.clear()
$server = $server.Name
$i=2
$c = $b.Worksheets.Add()
$c.Name = $server

$c.Cells.Item(1,1) = "Server"
$c.Cells.Item(1,2) = "Share"
$c.Cells.Item(1,3) = "Access"
$c.Columns.Item('A').ColumnWidth = 15
$c.Columns.Item('B').ColumnWidth = 35
$c.Columns.Item('C').ColumnWidth = 70
$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True

$query = "select * from win32_pingstatus where address = '$server'"
$result = Get-WmiObject -query $query
if ($result.protocoladdress) 
{

#$shares = gwmi -ComputerName $ou_server -Class Win32_Share -ErrorAction SilentlyContinue #| where {$_.Description -notmatch "Default|Remote|Logon|Printer|Fujitsu" }
$shares = gwmi -ComputerName $server -Class Win32_Share -ErrorAction SilentlyContinue -Credential $dcred | where {$_.Description -notmatch "Remote IPC" }
if ($Error)
    {	
	#write-host $ou_server "Online but RPC UNAVAILABLE!" 
	$c.Cells.Item($i,2) = "RPC nedostupan!"
    [string]$c.Name = $server+" rpcErr"
	$i++
	}
			  
else { 
	 #RPC is Available, continue with WMI 
	 foreach ($sh in $shares)
	    {
	    $acl_path = "\\"+$server+"\"+$sh.Name
	    #Write-Host $sh.Name $acl_path
	    $a = (Get-Acl $acl_path).AccessToString
	    $c.Cells.Item($i,2) = $sh.Name
	    $c.Cells.Item($i,3) = $a
	    $i++
            if($a -like "*everyone*")
            {
            write-host $acl_path $a
            }
	    }
	#Write-Host `n
	
	}
	
}

else 	
	{
	#Write-Host $Ou_server "unavailable!"
	[string]$c.Name = $server+" offline"
    $c.Cells.Item($i,2) = "Nedostupan!"
    $i++
	}
	
}

$b.Worksheets.Item("Sheet1").Delete()