# Get username from script parameters
param(
    [string]$enteredUsername
)

# Get list of system users
$systemUsers = Get-WmiObject Win32_UserAccount | Select-Object -ExpandProperty Name
    
if ([string]::IsNullOrWhiteSpace($enteredUsername)) {
    $processes = Get-Process -IncludeUserName
}
elseif (!($systemUsers -contains $enteredUsername)) {
    Write-Host "User '$enteredUsername' not found."
    return
}
else {
    $processes = Get-Process -IncludeUserName | Where UserName -match $enteredUsername
}

# Format the current date and time
$date = Get-Date -Format "yyyyMMdd"
$time = Get-Date -Format "HHmmss"

foreach ($process in $processes) {
    # Get process username
    $username = $process.UserName

    # Extract the portion after the backslash ("\")
    $splitUsername = $username -split '\\'
    $user = $splitUsername[-1]

    # Write process info into according files based on username
    if ($systemUsers -contains $user) {
        $logFileName = "$user-process-log-$date-$time.txt"
        $logFilePath = "C:\$logFileName"
        "Process ID: $($process.Id)`nProcess Name: $($process.Name)`nCPU(s): $($process.CPU)`nPath: $($process.Path)`n`n" | Out-File -FilePath $logFilePath -Append
    }
    else {
        $logFileName = "no-user-process-log-$date-$time.txt"
        $logFilePath = "C:\$logFileName"
        "Process ID: $($process.Id)`nProcess Name: $($process.Name)`nCPU(s): $($process.CPU)`nPath: $($process.Path)`n`n" | Out-File -FilePath $logFilePath -Append
    }
}

# Open all the log files created by the script with Notepad
$logFiles = Get-ChildItem -Path "C:\" -Filter "*process-log-$date-$time.txt"
foreach ($logFile in $logFiles) {
    Start-Process -FilePath "notepad.exe" -ArgumentList $logFile.FullName
}

# Pause the script execution
Write-Host "Press Enter to continue..."
Read-Host

# Close notepad
Get-Process -Name "notepad" | Stop-Process -Force


