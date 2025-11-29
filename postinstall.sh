#!/usr/bin/bash

# (C) 2025 by OPNLAB Development. All rights reserved.

# VARS
APPTITLE="OPNLAB PostInstall"
COPYRIGHT="(C) 2025 by OPNLAB Development. All rights reserved."
set -x

function license {
	echo $COPYRIGHT > license
	whiptail --textbox license 12 80
}

function menu {
	whiptail --title "$APPTITLE" --menu "Choose an option" 25 78 16 \
	"Basic configuration" "    Configure the most basic settings."
}

function runUpdate {
	apt update; apt upgrade -y;
}

license
menu
