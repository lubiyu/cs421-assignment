#!/bin/bash
LOG_FILE="/var/log/server_health.log"
# Get current time for logging
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get CPU usage using top and awk
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Get memory usage using free and awk
MEMORY=$(free | awk '/Mem/ {printf("%.2f"), $3/$2 * 100.0}')

# Get root disk usage using df
DISK=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Check if Apache web server is active
WEBSERVER=$(systemctl is-active apache2)

# Check API endpoints using curl
STUDENTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/students)
SUBJECTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/subjects)

# Start logging
{
  echo "$TIMESTAMP Health Check Start"
  echo "CPU Usage: $CPU%"
  echo "Memory Usage: $MEMORY%"
  echo "Disk Usage: $DISK%"
  echo "Web Server: $WEBSERVER"
  echo "API /students Status: $STUDENTS_STATUS"
  echo "API /subjects Status: $SUBJECTS_STATUS"

  # Warnings if checks fail
  [[ $DISK -gt 90 ]] && echo "WARNING: Disk usage above 90%!"
  [[ $STUDENTS_STATUS -ne 200 ]] && echo "WARNING: /students endpoint failed!"
  [[ $SUBJECTS_STATUS -ne 200 ]] && echo "WARNING: /subjects endpoint failed!"
  echo "$TIMESTAMP Health Check End\n"
} >> "$LOG_FILE"




