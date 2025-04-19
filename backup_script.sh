# Create backups directory if it doesn't exist
mkdir -p /home/ubuntu/backups

# Set timestamp for filenames
BACKUP_DATE=$(date +%F)

# Backup project directory
API_SOURCE="/var/www/your_api"
API_DEST="/home/ubuntu/backups/api_backup_$BACKUP_DATE.tar.gz"
tar -czf "$API_DEST" "$API_SOURCE"

# Backup MySQL database (update DB_NAME, USER, and PASSWORD accordingly)
DB_NAME="your_db"
DB_USER="root"
DB_PASSWORD="your_password"
DB_DEST="/home/ubuntu/backups/db_backup_$BACKUP_DATE.sql"
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$DB_DEST"

# Remove backups older than 7 days
find /home/ubuntu/backups/ -type f -mtime +7 -exec rm {} \;

# Log the backup process
BACKUP_LOG="/var/log/backup.log"
echo "$TIMESTAMP Backup created: $API_DEST and $DB_DEST" >> "$BACKUP_LOG"
