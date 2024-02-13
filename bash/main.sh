#!/bin/bash
systemUsers=()
directoryName="processLogs"

while IFS=: read -r username _ _ _ _ _ _
do
    # Append the username to the array
    systemUsers+=("$username")
done < /etc/passwd

printf '%s\n' "${systemUsers[@]}"

read -p "Enter your username: " enteredUsername

if [ -z "$enteredUsername" ]; then
    mapfile -t userProcesses < <(ps aux)
    break
elif [[ ! " ${systemUsers[@]} " =~ " $enteredUsername " ]]; then
    echo "User ${enteredUsername} not found."
    exit 1
else
    mapfile -t userProcesses < <(ps aux | grep "${enteredUsername}")
    break
fi

_date=$(date +"%Y%m%d")
_time=$(date +"%H%M%S")

create_logs() {
    local username="$1"
    local logFilename="${directoryName}/$username-process-log-$_date-$_time.log"
    echo "$_date" >> "$logFilename"
    echo "$_time" >> "$logFilename"
    echo "" >> "$logFilename"

    # Write processes to the log file
    for process in "${userProcesses[@]}"; do
    # Extract the username of the process owner from the process line
    processUsername=$(echo "$process" | awk '{print $1}')
    
    # Check if the username of the process owner matches the specified username
    if [ "$processUsername" == "$username" ]; then

        # get desired properties prom process details
        pid=$(echo "$process" | awk '{print $2}')
        name=$(echo "$process" | awk '{print $11}')
        startTime=$(echo "$process" | awk '{print $9}')

        # format and write properties to a file 
        echo "ID: $pid" >> "$logFilename"
        echo "Name: $name" >> "$logFilename"
        echo "Owner: $processUsername" >> "$logFilename"
        echo "Start time: $startTime" >> "$logFilename"
        echo "" >> "$logFilename"
    fi
done
    
    echo "Log file created for user $username: $logFilename"
}


# echo "\n"
# printf '%s\n' "${processes[@]}"

mkdir -p "$directoryName"

if [ -n "$enteredUsername" ]; then
    create_logs "$enteredUsername"
else
     echo "Creating logs for all system users:"
    for user in "${systemUsers[@]}"; do
        create_logs "$user"
    done
fi


