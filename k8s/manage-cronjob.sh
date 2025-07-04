#!/bin/bash

# Lab Project CronJob Management Script

set -e

NAMESPACE="lab-project"
CRONJOB_SIMPLE="daily-maintenance"
CRONJOB_ADVANCED="daily-maintenance-advanced"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to show usage
usage() {
    echo "Usage: $0 [status|run|suspend|resume|logs|delete] [simple|advanced]"
    echo
    echo "Commands:"
    echo "  status   - Show CronJob status"
    echo "  run      - Run CronJob manually"
    echo "  suspend  - Suspend CronJob"
    echo "  resume   - Resume CronJob"
    echo "  logs     - Show logs from last job"
    echo "  delete   - Delete CronJob"
    echo
    echo "Options:"
    echo "  simple   - Use simple maintenance CronJob (default)"
    echo "  advanced - Use advanced maintenance CronJob with database backup"
    echo
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 run advanced"
    echo "  $0 logs simple"
}

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi
}

# Function to check if namespace exists
check_namespace() {
    if ! kubectl get namespace $NAMESPACE &> /dev/null; then
        print_error "Namespace '$NAMESPACE' does not exist"
        exit 1
    fi
}

# Function to get CronJob name based on type
get_cronjob_name() {
    local type="${1:-simple}"
    case $type in
        simple)
            echo $CRONJOB_SIMPLE
            ;;
        advanced)
            echo $CRONJOB_ADVANCED
            ;;
        *)
            print_error "Invalid type: $type. Use 'simple' or 'advanced'"
            exit 1
            ;;
    esac
}

# Function to show CronJob status
show_status() {
    local cronjob_name=$1
    local type=$2
    
    print_status "CronJob Status for $type maintenance:"
    echo
    kubectl get cronjob $cronjob_name -n $NAMESPACE
    echo
    
    print_status "Recent Jobs:"
    kubectl get jobs -n $NAMESPACE -l job-name=$cronjob_name
    echo
    
    print_status "Last Job Logs:"
    local last_job=$(kubectl get jobs -n $NAMESPACE -l job-name=$cronjob_name --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}' 2>/dev/null)
    if [ -n "$last_job" ]; then
        local last_pod=$(kubectl get pods -n $NAMESPACE -l job-name=$last_job --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}' 2>/dev/null)
        if [ -n "$last_pod" ]; then
            kubectl logs $last_pod -n $NAMESPACE --tail=20
        else
            print_warning "No pods found for last job"
        fi
    else
        print_warning "No jobs found"
    fi
}

# Function to run CronJob manually
run_cronjob() {
    local cronjob_name=$1
    local type=$2
    
    print_status "Running $type maintenance CronJob manually..."
    kubectl create job --from=cronjob/$cronjob_name manual-$(date +%Y%m%d-%H%M%S) -n $NAMESPACE
    print_success "CronJob started manually"
    echo
    print_status "You can check the logs with: $0 logs $type"
}

# Function to suspend CronJob
suspend_cronjob() {
    local cronjob_name=$1
    local type=$2
    
    print_status "Suspending $type maintenance CronJob..."
    kubectl patch cronjob $cronjob_name -n $NAMESPACE -p '{"spec" : {"suspend" : true}}'
    print_success "CronJob suspended"
}

# Function to resume CronJob
resume_cronjob() {
    local cronjob_name=$1
    local type=$2
    
    print_status "Resuming $type maintenance CronJob..."
    kubectl patch cronjob $cronjob_name -n $NAMESPACE -p '{"spec" : {"suspend" : false}}'
    print_success "CronJob resumed"
}

# Function to show logs
show_logs() {
    local cronjob_name=$1
    local type=$2
    
    print_status "Getting logs for $type maintenance CronJob..."
    local last_job=$(kubectl get jobs -n $NAMESPACE -l job-name=$cronjob_name --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}' 2>/dev/null)
    if [ -n "$last_job" ]; then
        local last_pod=$(kubectl get pods -n $NAMESPACE -l job-name=$last_job --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}' 2>/dev/null)
        if [ -n "$last_pod" ]; then
            kubectl logs $last_pod -n $NAMESPACE
        else
            print_warning "No pods found for last job"
        fi
    else
        print_warning "No jobs found"
    fi
}

# Function to delete CronJob
delete_cronjob() {
    local cronjob_name=$1
    local type=$2
    
    print_warning "This will delete the $type maintenance CronJob and all its jobs"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Deleting $type maintenance CronJob..."
        kubectl delete cronjob $cronjob_name -n $NAMESPACE
        print_success "CronJob deleted"
    else
        print_status "Operation cancelled"
    fi
}

# Main script logic
main() {
    check_kubectl
    check_namespace
    
    local command="${1:-status}"
    local type="${2:-simple}"
    local cronjob_name=$(get_cronjob_name $type)
    
    case $command in
        status)
            show_status $cronjob_name $type
            ;;
        run)
            run_cronjob $cronjob_name $type
            ;;
        suspend)
            suspend_cronjob $cronjob_name $type
            ;;
        resume)
            resume_cronjob $cronjob_name $type
            ;;
        logs)
            show_logs $cronjob_name $type
            ;;
        delete)
            delete_cronjob $cronjob_name $type
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@" 