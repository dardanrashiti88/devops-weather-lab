#!/bin/bash

# Lab project health check script
# Monitors the health of all services

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
BACKEND_URL="http://localhost:3000"
GRAFANA_URL="http://localhost:3001"
PROMETHEUS_URL="http://localhost:9090"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USER="root"
MYSQL_PASSWORD="your-secure-mysql-password"
MYSQL_DATABASE="lab_db"

# Health check
HEALTH_STATUS=0
FAILED_SERVICES=()

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

# Function to check if a port is open
check_port() {
    local host=$1
    local port=$2
    local service=$3
    
    if nc -z "$host" "$port" 2>/dev/null; then
        print_success "$service is running on $host:$port"
        return 0
    else
        print_error "$service is not accessible on $host:$port"
        FAILED_SERVICES+=("$service")
        HEALTH_STATUS=1
        return 1
    fi
}

# Function to check HTTP endpoint
check_http_endpoint() {
    local url=$1
    local service=$2
    
    if curl -s -f "$url" >/dev/null 2>&1; then
        print_success "$service is responding at $url"
        return 0
    else
        print_error "$service is not responding at $url"
        FAILED_SERVICES+=("$service")
        HEALTH_STATUS=1
        return 1
    fi
}

# Function to check Docker containers
check_docker_containers() {
    print_status "Checking Docker containers..."
    
    local containers=("lab2-backend-1" "lab2-mysql-db-1" "prometheus" "grafana" "node-exporter")
    local all_running=true
    
    for container in "${containers[@]}"; do
        if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "$container.*Up"; then
            print_success "Container $container is running"
        else
            print_error "Container $container is not running"
            FAILED_SERVICES+=("$container")
            all_running=false
            HEALTH_STATUS=1
        fi
    done
    
    if [ "$all_running" = true ]; then
        print_success "All Docker containers are running"
    fi
}

# Function to check MySQL database
check_mysql() {
    print_status "Checking MySQL database..."
    
    # Check if MySQL is accessible
    if ! check_port "$MYSQL_HOST" "$MYSQL_PORT" "MySQL"; then
        return 1
    fi
    
    # Check if we can connect to the database
    if docker exec lab2-mysql-db-1 mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; then
        print_success "MySQL database connection successful"
        
        # Check if the database exists
        if docker exec lab2-mysql-db-1 mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "USE $MYSQL_DATABASE;" >/dev/null 2>&1; then
            print_success "Database '$MYSQL_DATABASE' exists and is accessible"
        else
            print_error "Database '$MYSQL_DATABASE' does not exist or is not accessible"
            FAILED_SERVICES+=("MySQL Database")
            HEALTH_STATUS=1
        fi
    else
        print_error "Cannot connect to MySQL database"
        FAILED_SERVICES+=("MySQL Connection")
        HEALTH_STATUS=1
    fi
}

# Function to check backend application
check_backend() {
    print_status "Checking backend application..."
    
    # Check if backend is responding
    if check_http_endpoint "$BACKEND_URL" "Backend"; then
        # Check if backend can connect to database
        if curl -s "$BACKEND_URL/health" | grep -q "healthy" 2>/dev/null; then
            print_success "Backend health check passed"
        else
            print_warning "Backend is running but health check endpoint not available"
        fi
    fi
}

# Function to check monitoring services
check_monitoring() {
    print_status "Checking monitoring services..."
    
    # Check Prometheus
    if check_http_endpoint "$PROMETHEUS_URL" "Prometheus"; then
        # Check if Prometheus has targets
        if curl -s "$PROMETHEUS_URL/api/v1/targets" | grep -q "UP" 2>/dev/null; then
            print_success "Prometheus has active targets"
        else
            print_warning "Prometheus is running but no targets are UP"
        fi
    fi
    
    # Check Grafana
    if check_http_endpoint "$GRAFANA_URL" "Grafana"; then
        print_success "Grafana is accessible"
    fi
    
    # Check Node Exporter
    if check_port "localhost" "9100" "Node Exporter"; then
        print_success "Node Exporter metrics are available"
    fi
}

# Function to check system resources
check_system_resources() {
    print_status "Checking system resources..."
    
    # Check disk space
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -lt 80 ]; then
        print_success "Disk usage: ${disk_usage}% (OK)"
    else
        print_warning "Disk usage: ${disk_usage}% (High)"
    fi
    
    # Check memory usage
    local memory_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
    if [ "$memory_usage" -lt 80 ]; then
        print_success "Memory usage: ${memory_usage}% (OK)"
    else
        print_warning "Memory usage: ${memory_usage}% (High)"
    fi
    
    # Check CPU load
    local cpu_load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    print_status "CPU load average: $cpu_load"
}

# Function to check logs for errors
check_logs() {
    print_status "Checking recent logs for errors..."
    
    # Check Docker Compose logs for errors in the last 10 minutes
    local error_count=$(docker-compose logs --since=10m 2>&1 | grep -i "error\|failed\|exception" | wc -l)
    
    if [ "$error_count" -eq 0 ]; then
        print_success "No recent errors found in logs"
    else
        print_warning "Found $error_count potential errors in recent logs"
        print_status "Recent errors:"
        docker-compose logs --since=10m 2>&1 | grep -i "error\|failed\|exception" | tail -5
    fi
}

# Function to generate health report
generate_report() {
    local report_file="health_report_$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$report_file" << EOF
Lab Project Health Report
=========================
Date: $(date)
Overall Status: $(if [ $HEALTH_STATUS -eq 0 ]; then echo "HEALTHY"; else echo "UNHEALTHY"; fi)

Services Status:
$(if [ ${#FAILED_SERVICES[@]} -eq 0 ]; then
    echo "All services are running properly"
else
    echo "Failed services:"
    printf '%s\n' "${FAILED_SERVICES[@]}"
fi)

System Resources:
- Disk Usage: $(df / | tail -1 | awk '{print $5}')
- Memory Usage: $(free | grep Mem | awk '{printf "%.0f%%", $3/$2 * 100.0}')
- CPU Load: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')

Recent Log Errors: $(docker-compose logs --since=10m 2>&1 | grep -i "error\|failed\|exception" | wc -l)
EOF
    
    print_success "Health report generated: $report_file"
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --containers-only  Check only Docker containers"
    echo "  --services-only    Check only service endpoints"
    echo "  --system-only      Check only system resources"
    echo "  --logs-only        Check only application logs"
    echo "  --report           Generate detailed health report"
    echo "  --help             Show this help message"
    echo ""
    echo "If no option is specified, all health checks will be performed."
}

# Main script
main() {
    print_status "Lab Project Health Check Script"
    print_status "==============================="
    
    # Parse command line arguments
    CHECK_TYPE="all"
    GENERATE_REPORT=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --containers-only)
                CHECK_TYPE="containers"
                shift
                ;;
            --services-only)
                CHECK_TYPE="services"
                shift
                ;;
            --system-only)
                CHECK_TYPE="system"
                shift
                ;;
            --logs-only)
                CHECK_TYPE="logs"
                shift
                ;;
            --report)
                GENERATE_REPORT=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Perform health checks based on type
    case $CHECK_TYPE in
        "containers")
            check_docker_containers
            ;;
        "services")
            check_backend
            check_monitoring
            check_mysql
            ;;
        "system")
            check_system_resources
            ;;
        "logs")
            check_logs
            ;;
        "all")
            check_docker_containers
            check_backend
            check_monitoring
            check_mysql
            check_system_resources
            check_logs
            ;;
    esac
    
    # Generate report if requested
    if [ "$GENERATE_REPORT" = true ]; then
        generate_report
    fi
    
    # Summary
    echo ""
    print_status "Health Check Summary:"
    echo "========================"
    
    if [ $HEALTH_STATUS -eq 0 ]; then
        print_success "All systems are healthy! 🎉"
    else
        print_error "Some services are unhealthy:"
        printf '%s\n' "${FAILED_SERVICES[@]}"
        echo ""
        print_status "Run '$0 --help' for more options"
    fi
    
    exit $HEALTH_STATUS
}

# Run main function
main "$@" 