#!/bin/bash

# Lab Project Kubernetes Deployment Script
# This script deploys all Kubernetes resources for the lab project

set -e  # Exit on any error

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

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi
    print_success "kubectl found"
}

# Function to check if cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    print_success "Connected to Kubernetes cluster"
}

# Function to deploy resources
deploy_resource() {
    local resource=$1
    local description=$2
    
    print_status "Deploying $description..."
    if kubectl apply -f "$resource" --namespace=lab-project; then
        print_success "$description deployed successfully"
    else
        print_error "Failed to deploy $description"
        exit 1
    fi
}

# Function to wait for pods to be ready
wait_for_pods() {
    local deployment=$1
    local timeout=300  # 5 minutes timeout
    
    print_status "Waiting for $deployment pods to be ready..."
    if kubectl wait --for=condition=available --timeout=${timeout}s deployment/$deployment -n lab-project; then
        print_success "$deployment pods are ready"
    else
        print_warning "$deployment pods may not be ready yet"
    fi
}

# Main deployment function
main() {
    echo "=========================================="
    echo "Lab Project Kubernetes Deployment Script"
    echo "=========================================="
    echo
    
    # Check prerequisites
    print_status "Checking prerequisites..."
    check_kubectl
    check_cluster
    echo
    
    # Create namespace first
    print_status "Creating namespace..."
    kubectl apply -f namespace.yaml
    print_success "Namespace created"
    echo
    
    # Deploy resources in order
    print_status "Starting deployment of resources..."
    echo
    
    # 1. Secrets and ConfigMaps
    deploy_resource "mysql-secret.yaml" "MySQL Secret"
    deploy_resource "mysql-init-configmap.yaml" "MySQL Init ConfigMap"
    deploy_resource "prometheus-configmap.yaml" "Prometheus ConfigMap"
    echo
    
    # 2. Storage
    deploy_resource "mysql-persistent-volume.yaml" "MySQL Persistent Volume Claim"
    echo
    
    # 3. Database
    deploy_resource "mysql-deployment.yaml" "MySQL Deployment"
    deploy_resource "mysql-service.yaml" "MySQL Service"
    echo
    
    # Wait for MySQL to be ready before proceeding
    print_status "Waiting for MySQL to be ready..."
    sleep 30  # Give MySQL time to start
    wait_for_pods "mysql"
    echo
    
    # 4. Monitoring
    deploy_resource "prometheus-deployment.yaml" "Prometheus Deployment"
    deploy_resource "prometheus-service.yaml" "Prometheus Service"
    deploy_resource "grafana-deployment.yaml" "Grafana Deployment"
    deploy_resource "grafana-service.yaml" "Grafana Service"
    echo
    
    # 5. Application
    deploy_resource "backend-deployment.yaml" "Backend Deployment"
    deploy_resource "backend-service.yaml" "Backend Service"
    deploy_resource "frontend-deployment.yaml" "Frontend Deployment"
    deploy_resource "frontend-service.yaml" "Frontend Service"
    # 5b. NGINX Example
    deploy_resource "nginx-configmap.yaml" "NGINX ConfigMap"
    deploy_resource "nginx-deployment.yaml" "NGINX Deployment"
    deploy_resource "nginx-service.yaml" "NGINX Service"
    echo
    
    # 6. Networking
    deploy_resource "ingress.yaml" "Ingress"
    echo
    
    # Wait for all deployments to be ready
    print_status "Waiting for all deployments to be ready..."
    wait_for_pods "backend"
    wait_for_pods "frontend"
    wait_for_pods "prometheus"
    wait_for_pods "grafana"
    wait_for_pods "nginx"
    echo
    
    # Show deployment status
    print_status "Deployment completed! Checking status..."
    echo
    kubectl get all -n lab-project
    echo
    kubectl get ingress -n lab-project
    echo
    
    print_success "All resources deployed successfully!"
    echo
    print_status "Access your applications:"
    echo "  - Backend: http://backend.local"
    echo "  - Frontend: http://frontend.local"
    echo "  - Prometheus: http://prometheus.local"
    echo "  - Grafana: http://grafana.local (admin/admin)"
    echo "  - NGINX: http://nginx.local"
    echo
    print_warning "Don't forget to add the hostnames to your /etc/hosts file or configure DNS"
}

# Function to clean up resources
cleanup() {
    echo "=========================================="
    echo "Cleaning up Lab Project resources"
    echo "=========================================="
    echo
    
    print_status "Deleting namespace and all resources..."
    if kubectl delete namespace lab-project; then
        print_success "All resources cleaned up successfully"
    else
        print_error "Failed to clean up resources"
        exit 1
    fi
}

# Function to show usage
usage() {
    echo "Usage: $0 [deploy|cleanup|status]"
    echo
    echo "Commands:"
    echo "  deploy   - Deploy all Kubernetes resources"
    echo "  cleanup  - Remove all Kubernetes resources"
    echo "  status   - Show status of deployed resources"
    echo
}

# Function to show status
show_status() {
    echo "=========================================="
    echo "Lab Project Deployment Status"
    echo "=========================================="
    echo
    
    if kubectl get namespace lab-project &> /dev/null; then
        print_status "Namespace exists"
        echo
        kubectl get all -n lab-project
        echo
        kubectl get ingress -n lab-project
        echo
        kubectl get pvc -n lab-project
        echo
        kubectl get secrets -n lab-project
    else
        print_warning "Namespace 'lab-project' does not exist. Run 'deploy' first."
    fi
}

# Main script logic
case "${1:-deploy}" in
    deploy)
        main
        ;;
    cleanup)
        cleanup
        ;;
    status)
        show_status
        ;;
    *)
        usage
        exit 1
        ;;
esac 