# Project: Post Install System

## Overview
The Post Install System is a comprehensive automation tool developed by OPNLAB Development. It is designed to streamline the post-installation configuration of Linux servers. By leveraging a modular Bash-based architecture and an interactive `whiptail` interface, it allows system administrators to define, generate, and execute configuration scripts on remote servers efficiently.

## Core Objectives
*   **Efficiency**: Reduce the time required to configure fresh server installations.
*   **Consistency**: Ensure all servers are configured with the same baseline settings and security standards.
*   **Simplicity**: Provide a user-friendly terminal interface (TUI) that abstracts complex command-line operations.

## Technical Architecture
The system is built as a lightweight, portable Bash application.
*   **Language**: Bash Shell Scripting (`#!/usr/bin/bash`).
*   **Interface**: `whiptail` is used to render interactive menus, dialogs, and checklists in the terminal.
*   **Package Management**: Currently optimized for Debian-based systems using `apt` for package updates and installation.
*   **Script Generation**: The core engine dynamically assembles bash scripts based on user selections, which can then be transferred and executed on target machines.

## Key Features

### 1. Interactive Configuration Interface
Users are guided through a series of menus to select desired configurations.
*   **License Agreement**: Displays copyright and license information upon startup.
*   **Menu System**: Hierarchical menu structure to navigate different configuration categories (e.g., "Basic configuration").

### 2. Automated System Updates
*   **Update & Upgrade**: Automatically refreshes package lists (`apt update`) and upgrades installed packages (`apt upgrade -y`) to ensure the system is up-to-date with the latest security patches.

### 3. Modular Capability
The system is designed to be extensible. While currently featuring basic configuration and updates, the architecture supports adding modules for:
*   User and Group Management.
*   SSH Key Configuration and Hardening.
*   Firewall Setup (e.g., UFW, iptables).
*   Service Installation (Web servers, Databases, etc.).

## Prerequisites
To run the Post Install System, the host environment requires:
*   **Operating System**: Linux (Debian/Ubuntu recommended for full compatibility).
*   **Dependencies**: `whiptail` must be installed.
*   **Permissions**: Root or sudo privileges are required for system modifications (package installation, updates).

## Usage Workflow
1.  **Launch**: Start the application via the command line.
2.  **Review License**: Accept the license terms displayed in the text box.
3.  **Select Options**: Use the arrow keys and Enter to navigate the menu and choose "Basic configuration" or other available options.
4.  **Execution**: The system executes the selected tasks (e.g., updating the system).

## Roadmap
*   Implementation of remote execution via SSH.
*   Logging and reporting of installation status.
*   Support for additional Linux distributions (RHEL/CentOS/Fedora).
