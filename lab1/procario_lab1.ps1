<# Author: Chris Procario
   Professor: Bill Stackpole
   Assignment: Lab 01, Windows PowerShell Script
   Section: CSEC.475.01
#>

<# This script is a Windows artifact collection script; it displays various information from
   the machine and prints them out on the powershell command line for the user to analyze. 
   I do not know PowerShell and this was the first script I ever wrote. I do not know if this is
   proper coding standards, but this is what I was able to put together given the time I had to do this
#>

# GetTime, gets the current time, timezone, and PC uptime
Function GetTime(){

	$time = "{0:h:mm:ss tt }" -f (get-date)
	$timeZone = Get-WMIObject -class Win32_TimeZone -ComputerName .
	$timeZoneOutput = $timezone.Description
	$timeOutput = "Current Time: " + $time + $timeZoneOutput
	Write-Output $timeOutput
	
	$os = Get-WmiObject win32_operatingsystem
	$uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
	$uptimeOutput = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes" 
	Write-Output $uptimeOutput
}

# GetVersion, prints the version of windows with major, minor, build, and revision number
Function GetVersion(){

	$version = "Windows Version: " + (Get-WmiObject -class Win32_OperatingSystem).Caption + (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.FileVersion 
	Write-Output $version
}

# HardWareSpecs, Lists the CPU specs, the RAM amount, and the filesystems on the machine
Function HardwareSpecs(){

	$CPU = Get-WmiObject Win32_Processor | select Architecture,Caption, Name,Version,Manufacturer,ProcessorType
	Write-Output $CPU

	$RAM = (Get-WMIObject -class Win32_PhysicalMemory -ComputerName . | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)})
	Write-Output "Amount of RAM: $RAM GB " `
	
	$HDD = Get-PSDrive -PSProvider 'FileSystem'
	Write-Output $HDD
}

Function DomainController(){

	
	
}

Function HostAndDomain(){

}

# ListUsers, list the users registered on the machine
Function ListUsers(){

	$users = gwmi win32_userprofile | select localpath, sid
	Write-Output $users
}

# ListTasks, list all of the scheduled tasks on the box
Function ListTasks(){

	$tasks = Get-ScheduledTask
	Write-Output $tasks
}

# Network - List the ARP table, IPv4 and IPv6
Function Network(){

	$ARP = Get-NetNeighbor -AddressFamily IPv4,IPv6
	Write-Output $ARP
}

# InstalledSoftware, lists the name of the installed software on the machine
Function InstalledSoftware(){
	
	$software = Get-WmiObject -class Win32_Product | Select Name
	Write-Output $software

}

# ProcessList, list all of the processes on the machine 
Function ProcessList(){
	
	$processes = Get-Process
	Write-Output $processes
}

# DriverList, lists all of the drivers on the box
Function DriverList(){

	$drivers = driverquery.exe
	Write-Output $drivers
}

# DownloadsList, lists all of the downloads on the 'student' account
Function DownloadsList(){
	
	$downloads = Get-ChildItem -Path C:\Users\student\Downloads
	Write-Output $downloads
}

# DocumentsList, lists all of the documents on the 'student' account
Function DocumentsList(){
	$docs = Get-ChildItem -Path C:\Users\student\Documents
	Write-Output $docs
}

Function Main(){
	GetTime
	GetVersion
	HardwareSpecs
	ListUsers
	ListTasks
	Network
	InstalledSoftware
	ProcessList
	DriverList
	DownloadsList
	DocumentsList
	
	$input = Read-Host -Promp 'Export to CSV? (Y/N)'
	if( $input -eq "Y"){
		$email = Read-Host -Prompt 'Enter email'
		$script = $PSScriptRoot+"\procario_lab1.ps1"
		#Couldn't get CSV to export, therefore email did not work.
		#&$script | Export-Csv -path "C:\Users\student\Desktop\lab1.csv"
		#Send-MailMessage -To "$email" -From "$email" -Subject "lab1CSV" -Body "CSV attached for WinForensics Lab1" -Attachments "C:\Users\student\Desktop\lab1.csv" -SmtpServer "rit.edu"
	}
	
}

Main

