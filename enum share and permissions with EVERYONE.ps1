
$dcred = get-credential -UserName KTEHNIKA\milan -Message "Enter credentials for MILAN" #

#$ktservers = 'wsus','vmm'
$ktservers = Get-ADComputer -Properties OperatingSystem -Filter "OperatingSystem -like '*server*'" | select Name
foreach ($server in $ktservers)
{

$Error.clear()
$server = $server.Name

$query = "select * from win32_pingstatus where address = '$server'"
$result = Get-WmiObject -query $query
if ($result.protocoladdress) 
{

#$shares = gwmi -ComputerName $ou_server -Class Win32_Share -ErrorAction SilentlyContinue #| where {$_.Description -notmatch "Default|Remote|Logon|Printer|Fujitsu" }
$shares = gwmi -ComputerName $server -Class Win32_Share -ErrorAction SilentlyContinue -Credential $dcred | where {$_.Description -notmatch "Remote IPC" }
if ($Error)
    {	
	write-host $server "Online but RPC UNAVAILABLE!" 
	}
			  
else { 
	 #RPC is Available, continue with WMI 
	 foreach ($sh in $shares)
	    {
	    $acl_path = "\\"+$server+"\"+$sh.Name
	    #Write-Host $sh.Name $acl_path
	    $a = (Get-Acl $acl_path).AccessToString
	    
	        if($a -like "*everyone*")
            {
            $acl_path
            $a | Select-String -Pattern 'EVERYONE'
            Write-Host `n
            #write-host $a #$acl_path
            }
	    }
	Write-Host `n
	
	}
	
}

else 	
	{

	Write-Host $server "unavailable!"
	   
	}
	
}

