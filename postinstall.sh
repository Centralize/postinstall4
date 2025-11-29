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

function add_user {
    USERNAME=$(whiptail --inputbox "Enter new username:" 10 60 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ] && [ ! -z "$USERNAME" ]; then
        PASSWORD=$(whiptail --passwordbox "Enter password for $USERNAME:" 10 60 3>&1 1>&2 2>&3)
        if [ $? -eq 0 ]; then
             useradd -m -s /bin/bash "$USERNAME"
             echo "$USERNAME:$PASSWORD" | chpasswd
             if (whiptail --yesno "Add $USERNAME to sudo group?" 10 60); then
                 usermod -aG sudo "$USERNAME"
             fi
             whiptail --msgbox "User $USERNAME created." 10 60
        fi
    fi
}

function user_config_menu {
    while true; do
        USER_CHOICE=$(whiptail --title "User Management" --menu "Choose an option" 25 78 16 \
        "Add User" "    Create a new user" \
        "Back" "    Return to main menu" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case $USER_CHOICE in
                "Add User")
                    add_user
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

function configure_firewall {
    if (whiptail --yesno "Install and enable UFW (Uncomplicated Firewall)?" 10 60); then
        apt-get install -y ufw
        ufw allow ssh
        ufw allow 80
        ufw allow 443
        ufw default deny incoming
        ufw default allow outgoing
        ufw --force enable
        whiptail --msgbox "UFW enabled. SSH, HTTP(80), HTTPS(443) allowed." 10 60
    fi
}

function ssh_hardening {
    if (whiptail --yesno "Disable Root Login via SSH?" 10 60); then
        sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
        # Ensure it exists if it wasn't there
        if ! grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
             echo "PermitRootLogin no" >> /etc/ssh/sshd_config
        fi
        systemctl restart sshd
        whiptail --msgbox "Root login disabled." 10 60
    fi
}

function network_config_menu {
    while true; do
        NET_CHOICE=$(whiptail --title "Network Configuration" --menu "Choose an option" 25 78 16 \
        "Firewall Setup" "    Install and configure UFW" \
        "SSH Hardening" "    Secure SSH configuration" \
        "Back" "    Return to main menu" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case $NET_CHOICE in
                "Firewall Setup")
                    configure_firewall
                    ;;
                "SSH Hardening")
                    ssh_hardening
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

function install_software {
    SOFTWARE=$1
    if (whiptail --yesno "Install $SOFTWARE?" 10 60); then
        apt-get install -y "$SOFTWARE"
        whiptail --msgbox "$SOFTWARE installed." 10 60
    fi
}

function software_config_menu {
    while true; do
        SOFT_CHOICE=$(whiptail --title "Software Installation" --menu "Choose software to install" 25 78 16 \
        "Nginx" "    Web Server" \
        "Apache2" "    Web Server" \
        "MariaDB" "    Database Server" \
        "Docker" "    Container Runtime" \
        "Back" "    Return to main menu" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case $SOFT_CHOICE in
                "Nginx")
                    install_software "nginx"
                    ;;
                "Apache2")
                    install_software "apache2"
                    ;;
                "MariaDB")
                    install_software "mariadb-server"
                    ;;
                "Docker")
                    install_software "docker.io"
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
                    network_config_menu
                    ;;
                "Users")
                    user_config_menu
                    ;;
                "Software")
                    software_config_menu
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
