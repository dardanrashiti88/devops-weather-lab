#!/bin/bash

# Lab project tart script
# Supports both docker compose and kubernetes deployments

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
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        return 1
    fi
    return 0
}

# Function to check if kubernetes cluster is accessible
check_k8s_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        return 1
    fi
    return 0
}

# Function to start docker compose environment
start_docker_compose() {
    print_status "Starting Docker Compose environment..."
    
    if [ ! -f "docker-compose.yaml" ]; then
        print_error "docker-compose.yaml not found in current directory"
        exit 1
    fi
    
    # Check if services are already running
    if docker-compose ps | grep -q "Up"; then
        print_warning "Some services are already running"
        read -p "Do you want to restart them? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Stopping existing services..."
            docker-compose down
        else
            print_status "Using existing services"
            return 0
        fi
    fi
    
    # Start services
    docker-compose up -d
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 10
    
    # Check service status
    print_status "Checking service status..."
    docker-compose ps
    
    print_success "Docker Compose environment started successfully!"
    echo
    print_status "Access your applications:"
    echo "  - Backend: http://localhost:3000"
    echo "  - Frontend: http://localhost:5173"
    echo "  - Prometheus: http://localhost:9090"
    echo "  - Grafana: http://localhost:3001 (admin/admin)"
    echo "  - MySQL: localhost:3306"
}

# Function to start kubernetes environment
start_kubernetes() {
    print_status "Starting Kubernetes environment..."
    
    if [ ! -d "k8s" ]; then
        print_error "k8s directory not found"
        exit 1
    fi
    
    cd k8s
    
    # Check if namespace already exists
    if kubectl get namespace lab-project &> /dev/null; then
        print_warning "Namespace 'lab-project' already exists"
        read -p "Do you want to recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Deleting existing namespace..."
            kubectl delete namespace lab-project
            sleep 5
        else
            print_status "Using existing namespace"
            cd ..
            return 0
        fi
    fi
    
    # Build backend image if needed
    print_status "Building backend Docker image..."
    cd ..
    if ! docker images | grep -q "lab-backend"; then
        docker build -t lab-backend:latest backend/
        print_success "Backend image built"
    else
        print_status "Backend image already exists"
    fi
    
    # If using minikube build image in minikube context
    if command -v minikube &> /dev/null && minikube status &> /dev/null; then
        print_status "Detected minikube, building image in minikube context..."
        eval $(minikube docker-env)
        docker build -t lab-backend:latest backend/
        print_success "Backend image built in minikube context"
    fi
    
    cd k8s
    
    # Deploy using the deployment script
    if [ -f "deploy.sh" ]; then
        print_status "Running deployment script..."
        ./deploy.sh
    else
        print_status "Deploying resources manually..."
        kubectl apply -f namespace.yaml
        kubectl apply -f mysql-secret.yaml
        kubectl apply -f mysql-init-configmap.yaml
        kubectl apply -f prometheus-configmap.yaml
        kubectl apply -f mysql-persistent-volume.yaml
        kubectl apply -f mysql-deployment.yaml
        kubectl apply -f mysql-service.yaml
        kubectl apply -f backend-deployment.yaml
        kubectl apply -f backend-service.yaml
        kubectl apply -f prometheus-deployment.yaml
        kubectl apply -f prometheus-service.yaml
        kubectl apply -f mysql-exporter-deployment.yaml
        kubectl apply -f mysql-exporter-service.yaml
        kubectl apply -f grafana-deployment.yaml
        kubectl apply -f grafana-service.yaml
        kubectl apply -f ingress.yaml
    fi
    
    cd ..
    
    print_success "Kubernetes environment started successfully!"
    echo
    print_status "Checking deployment status..."
    kubectl get pods -n lab-project
    echo
    print_status "Access your applications:"
    echo "  - Backend: http://backend.local"
    echo "  - Frontend: http://frontend.local"
    echo "  - Prometheus: http://prometheus.local"
    echo "  - Grafana: http://grafana.local (admin/admin)"
    echo
    print_warning "Don't forget to add the hostnames to your /etc/hosts file or configure DNS"
}

# Function to show usage
usage() {
    echo "Usage: $0 [docker|k8s|kubernetes]"
    echo
    echo "Options:"
    echo "  docker     - Start using Docker Compose (default)"
    echo "  k8s        - Start using Kubernetes"
    echo "  kubernetes - Start using Kubernetes"
    echo
    echo "If no option is provided, the script will try to detect the best option."
}

# Main script logic
main() {
    echo "=========================================="
    echo "Lab Project Start Script"
    echo "=========================================="
    echo
    
    # Check Docker
    check_docker
    
    # Determine deployment method
    DEPLOYMENT_TYPE="${1:-auto}"
    
    case $DEPLOYMENT_TYPE in
        docker)
            print_status "Using Docker Compose deployment"
            start_docker_compose
            ;;
        k8s|kubernetes)
            if check_kubectl && check_k8s_cluster; then
                print_status "Using Kubernetes deployment"
                start_kubernetes
            else
                print_error "Kubernetes not available, falling back to Docker Compose"
                start_docker_compose
            fi
            ;;
        auto)
            # Auto-detect: prefer Kubernetes if available
            if check_kubectl && check_k8s_cluster; then
                print_status "Kubernetes detected, using Kubernetes deployment"
                start_kubernetes
            else
                print_status "Kubernetes not available, using Docker Compose"
                start_docker_compose
            fi
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
