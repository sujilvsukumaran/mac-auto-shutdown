
# Idle Shutdown Script

![Header](https://i.imgur.com/jo8QAaz.png)

[![Supported Platforms](https://img.shields.io/badge/Supported%20Platforms-macOS-lightgrey)](https://developer.apple.com/macos/)
![Shell](https://img.shields.io/badge/Shell-Scripting-orange)

A shell script-based utility for macOS to automatically shut down the system after a specified idle timeout. Includes functionality for auto-start on boot, logging, and force shutdown.

## Features

- Automatically shuts down the macOS system after a user-defined idle timeout.
- Auto-starts after installation and system reboot using LaunchDaemon.
- Logs actions and status to a designated log file for easy monitoring.
- Includes an uninstall script for clean removal of all installed components.
- Force shutdown ensures the system shuts down even if blocked by applications or services.

---

## Built With

- **Shell Scripting** - Core functionality
- **LaunchDaemon** - For auto-start and keeping the script alive
- **macOS Logger** - To log events and status updates

---

## Prerequisites

- **macOS** (tested on macOS Monterey and later)
- Administrative privileges (`sudo` access) to install and manage the script
- Basic understanding of terminal commands (helpful but not required)

---

## Directory Structure

```
idle_shutdown_project/
├── installer_root/               # Root directory for installer files
│   ├── usr/
│   │   └── local/
│   │       ├── bin/              # Directory for shell scripts
│   │       │   ├── idle_shutdown.sh        # Main script
│   │       │   └── uninstall_idleshutdown.sh  # Uninstall script
│   │       └── etc/              # Directory for configuration files
│   │           └── idle_shutdown.conf      # Configuration file for idle time
│   └── Library/
│       └── LaunchDaemons/        # LaunchDaemon directory
│           └── com.example.idleshutdown.plist  # LaunchDaemon to auto-start the script
├── scripts/
│   └── postinstall               # Post-install script to ensure LaunchDaemon is loaded
└── idle_shutdown_installer.pkg   # Generated package file
```

---

## Instructions

### 1. Shell Scripts and Permissions

**Idle Shutdown Script** (`idle_shutdown.sh`):
- Responsible for detecting system idle time and initiating a forced shutdown if the timeout is reached.
- Located at `/usr/local/bin/idle_shutdown.sh`.
- Requires execution permissions:
  ```bash
  sudo chmod +x /usr/local/bin/idle_shutdown.sh
  ```

**Uninstall Script** (`uninstall_idleshutdown.sh`):
- Safely removes all installed components (scripts, logs, configuration files, and LaunchDaemon).
- Located at `/usr/local/bin/uninstall_idleshutdown.sh`.
- Requires execution permissions:
  ```bash
  sudo chmod +x /usr/local/bin/uninstall_idleshutdown.sh
  ```

### 2. Instructions to Create the `.pkg` Installer

**Organize Files:**
1. Create the required directory structure:
   ```bash
   mkdir -p ~/idle_shutdown_project/installer_root/usr/local/bin
   mkdir -p ~/idle_shutdown_project/installer_root/usr/local/etc
   mkdir -p ~/idle_shutdown_project/installer_root/Library/LaunchDaemons
   mkdir -p ~/idle_shutdown_project/scripts
   ```

2. Copy files into their respective directories:
   ```bash
   cp /usr/local/bin/idle_shutdown.sh ~/idle_shutdown_project/installer_root/usr/local/bin/
   cp /usr/local/bin/uninstall_idleshutdown.sh ~/idle_shutdown_project/installer_root/usr/local/bin/
   cp /usr/local/etc/idle_shutdown.conf ~/idle_shutdown_project/installer_root/usr/local/etc/
   cp /Library/LaunchDaemons/com.example.idleshutdown.plist ~/idle_shutdown_project/installer_root/Library/LaunchDaemons/
   ```

**Create Post-Install Script:**
1. Write a `postinstall` script:
   ```bash
   nano ~/idle_shutdown_project/scripts/postinstall
   ```

2. Add the following content:
   ```bash
   #!/bin/bash

   sudo launchctl load /Library/LaunchDaemons/com.example.idleshutdown.plist
   echo "Idle Shutdown installed successfully. To uninstall, run: sudo /usr/local/bin/uninstall_idleshutdown.sh"
   ```

3. Make the script executable:
   ```bash
   chmod +x ~/idle_shutdown_project/scripts/postinstall
   ```

**Build the Package:**
1. Use `pkgbuild` to generate the `.pkg` installer:
   ```bash
   pkgbuild --root ~/idle_shutdown_project/installer_root             --scripts ~/idle_shutdown_project/scripts             --identifier com.example.idleshutdown             --version 1.0             --install-location /             idle_shutdown_installer.pkg
   ```

---

### 3. How to See Logs

The script logs all actions and statuses to `/var/log/idle_shutdown.log`. To view logs:

- **View logs in real-time:**
  ```bash
  tail -f /var/log/idle_shutdown.log
  ```

- **View past logs:**
  ```bash
  cat /var/log/idle_shutdown.log
  ```

- **Check system logs for related events:**
  ```bash
  log show --predicate 'eventMessage contains "IdleShutdown"' --info
  ```

---

### 4. How to Uninstall

1. Run the uninstall script:
   ```bash
   sudo /usr/local/bin/uninstall_idleshutdown.sh
   ```

2. Verify that all files are removed:
   ```bash
   ls /usr/local/bin/idle_shutdown.sh
   ls /usr/local/bin/uninstall_idleshutdown.sh
   ls /usr/local/etc/idle_shutdown.conf
   ls /var/log/idle_shutdown.log
   ls /Library/LaunchDaemons/com.example.idleshutdown.plist
   ```

   These commands should return:
   ```
   No such file or directory
   ```

---

## Authors

* **Sujil Sukumaran** - *Project Lead*  
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-Sujil-blue)](https://www.linkedin.com/in/sujilsukumaran/)  
  [![Email](https://img.shields.io/badge/Email-sujil.v.sukumaran%40gmail.com-orange)](mailto:sujil.v.sukumaran@gmail.com)

Feel free to contribute to this project or reach out with feedback!

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
