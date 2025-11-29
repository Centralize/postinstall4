# Project Tasks: Post Install System

This document outlines the detailed task list for the development and enhancement of the Post Install System, based on the objectives and roadmap defined in `PROJECT.md`.

## Phase 1: Core Framework & Interface
*   [x] **Project Setup**
    *   [x] Initialize Git repository structure.
    *   [x] Create standard file headers with copyright and license info.
    *   [x] Implement input argument parsing (if necessary).
*   [x] **Dependency Check**
    *   [x] Write a function to check if `whiptail` is installed.
    *   [x] Implement auto-installation of `whiptail` or exit with error if missing.
    *   [x] Verify root/sudo privileges at startup.
*   [x] **UI Implementation**
    *   [x] **License Display**: Create a `license` function using `whiptail --textbox` to show terms.
    *   [x] **Main Menu**: Develop the main navigation loop using `whiptail --menu`.
    *   [x] **Sub-menus**: Create placeholder structures for sub-categories (Network, Users, Software).

## Phase 2: Core Modules Implementation
*   [x] **System Update Module**
    *   [x] Create `runUpdate` function.
    *   [x] Implement `apt update` and `apt upgrade -y` logic.
    *   [x] Add error handling for network or lock issues during update.
*   [x] **Basic Configuration Module**
    *   [x] Define "Basic Configuration" scope (e.g., hostname, timezone).
    *   [x] Implement functions to set hostname.
    *   [x] Implement functions to set timezone.

## Phase 3: Advanced Modules (Modular Capability)
*   [x] **User & Group Management**
    *   [x] Create interface to input new username and password.
    *   [x] Implement logic to add users and add them to `sudo` group.
    *   [ ] Implement SSH key addition for the new user.
*   [x] **SSH Hardening**
    *   [x] Create module to modify `/etc/ssh/sshd_config`.
    *   [x] Add options to disable root login.
    *   [ ] Add options to disable password authentication (keys only).
*   [x] **Firewall Setup**
    *   [x] Implement UFW (Uncomplicated Firewall) installation and enablement.
    *   [x] Create default ruleset (Allow SSH, Deny Incoming, Allow Outgoing).
    *   [x] Add options to open specific ports (80, 443).
*   [x] **Service Installation**
    *   [x] Create a selection menu for common services (Nginx, Apache, MySQL/MariaDB, Docker).
    *   [x] Implement installation scripts for each service.

## Phase 4: Script Generation Engine
*   [ ] **Engine Logic**
    *   [ ] Design the logic to append selected configuration commands to a temporary bash script file instead of direct execution (toggleable mode).
    *   [ ] Ensure generated scripts are standalone and executable.
*   [ ] **Validation**
    *   [ ] Verify generated scripts against `shellcheck` (if available).

## Phase 5: Remote Execution (Roadmap)
*   [ ] **SSH Integration**
    *   [ ] Add menu option to define target remote server (IP/Hostname, User, Port).
    *   [ ] Implement SSH key exchange or password prompt handling.
*   [ ] **Deployment**
    *   [ ] Implement `scp` or `rsync` logic to transfer the generated script to the remote server.
    *   [ ] Execute the script remotely via `ssh`.

## Phase 6: Cross-Platform Support & Logging (Roadmap)
*   [ ] **OS Detection**
    *   [ ] Implement logic to detect `/etc/os-release`.
    *   [ ] Add conditional logic for package managers ( `apt` vs `dnf`/`yum`).
*   [ ] **Logging**
    *   [ ] Implement a logging function that writes to `/var/log/postinstall.log`.
    *   [ ] Add timestamping to log entries.
    *   [ ] Create a summary report at the end of execution.

## Phase 7: Quality Assurance
*   [ ] **Testing**
    *   [ ] Test in a VM environment (Debian/Ubuntu).
    *   [ ] Verify UI navigation flows.
    *   [ ] Validate that all package installations complete successfully.
*   [ ] **Documentation**
    *   [ ] Maintain `DESCRIPTION.md` and `PROJECT.md` updates.
    *   [ ] Create a `CONTRIBUTING.md` for developer guidelines.
