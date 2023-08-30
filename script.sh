#!/bin/bash

encrypted_container=~/encrypted_container.luks
mount_point=~/mount_point

echo "LUKS Encrypted Folder Setup"

# Check if the encrypted container already exists
if [ -e "$encrypted_container" ]; then
    read -p "An encrypted container already exists. Do you want to proceed with setup? (yes/no): " proceed
    if [ "$proceed" != "yes" ]; then
        echo "Exiting setup."
        exit 0
    fi
else
    echo "Creating a new encrypted container..."
    dd if=/dev/zero of="$encrypted_container" bs=1M count=1024
    sudo cryptsetup luksFormat "$encrypted_container"
fi

# Open or close the encrypted container
while true; do
    echo "Select an option:"
    echo "1. Open the encrypted folder"
    echo "2. Close the encrypted folder"
    echo "3. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            sudo cryptsetup luksOpen "$encrypted_container" encrypted_folder
            sudo mount /dev/mapper/encrypted_folder "$mount_point"
            echo "Encrypted folder is now open and mounted at $mount_point"
            ;;
        2)
            sudo umount "$mount_point"
            sudo cryptsetup luksClose encrypted_folder
            echo "Encrypted folder is now closed"
            ;;
        3)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
