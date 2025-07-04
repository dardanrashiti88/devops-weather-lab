#!/bin/bash

# Lab project DEployment script
# Supports Docker Compose and Kubernetes deployments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Function to detect environment
detect_environment() {
    if [ -f "docker-compose.yaml" ]; then
        echo "docker-compose"
    elif [ -d "k8s" ]; then
        echo "kubernetes"
    else
        echo "unknown"
    fi
}

# Function to deploy docker compose
deploy_docker_compose() {
    print_status "Deploying with Docker Compose..."
    
    # Check if docker is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    # Build and start services
    print_status "Building and starting services..."
    docker-compose up -d --build
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 10
    
    # Check service status
    print_status "Checking service status..."
    docker-compose ps
    
    print_success "Docker Compose deployment completed!"
}

# Function to deploy kubernetes
deploy_kubernetes() {
    print_status "Deploying with Kubernetes..."
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    
    # Check if cluster is accessible
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster. Please check your cluster configuration."
        exit 1
    fi
    
    # Create namespace if it doesnt exist
    print_status "Creating namespace..."
    kubectl create namespace lab-project --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply all kubernetes manifests
    print_status "Applying Kubernetes manifests..."
    kubectl apply -f k8s/ -n lab-project
    
    # Wait for deployments to be ready
    print_status "Waiting for deployments to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/backend -n lab-project
    kubectl wait --for=condition=available --timeout=300s deployment/mysql -n lab-project
    kubectl wait --for=condition=available --timeout=300s deployment/prometheus -n lab-project
    kubectl wait --for=condition=available --timeout=300s deployment/grafana -n lab-project
    
    # Show service status
    print_status "Checking service status..."
    kubectl get pods -n lab-project
    kubectl get services -n lab-project
    
    print_success "Kubernetes deployment completed!"
}

# Function to deploy Azure (Terraform)
deploy_azure() {
    print_status "Deploying to Azure with Terraform..."
    
    # Check if Terraform is available
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi
    
    # Check if Azure CLI is available
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install Azure CLI first."
        exit 1
    fi
    
    # Navigate to terraform directory
    cd terraform
    
    # Initialize Terraform
    print_status "Initializing Terraform..."
    terraform init
    
    # Plan deployment
    print_status "Planning deployment..."
    terraform plan
    
    # Ask for confirmation
    read -p "Do you want to proceed with the deployment? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Deployment cancelled."
        exit 0
    fi
    
    # Apply deployment
    print_status "Applying Terraform configuration..."
    terraform apply -auto-approve
    
    # Show outputs
    print_status "Deployment outputs:"
    terraform output
    
    print_success "Azure deployment completed!"
}

# Main script
main() {
    print_status "Lab Project Deployment Script"
    print_status "=============================="
    
    # Parse command line arguments
    ENVIRONMENT=""
    while [[ $# -gt 0 ]]; do
        case $1 in
            --docker-compose)
                ENVIRONMENT="docker-compose"
                shift
                ;;
            --kubernetes)
                ENVIRONMENT="kubernetes"
                shift
                ;;
            --azure)
                ENVIRONMENT="azure"
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --docker-compose  Deploy using Docker Compose"
                echo "  --kubernetes      Deploy using Kubernetes"
                echo "  --azure           Deploy to Azure using Terraform"
                echo "  --help            Show this help message"
                echo ""
                echo "If no option is specified, the script will auto-detect the environment."
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Auto-detect environment if not specified
    if [ -z "$ENVIRONMENT" ]; then
        ENVIRONMENT=$(detect_environment)
        print_status "Auto-detected environment: $ENVIRONMENT"
    fi
    
    # Deploy based on environment
    case $ENVIRONMENT in
        "docker-compose")
            deploy_docker_compose
            ;;
        "kubernetes")
            deploy_kubernetes
            ;;
        "azure")
            deploy_azure
            ;;
        "unknown")
            print_error "Could not detect deployment environment."
            print_error "Please specify --docker-compose, --kubernetes, or --azure"
            exit 1
            ;;
        *)
            print_error "Unknown environment: $ENVIRONMENT"
            exit 1
            ;;
    esac
}

# Run main function
main "$@" 