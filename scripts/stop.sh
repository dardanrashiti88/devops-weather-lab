#!/bin/bash

# Lab Project Stop Script
# Supports both Docker Compose and Kubernetes deployments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to check if docker is running
check_docker() {
    if ! docker info &> /dev/null; then
        print_error "Docker is not running"
        return 1
    fi
    return 0
}

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        return 1
    fi
    return 0
}

# Function to check if Kubernetes cluster is accessible
check_k8s_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        return 1
    fi
    return 0
}

# Function to stop docker compose environment
stop_docker_compose() {
    print_status "Stopping Docker Compose environment..."
    
    if [ ! -f "docker-compose.yaml" ]; then
        print_error "docker-compose.yaml not found in current directory"
        exit 1
    fi
    
    # Check if services are running
    if ! docker-compose ps | grep -q "Up"; then
        print_warning "No Docker Compose services are currently running"
        return 0
    fi
    
    # Show running services
    print_status "Currently running services:"
    docker-compose ps
    
    # Ask for confirmation
    read -p "Do you want to stop all services? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Operation cancelled"
        return 0
    fi
    
    # Stop services
    docker-compose down
    
    print_success "Docker Compose environment stopped successfully!"
    print_status "Frontend and all other services have been stopped."
}

# Function to stop kubernetes environment
stop_kubernetes() {
    print_status "Stopping Kubernetes environment..."
    
    if [ ! -d "k8s" ]; then
        print_error "k8s directory not found"
        exit 1
    fi
    
    # Check if namespace exists
    if ! kubectl get namespace lab-project &> /dev/null; then
        print_warning "Namespace 'lab-project' does not exist"
        return 0
    fi
    
    # Show running resources
    print_status "Currently running resources:"
    kubectl get all -n lab-project
    
    # Ask for confirmation
    read -p "Do you want to delete all resources in namespace 'lab-project'? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Operation cancelled"
        return 0
    fi
    
    # Use the delete script if available
    if [ -f "k8s/delete-all.sh" ]; then
        print_status "Using delete script..."
        cd k8s
        ./delete-all.sh
        cd ..
    else
        print_status "Deleting namespace manually..."
        kubectl delete namespace lab-project
    fi
    
    print_success "Kubernetes environment stopped successfully!"
    print_status "Frontend and all other services have been stopped."
}

# Function to stop all environments
stop_all() {
    print_status "Stopping all environments..."
    
    # Stop docker Compose if running
    if [ -f "docker-compose.yaml" ] && check_docker; then
        if docker-compose ps | grep -q "Up"; then
            print_status "Stopping Docker Compose services..."
            docker-compose down
            print_success "Docker Compose stopped"
        fi
    fi
    
    # Stop kubernetes if running
    if [ -d "k8s" ] && check_kubectl && check_k8s_cluster; then
        if kubectl get namespace lab-project &> /dev/null; then
            print_status "Stopping Kubernetes resources..."
            if [ -f "k8s/delete-all.sh" ]; then
                cd k8s
                ./delete-all.sh
                cd ..
            else
                kubectl delete namespace lab-project
            fi
            print_success "Kubernetes stopped"
        fi
    fi
    
    print_success "All environments stopped successfully!"
}

# Function to show usage
usage() {
    echo "Usage: $0 [docker|k8s|kubernetes|all]"
    echo
    echo "Options:"
    echo "  docker     - Stop Docker Compose environment"
    echo "  k8s        - Stop Kubernetes environment"
    echo "  kubernetes - Stop Kubernetes environment"
    echo "  all        - Stop all environments (Docker Compose + Kubernetes)"
    echo
    echo "If no option is provided, the script will try to detect and stop running environments."
}

# Function to detect running environments
detect_running_environments() {
    local docker_running=false
    local k8s_running=false
    
    # Check docker compose
    if [ -f "docker-compose.yaml" ] && check_docker; then
        if docker-compose ps | grep -q "Up"; then
            docker_running=true
        fi
    fi
    
    # Check kubernetes
    if [ -d "k8s" ] && check_kubectl && check_k8s_cluster; then
        if kubectl get namespace lab-project &> /dev/null; then
            k8s_running=true
        fi
    fi
    
    if [ "$docker_running" = true ] && [ "$k8s_running" = true ]; then
        echo "both"
    elif [ "$docker_running" = true ]; then
        echo "docker"
    elif [ "$k8s_running" = true ]; then
        echo "k8s"
    else
        echo "none"
    fi
}

# Main script logic
main() {
    echo "=========================================="
    echo "Lab Project Stop Script"
    echo "=========================================="
    echo
    
    # Determine what to stop
    STOP_TYPE="${1:-auto}"
    
    case $STOP_TYPE in
        docker)
            if check_docker; then
                stop_docker_compose
            else
                print_error "Docker is not available"
                exit 1
            fi
            ;;
        k8s|kubernetes)
            if check_kubectl && check_k8s_cluster; then
                stop_kubernetes
            else
                print_error "Kubernetes is not available"
                exit 1
            fi
            ;;
        all)
            stop_all
            ;;
        auto)
            # Auto-detect running environments
            RUNNING_ENV=$(detect_running_environments)
            
            case $RUNNING_ENV in
                both)
                    print_status "Both Docker Compose and Kubernetes environments are running"
                    read -p "Do you want to stop both? (y/N): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        stop_all
                    else
                        print_status "Operation cancelled"
                    fi
                    ;;
                docker)
                    print_status "Docker Compose environment is running"
                    stop_docker_compose
                    ;;
                k8s)
                    print_status "Kubernetes environment is running"
                    stop_kubernetes
                    ;;
                none)
                    print_warning "No running environments detected"
                    ;;
            esac
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
