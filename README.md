
# User and Group Creation Script

This repository contains a bash script, `create_users.sh`, designed to automate the creation of users and groups based on a provided text file. The script sets up home directories, generates random passwords, logs actions, and stores passwords securely.

## Prerequisites

- **Ubuntu Machine**: The script is intended to run on an Ubuntu machine.
- **Root or Sudo Access**: Ensure you have root or sudo access to execute the script.

## Files in the Repository

- `create_users.sh`: The main bash script for creating users and groups.
- `README.md`: This readme file explaining the usage and details of the script.

## Usage

1. **Prepare the Text File**:
   Create a text file containing the usernames and group names. Each line should be formatted as `user;groups` (e.g., `light; sudo,dev,www-data`). For example:
   ```text
   light; sudo,dev,www-data
   idimma; sudo
   mayowa; dev,www-data
   ```

2. **Make the Script Executable**:
   Ensure the script has executable permissions.
   ```bash
   chmod +x create_users.sh
   ```

3. **Run the Script**:
   Execute the script with the text file as an argument.
   ```bash
   sudo ./create_users.sh user_list.txt
   ```

## Script Explanation

The `create_users.sh` script performs the following tasks:

1. **Input Validation**: Checks if a file is provided as an argument.
2. **File and Directory Setup**: Creates necessary directories and files with appropriate permissions.
3. **Logging Function**: Logs actions with timestamps to `/var/log/user_management.log`.
4. **Reading and Processing the Input File**: Reads the text file line by line and processes the user and group information.
5. **User and Group Creation**: Creates users and personal groups, assigns additional groups.
6. **Generating and Storing Passwords**: Generates random passwords and stores them securely in `/var/secure/user_passwords.txt`.

## Log and Password Files

- **Log File**: `/var/log/user_management.log` contains a log of all actions performed by the script.
- **Password File**: `/var/secure/user_passwords.txt` stores the generated passwords securely and is readable only by the file owner.

## Verification and Testing

To verify the correct execution of the script:

1. **Check Users and Groups**:
   ```bash
   getent passwd light
   getent passwd idimma
   getent passwd mayowa
   getent group sudo
   getent group dev
   getent group www-data
   ```

2. **Check Home Directories**:
   ```bash
   ls -ld /home/light
   ls -ld /home/idimma
   ls -ld /home/mayowa
   ```

3. **Check Password File**:
   ```bash
   sudo cat /var/secure/user_passwords.txt
   ```

4. **Check Log File**:
   ```bash
   cat /var/log/user_management.log
   ```

## Cleanup (Optional)

To remove the created users and groups, use the following commands:
```bash
sudo userdel -r light
sudo userdel -r idimma
sudo userdel -r mayowa
sudo groupdel light
sudo groupdel idimma
sudo groupdel mayowa
sudo groupdel dev
sudo groupdel www-data
```


