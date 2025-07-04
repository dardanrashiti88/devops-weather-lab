#!/bin/bash

# Lab Project Kubernetes Cleanup Script
# This script deletes all resources in the lab-project namespace

set -e

NAMESPACE="lab-project"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

print_status "Deleting all resources in namespace: $NAMESPACE..."

if kubectl get namespace $NAMESPACE &> /dev/null; then
    kubectl delete namespace $NAMESPACE
    print_success "Namespace '$NAMESPACE' and all its resources deleted."
else
    print_status "Namespace '$NAMESPACE' does not exist. Nothing to delete."
fi 