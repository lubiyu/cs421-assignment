#!/bin/bash
 Define update log file
UPDATE_LOG="/var/log/update.log"
UPDATE_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Start update log
{
  echo "$UPDATE_TIME Update Start"

  # Update packages
  echo "Updating system packages..."
  apt update && apt upgrade -y

  # Navigate to API directory and pull changes from GitHub
  cd /var/www/your_api
  echo "Pulling latest code from GitHub..."
  git pull origin main
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Git pull failed. Update aborted."
    echo "$UPDATE_TIME Git pull failed." >> "$UPDATE_LOG"
    exit 1
  fi

  # Restart Apache to apply changes
  echo "Restarting Apache server..."
  systemctl restart apache2

  echo "$UPDATE_TIME Update Completed"
} >> "$UPDATE_LOG"

