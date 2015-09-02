
$path = "D:\_scripts\Scripts\DNS"
$files = Get-ChildItem -Path $path -File 

foreach ($file in $files)

{
$file.FullName
$oldname = $file.Name
$newName = 'DNS__'+$oldname
Rename-Item -Path $file.FullName -NewName $newName -Verbose #-WhatIf
}

