#!/usr/bin/bash

# (C) 2025 by OPNLAB Development. All rights reserved.

# VARS
APPTITLE="OPNLAB PostInstall"
COPYRIGHT="(C) 2025 by OPNLAB Development. All rights reserved."

# Check for Root Privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Check and Install Dependencies
if ! command -v whiptail &> /dev/null; then
    echo "whiptail could not be found. Attempting to install..."
    apt-get update && apt-get install -y whiptail
    if [[ $? -ne 0 ]]; then
        echo "Failed to install whiptail. Please install it manually."
        exit 1
    fi
fi

function license {
    echo "$COPYRIGHT" > /tmp/license_agreed
    whiptail --title "License Agreement" --textbox /tmp/license_agreed 12 80
    rm -f /tmp/license_agreed
}

function set_hostname {
    CURRENT_HOSTNAME=$(cat /etc/hostname)
    NEW_HOSTNAME=$(whiptail --inputbox "Enter new hostname:" 10 60 "$CURRENT_HOSTNAME" 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ] && [ ! -z "$NEW_HOSTNAME" ]; then
        hostnamectl set-hostname "$NEW_HOSTNAME"
        whiptail --msgbox "Hostname set to $NEW_HOSTNAME" 10 60
    fi
}

function set_timezone {
    CURRENT_TIMEZONE=$(cat /etc/timezone)
    NEW_TIMEZONE=$(whiptail --inputbox "Enter new timezone (e.g., UTC, America/New_York):" 10 60 "$CURRENT_TIMEZONE" 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ] && [ ! -z "$NEW_TIMEZONE" ]; then
        if timedatectl set-timezone "$NEW_TIMEZONE" 2>/dev/null; then
             whiptail --msgbox "Timezone set to $NEW_TIMEZONE" 10 60
        else
             whiptail --msgbox "Invalid timezone or error setting timezone." 10 60
        fi
    fi
}

function basic_config_menu {
    while true; do
        CONFIG_CHOICE=$(whiptail --title "Basic Configuration" --menu "Choose an option" 25 78 16 \
        "Hostname" "    Set system hostname" \
        "Timezone" "    Set system timezone" \
        "Back" "    Return to main menu" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case $CONFIG_CHOICE in
                "Hostname")
                    set_hostname
                    ;;
                "Timezone")
                    set_timezone
                    ;;
                "Back")
                    break
                    ;;
            esac
        else
            break
        fi
    done
}

function main_loop {
    while true; do
        CHOICE=$(whiptail --title "$APPTITLE" --menu "Choose an option" 25 78 16 \
        "Update System" "    Update and Upgrade System" \
        "Basic configuration" "    Configure the most basic settings." \
        "Network" "    Network configuration." \
        "Users" "    User management." \
        "Software" "    Software installation." \
        "Exit" "    Exit the application." 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            case $CHOICE in
                "Update System")
                    runUpdate
                    ;;
                "Basic configuration")
                    basic_config_menu
                    ;;
                "Network")
                    whiptail --msgbox "Network configuration not implemented yet." 10 60
                    ;;
                "Users")
                    whiptail --msgbox "User management not implemented yet." 10 60
                    ;;
                "Software")
                    whiptail --msgbox "Software installation not implemented yet." 10 60
                    ;;
                "Exit")
                    break
                    ;;
            esac
        else
            break
        fi
    done
}

function runUpdate {
    if command -v apt &> /dev/null; then
        if (whiptail --title "System Update" --yesno "Do you want to update the system now?" 10 60); then
            apt update && apt upgrade -y
            whiptail --msgbox "System update complete." 10 60
        fi
    else
        whiptail --msgbox "apt package manager not found. Update skipped." 10 60
    fi
}

license
main_loop
