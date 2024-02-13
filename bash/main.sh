#!/bin/bash

systemUsers=()
DIRECTORY_NAME="processLogs"

# Collect all system users
while IFS=: read -r username _ _ _ _ _ _
do
    # Append the username to the array
    systemUsers+=("$username")
done < /etc/passwd

read -p "Enter your username: " enteredUsername

# Collect running processes info based on enteredUsername value
if [ -z "$enteredUsername" ]; then
    mapfile -t userProcesses < <(ps aux)
elif [[ ! " ${systemUsers[@]} " =~ " $enteredUsername " ]]; then
    echo "User ${enteredUsername} not found."
    exit 1
else
    mapfile -t userProcesses < <(ps aux | grep "${enteredUsername}")
fi

# Define formatted date and time
DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")

create_logs() {
    local username="$1"
    local logFilename="${DIRECTORY_NAME}/$username-process-log-$DATE-$TIME.log"
    echo "$DATE" >> "$logFilename"
    echo "$TIME" >> "$logFilename"
    echo "" >> "$logFilename"

    # Write processes to the log file
    for process in "${userProcesses[@]}"; do
        # Extract the username of the process owner from the process line
        processUsername=$(echo "$process" | awk '{print $1}')

        # Check if the username of the process owner matches the specified username
        if [ "$processUsername" == "$username" ]; then

            # get desired properties prom process details
            pid=$(echo "$process" | awk '{print $2}')
            name=$(echo "$process" | awk '{n=split($11,a,"/"); print a[n]}') 
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

outputFileInfo() {
    local dirName="$1"
    local totalLines=0

    # for each file in a directory, output it's line count and add up total lines
    for file in "$dirName"/*; do
        fileLineCount=$(wc -l < "$file")
        echo "File: $file"
        echo "Line count: $fileLineCount"
        echo ""
        totalLines=$((totalLines + fileLineCount))
    done

    echo ""
    echo "Total line count: $totalLines"
}

outputFileContents() {
    local username="$1"
    cat "$DIRECTORY_NAME/$username-process-log-$DATE-$TIME.log"
}

mkdir -p "$DIRECTORY_NAME"

# create log files just for the user or for all system users based on username input
if [ -n "$enteredUsername" ]; then
    create_logs "$enteredUsername"
else
    for user in "${systemUsers[@]}"; do
        create_logs "$user"
    done
fi

outputFileInfo "$DIRECTORY_NAME"

# Print file contents if username was provided
if [ -n "$enteredUsername" ]; then
    echo ""
    echo "START OF THE FILE"
    echo "-------------------------------------------------------------------"
    outputFileContents "$enteredUsername"
    echo "-------------------------------------------------------------------"
    echo "END OF THE FILE"
fi

read -p "Press enter to continue ..."

# Delete all files and directory
rm -rf "$DIRECTORY_NAME"