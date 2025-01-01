#!/bin/bash

CONFIG_FILE="/usr/local/etc/idle_shutdown.conf"
DEFAULT_IDLE_LIMIT=1800  # Default timeout (30 minutes)
LOG_FILE="/var/log/idle_shutdown.log"
LOG_TAG="IdleShutdown"

# Ensure the log file exists
sudo touch "$LOG_FILE"
sudo chmod 666 "$LOG_FILE"

# Function to check idle time and shut down if needed
check_idle_time() {
    IDLE_TIME=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
    logger -t $LOG_TAG "Current idle time: $IDLE_TIME seconds"
    echo "$(date): Current idle time: $IDLE_TIME seconds" >> "$LOG_FILE"

    if [ "$IDLE_TIME" -ge "$IDLE_LIMIT" ]; then
        logger -t $LOG_TAG "Idle limit reached. Initiating shutdown."
        echo "$(date): Idle limit reached. Initiating shutdown." >> "$LOG_FILE"

        # Force shutdown in case of blocking components
        sudo shutdown -h now || sudo shutdown -h -f now
    fi
}

# Load configuration or use default timeout
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    IDLE_LIMIT=$DEFAULT_IDLE_LIMIT
fi

logger -t $LOG_TAG "Idle Shutdown script started with timeout $IDLE_LIMIT seconds."
echo "$(date): Script started with timeout $IDLE_LIMIT seconds." >> "$LOG_FILE"

while true; do
    check_idle_time
    sleep 60
done

