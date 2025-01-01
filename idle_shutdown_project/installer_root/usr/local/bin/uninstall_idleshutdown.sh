#!/bin/bash

LOG_TAG="IdleShutdown"

logger -t $LOG_TAG "Uninstalling Idle Shutdown..."

# Stop and remove the LaunchDaemon
sudo launchctl unload /Library/LaunchDaemons/com.example.idleshutdown.plist
sudo rm -f /Library/LaunchDaemons/com.example.idleshutdown.plist

# Remove the script, config, and log files
sudo rm -f /usr/local/bin/idle_shutdown.sh
sudo rm -f /usr/local/etc/idle_shutdown.conf
sudo rm -f /var/log/idle_shutdown.log

logger -t $LOG_TAG "Idle Shutdown uninstalled successfully."
echo "Idle Shutdown uninstalled successfully."

