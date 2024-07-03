#!/bin/bash

# Ensure the script is run with a file as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

USER_FILE=$1
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Create necessary directories and set permissions
mkdir -p /var/secure
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE
touch $LOG_FILE

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

while IFS=';' read -r username groups; do
    # Ignore leading and trailing whitespaces
    username=$(echo $username | xargs)
    groups=$(echo $groups | xargs)

    # Skip empty lines
    [ -z "$username" ] && continue

    # Create personal group
    if ! getent group $username > /dev/null; then
        groupadd $username
        log_action "Created group: $username"
    else
        log_action "Group $username already exists"
    fi

    # Create user with personal group
    if ! id -u $username > /dev/null 2>&1; then
        useradd -m -g $username -s /bin/bash $username
        log_action "Created user: $username with personal group: $username"
    else
        log_action "User $username already exists"
    fi

    # Assign additional groups to user
    if [ -n "$groups" ]; then
        IFS=',' read -ra ADDITIONAL_GROUPS <<< "$groups"
        for group in "${ADDITIONAL_GROUPS[@]}"; do
            group=$(echo $group | xargs)
            if ! getent group $group > /dev/null; then
                groupadd $group
                log_action "Created group: $group"
            fi
            usermod -aG $group $username
            log_action "Added user $username to group: $group"
        done
    fi

    # Generate random password
    PASSWORD=$(openssl rand -base64 12)
    echo "$username:$PASSWORD" | chpasswd
    log_action "Set password for user: $username"

    # Store password securely
    echo "$username,$PASSWORD" >> $PASSWORD_FILE

done < $USER_FILE

log_action "User creation and setup completed."

echo "All users created and assigned to groups. See $LOG_FILE for details."
