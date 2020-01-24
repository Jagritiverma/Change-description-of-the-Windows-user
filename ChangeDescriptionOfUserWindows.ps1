Import-Module ActiveDirectory
#Get the computer name of a user
$computer = $env:COMPUTERNAME

#Use WMI object to get the Model Name of the system
$ModelName = (Get-WMIObject -ComputerName $computer  Win32_ComputerSystemProduct).Name

#Use WMI object to get the Service Tag of the system
$identifyingNumber = (Get-WMIObject -ComputerName $computer  Win32_ComputerSystemProduct).identifyingNumber

#Get the Domain Name in which user is present
$UserDnsDomain = Get-ChildItem Env:userdnsdomain

#Get the user's ID
$UserName = $env:USERNAME

#Get user's last login date and user name
$user = Get-ADComputer -Identity $computer -Properties “LastLogonDate" -server $UserDnsDomain.Value
$LastAccountUserName = $user.SamAccountName
$LastLoginDate =  $user.LastLogonDate
$date = ($LastLoginDate -split ' ')[0]

#Set the variables to the description of the user
Set-ADComputer $computer –Description “$ModelName,$identifyingNumber,$LastAccountUserName,$date” 
Write-Host "Successful!" 