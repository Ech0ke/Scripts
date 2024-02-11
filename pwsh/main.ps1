$systemUsers = Get-WmiObject Win32_UserAccount | Select-Object -ExpandProperty Name

# # Prompt user to enter username
do {
    $enteredUsername = Read-Host -Prompt "Enter your username"
    
    if ([string]::IsNullOrWhiteSpace($enteredUsername)) {
        Write-Host "All users execute"
        $processes = Get-Process -IncludeUserName
        break
    }
    elseif (!($systemUsers -contains $enteredUsername)) {
        Write-Host "User '$enteredUsername' not found."
        return
    }
    else {
        $processes = Get-Process -IncludeUserName | Where UserName -match $enteredUsername
        break 
    }
} while ($true)

# Format the current date and time
$date = Get-Date -Format "yyyyMMdd"
$time = Get-Date -Format "HHmmss"

foreach ($process in $processes) {
    # Get process username
    $username = $process.UserName
    # Extract the portion after the backslash ("\")
    $splitUsername = $username -split '\\'
    $user = $splitUsername[-1]
    if ($systemUsers -contains $user) {
        $logFileName = "$user-process-log-$date-$time.txt"
        $logFilePath = "C:\$logFileName"
        "Process ID: $($process.Id), Process Name: $($process.Name)" | Out-File -FilePath $logFilePath -Append
    }
    else {
        $logFileName = "no-user-process-log-$date-$time.txt"
        $logFilePath = "C:\$logFileName"
        "Process ID: $($process.Id), Process Name: $($process.Name)" | Out-File -FilePath $logFilePath -Append
    }
}

