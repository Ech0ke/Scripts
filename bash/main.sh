#!/bin/bash
systemUsers=()

while IFS=: read -r username _ _ _ _ _ _
do
    # Append the username to the array
    systemUsers+=("$username")
done < /etc/passwd

printf '%s\n' "${systemUsers[@]}"

while true; do
    read -p "Enter your username: " enteredUsername

    if [ -z "$enteredUsername" ]; then
        processes=($(ps aux))
        break
    elif [[ ! " ${systemUsers[@]} " =~ " $enteredUsername " ]]; then
        echo "User ${enteredUsername} not found."
        exit 1
    else
        processes=($(ps aux | grep "${enteredUsername}"))
        break
    fi
done



