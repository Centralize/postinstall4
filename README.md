# Post Install System (OPNLAB PostInstall)

The Post Install System is a comprehensive automation tool developed by OPNLAB Development. It is designed to streamline the post-installation configuration of Linux servers. By leveraging a modular Bash-based architecture and an interactive `whiptail` interface, it allows system administrators to define, generate, and execute configuration scripts on remote servers efficiently.

## Features

- **Interactive Configuration Interface**: A user-friendly terminal-based menu system (TUI) powered by `whiptail`.
- **Automated System Updates**: Automatically refreshes package lists and upgrades installed packages.
- **Basic Configuration**: Quickly set system hostname and timezone.
- **Modular Architecture**: Designed to be extensible with future modules for users, SSH, firewall, and software installation.
- **Auto-Dependency Resolution**: Automatically checks for and installs `whiptail` if it is missing on Debian-based systems.

## Prerequisites

To run this tool, you need:

- **Operating System**: A Linux distribution (Debian/Ubuntu are currently best supported).
- **Permissions**: Root privileges (`sudo` or direct root access) are required to install packages and modify system settings.
- **Dependencies**: `whiptail` (the script attempts to auto-install this if missing).

## Installation & Usage

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/Centralize/postinstall4.git
    cd postinstall4
    ```

2.  **Make the Script Executable**
    ```bash
    chmod +x postinstall.sh
    ```

3.  **Run the Script**
    Because the script performs system modifications, it must be run with root privileges:
    ```bash
    sudo ./postinstall.sh
    ```

## Usage Guide

Upon launching the application, you will be presented with a License Agreement. After accepting it, the Main Menu offers the following options:

*   **Update System**: Runs `apt update` and `apt upgrade -y` to bring your system up to date.
*   **Basic configuration**: Opens a sub-menu to configure:
    *   **Hostname**: Set the computer's network name.
    *   **Timezone**: Configure the system timezone (e.g., `UTC`, `America/New_York`).
*   **Network**: (Coming Soon) Configure network settings.
*   **Users**: (Coming Soon) Manage users and groups.
*   **Software**: (Coming Soon) Install common software packages.
*   **Exit**: Quit the application.

## Documentation

For more detailed information about the project's goals, architecture, and roadmap, please refer to the following files:

- [PROJECT.md](PROJECT.md): Detailed project overview, architecture, and roadmap.
- [TASKS.md](TASKS.md): Detailed task list and development progress.
- [DESCRIPTION.md](DESCRIPTION.md): Brief description of the project.

## License

(C) 2025 by OPNLAB Development. All rights reserved.
