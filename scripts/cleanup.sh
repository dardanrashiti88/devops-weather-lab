#!/bin/bash

# Lab project cleanup script
# Stops and removes all containers, networks, and volumes for docker compose,
# deletes kubernetes resources, and optionally destroys terraform resources.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Function to detect environment
detect_environment() {
    if [ -f "docker-compose.yaml" ]; then
        echo "docker-compose"
    elif [ -d "k8s" ]; then
        echo "kubernetes"
    elif [ -d "terraform" ]; then
        echo "terraform"
    else
        echo "unknown"
    fi
}

cleanup_docker_compose() {
    print_status "Stopping and removing Docker Compose containers, networks, and volumes..."
    docker-compose down -v --remove-orphans
    print_success "Docker Compose cleanup complete."
}

cleanup_kubernetes() {
    print_status "Deleting Kubernetes resources in namespace lab-project..."
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Skipping Kubernetes cleanup."
        return
    fi
    if kubectl get namespace lab-project &> /dev/null; then
        kubectl delete all --all -n lab-project
        kubectl delete pvc --all -n lab-project
        kubectl delete configmap --all -n lab-project
        kubectl delete secret --all -n lab-project
        kubectl delete cronjob --all -n lab-project
        kubectl delete namespace lab-project
        print_success "Kubernetes cleanup complete."
    else
        print_warning "Namespace lab-project does not exist. Skipping Kubernetes cleanup."
    fi
}

cleanup_terraform() {
    print_status "Destroying all Terraform-managed Azure resources..."
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Skipping Terraform cleanup."
        return
    fi
    cd terraform
    terraform destroy -auto-approve
    print_success "Terraform cleanup complete."
    cd ..
}

main() {
    print_status "Lab Project Cleanup Script"
    print_status "========================="

    # Parse command line arguments
    CLEANUP_DOCKER=true
    CLEANUP_K8S=true
    CLEANUP_TF=false
    FORCE=false
    while [[ $# -gt 0 ]]; do
        case $1 in
            --docker-only)
                CLEANUP_K8S=false
                CLEANUP_TF=false
                shift
                ;;
            --k8s-only)
                CLEANUP_DOCKER=false
                CLEANUP_TF=false
                shift
                ;;
            --terraform)
                CLEANUP_TF=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --docker-only   Cleanup only Docker Compose resources"
                echo "  --k8s-only      Cleanup only Kubernetes resources"
                echo "  --terraform     Also destroy Terraform-managed Azure resources"
                echo "  --force         Do not prompt for confirmation"
                echo "  --help          Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    if [ "$FORCE" = false ]; then
        echo -e "${YELLOW}This will stop and remove all containers, networks, and volumes for Docker Compose, delete all Kubernetes resources, and optionally destroy all Azure resources managed by Terraform.${NC}"
        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_warning "Cleanup cancelled."
            exit 0
        fi
    fi

    if [ "$CLEANUP_DOCKER" = true ]; then
        cleanup_docker_compose
    fi
    if [ "$CLEANUP_K8S" = true ]; then
        cleanup_kubernetes
    fi
    if [ "$CLEANUP_TF" = true ]; then
        cleanup_terraform
    fi

    print_success "Cleanup process completed!"
}

main "$@" 