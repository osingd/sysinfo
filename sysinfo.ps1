$outputFile = "c:\buildArtifacts\systeminfo.txt"
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$hostname = $env:COMPUTERNAME
$cpuName = (Get-CimInstance -ClassName Win32_Processor).Name
$ramSize = "{0:N2} GB" -f ((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$diskSize = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | Measure-Object -Property Size -Sum).Sum / 1GB
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "Loopback"}).IPAddress -join ", "
$output = @"
Date: $currentDate
Hostname: $hostname
Cpu name: $cpuName
Memory size: $ramSize
Disk size: $("{0:N2} GB" -f $diskSize)
Ip address: $ipAddress
"@

mkdir c:\buildArtifacts
echo Azure-Image-Builder-Was-Here  > c:\buildArtifacts\systeminfo.txt

$output | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "All information is saved in the file: $outputFile"