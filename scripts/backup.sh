#!/bin/bash

# lab project backup script
# Creates backups of databases and application data

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
MYSQL_CONTAINER="lab2-mysql-db-1"
MYSQL_DATABASE="lab_db"
MYSQL_USER="root"
MYSQL_PASSWORD="your-secure-mysql-password"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create backup directory
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        print_status "Creating backup directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi
}

# Function to backup MySQL database
backup_mysql() {
    print_status "Creating MySQL database backup..."
    
    # Check if MySQL container is running
    if ! docker ps | grep -q "$MYSQL_CONTAINER"; then
        print_error "MySQL container is not running. Cannot create backup."
        return 1
    fi
    
    BACKUP_FILE="$BACKUP_DIR/mysql_backup_$DATE.sql"
    
    # Create database backup
    docker exec "$MYSQL_CONTAINER" mysqldump \
        -u "$MYSQL_USER" \
        -p"$MYSQL_PASSWORD" \
        "$MYSQL_DATABASE" > "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        print_success "MySQL backup created: $BACKUP_FILE"
        print_status "Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
    else
        print_error "Failed to create MySQL backup"
        return 1
    fi
}

# Function to backup application data
backup_app_data() {
    print_status "Creating application data backup..."
    
    # Create tar archive of important directories
    BACKUP_FILE="$BACKUP_DIR/app_data_backup_$DATE.tar.gz"
    
    tar -czf "$BACKUP_FILE" \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='backups' \
        --exclude='*.log' \
        . 2>/dev/null || true
    
    if [ -f "$BACKUP_FILE" ]; then
        print_success "Application data backup created: $BACKUP_FILE"
        print_status "Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
    else
        print_warning "No application data to backup"
    fi
}

# Function to backup Docker volumes
backup_docker_volumes() {
    print_status "Creating Docker volumes backup..."
    
    BACKUP_FILE="$BACKUP_DIR/docker_volumes_backup_$DATE.tar.gz"
    
    # Get list of volumes
    VOLUMES=$(docker volume ls -q | grep lab2)
    
    if [ -n "$VOLUMES" ]; then
        # Create backup of volumes
        docker run --rm \
            -v "$(pwd)/$BACKUP_DIR:/backup" \
            -v "$(echo $VOLUMES | tr ' ' ':' | sed 's/^/:/')" \
            alpine tar czf "/backup/docker_volumes_backup_$DATE.tar.gz" \
            $(echo $VOLUMES | sed 's/lab2_//g') 2>/dev/null || true
        
        if [ -f "$BACKUP_FILE" ]; then
            print_success "Docker volumes backup created: $BACKUP_FILE"
            print_status "Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
        else
            print_warning "No Docker volumes to backup"
        fi
    else
        print_warning "No Docker volumes found"
    fi
}

# Function to create backup manifest
create_manifest() {
    print_status "Creating backup manifest..."
    
    MANIFEST_FILE="$BACKUP_DIR/backup_manifest_$DATE.txt"
    
    cat > "$MANIFEST_FILE" << EOF
Lab Project Backup Manifest
===========================
Date: $(date)
Backup ID: $DATE

Files included in this backup:
EOF
    
    # List all backup files
    for file in "$BACKUP_DIR"/*"$DATE"*; do
        if [ -f "$file" ]; then
            echo "- $(basename "$file") ($(du -h "$file" | cut -f1))" >> "$MANIFEST_FILE"
        fi
    done
    
    echo "" >> "$MANIFEST_FILE"
    echo "Total backup size: $(du -sh "$BACKUP_DIR" | cut -f1)" >> "$MANIFEST_FILE"
    
    print_success "Backup manifest created: $MANIFEST_FILE"
}

# Function to cleanup old backups
cleanup_old_backups() {
    print_status "Cleaning up old backups (keeping last 7 days)..."
    
    # Remove backups older than 7 days
    find "$BACKUP_DIR" -name "*.sql" -mtime +7 -delete 2>/dev/null || true
    find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete 2>/dev/null || true
    find "$BACKUP_DIR" -name "backup_manifest_*.txt" -mtime +7 -delete 2>/dev/null || true
    
    print_success "Old backups cleaned up"
}

# Function to show backup status
show_backup_status() {
    print_status "Backup Summary:"
    echo "=================="
    
    if [ -d "$BACKUP_DIR" ]; then
        echo "Backup directory: $BACKUP_DIR"
        echo "Total backups: $(ls "$BACKUP_DIR" | wc -l)"
        echo "Total size: $(du -sh "$BACKUP_DIR" | cut -f1)"
        echo ""
        echo "Recent backups:"
        ls -la "$BACKUP_DIR" | tail -10
    else
        echo "No backup directory found"
    fi
}

# Main script
main() {
    print_status "Lab Project Backup Script"
    print_status "========================="
    
    # Parse command line arguments
    BACKUP_TYPE="all"
    while [[ $# -gt 0 ]]; do
        case $1 in
            --mysql-only)
                BACKUP_TYPE="mysql"
                shift
                ;;
            --app-only)
                BACKUP_TYPE="app"
                shift
                ;;
            --volumes-only)
                BACKUP_TYPE="volumes"
                shift
                ;;
            --status)
                show_backup_status
                exit 0
                ;;
            --cleanup)
                create_backup_dir
                cleanup_old_backups
                exit 0
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --mysql-only    Backup only MySQL database"
                echo "  --app-only      Backup only application data"
                echo "  --volumes-only  Backup only docker volumes"
                echo "  --status        Show backup status"
                echo "  --cleanup       Clean up old backups"
                echo "  --help          Show this help message"
                echo ""
                echo "If no option is specified, all backups will be created."
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Create backup directory
    create_backup_dir
    
    # Perform backups based on type
    case $BACKUP_TYPE in
        "mysql")
            backup_mysql
            ;;
        "app")
            backup_app_data
            ;;
        "volumes")
            backup_docker_volumes
            ;;
        "all")
            backup_mysql
            backup_app_data
            backup_docker_volumes
            ;;
    esac
    
    # Create manifest
    create_manifest
    
    # Cleanup old backups
    cleanup_old_backups
    
    print_success "Backup process completed!"
    print_status "Backup location: $BACKUP_DIR"
}

# Run main function
main "$@" 