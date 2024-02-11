$users = Get-WmiObject Win32_UserAccount | Select-Object -ExpandProperty Name

# Prompt user to enter username
do {
    $username = Read-Host -Prompt "Enter your username"
    
    if ([string]::IsNullOrWhiteSpace($username)) {
        Write-Host "All users execute"
        break
    }
    elseif (!($users -contains $username)) {
        Write-Host "User '$username' not found."
        return
    }
    else {
        break 
    }
} while ($true)


Write-Host "Bye $username"