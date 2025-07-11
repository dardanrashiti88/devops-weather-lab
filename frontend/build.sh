#!/bin/bash

# High-quality Docker build script for Weather App Frontend
# Usage: ./build.sh [production|development|all]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="weather-frontend"
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "latest")
REGISTRY=""

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Build production image
build_production() {
    log_info "Building production image..."
    
    # Build with BuildKit for better performance
    DOCKER_BUILDKIT=1 docker build \
        --target production \
        --tag "${REGISTRY}${IMAGE_NAME}:${VERSION}" \
        --tag "${REGISTRY}${IMAGE_NAME}:latest" \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        --cache-from "${REGISTRY}${IMAGE_NAME}:latest" \
        .
    
    log_success "Production image built successfully!"
}

# Build development image
build_development() {
    log_info "Building development image..."
    
    DOCKER_BUILDKIT=1 docker build \
        --target development \
        --tag "${REGISTRY}${IMAGE_NAME}:dev-${VERSION}" \
        --tag "${REGISTRY}${IMAGE_NAME}:dev" \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        --cache-from "${REGISTRY}${IMAGE_NAME}:dev" \
        .
    
    log_success "Development image built successfully!"
}

# Build all images
build_all() {
    log_info "Building all images..."
    build_production
    build_development
    log_success "All images built successfully!"
}

# Security scan
security_scan() {
    log_info "Running security scan..."
    
    if command -v trivy > /dev/null 2>&1; then
        trivy image --severity HIGH,CRITICAL "${REGISTRY}${IMAGE_NAME}:${VERSION}"
    else
        log_warning "Trivy not found. Install it for security scanning: https://aquasecurity.github.io/trivy/"
    fi
}

# Push images
push_images() {
    if [ -n "$REGISTRY" ]; then
        log_info "Pushing images to registry..."
        docker push "${REGISTRY}${IMAGE_NAME}:${VERSION}"
        docker push "${REGISTRY}${IMAGE_NAME}:latest"
        docker push "${REGISTRY}${IMAGE_NAME}:dev-${VERSION}"
        docker push "${REGISTRY}${IMAGE_NAME}:dev"
        log_success "Images pushed successfully!"
    else
        log_warning "No registry specified. Images will not be pushed."
    fi
}

# Clean up old images
cleanup() {
    log_info "Cleaning up old images..."
    docker image prune -f
    log_success "Cleanup completed!"
}

# Show image info
show_info() {
    log_info "Image information:"
    echo "  Name: ${REGISTRY}${IMAGE_NAME}"
    echo "  Version: ${VERSION}"
    echo "  Production: ${REGISTRY}${IMAGE_NAME}:${VERSION}"
    echo "  Development: ${REGISTRY}${IMAGE_NAME}:dev-${VERSION}"
    echo ""
    docker images | grep "${IMAGE_NAME}" || true
}

# Main execution
main() {
    log_info "Starting Docker build for Weather App Frontend"
    log_info "Version: ${VERSION}"
    
    check_docker
    
    case "${1:-production}" in
        "production")
            build_production
            ;;
        "development")
            build_development
            ;;
        "all")
            build_all
            ;;
        "push")
            build_all
            push_images
            ;;
        "clean")
            cleanup
            ;;
        "info")
            show_info
            ;;
        *)
            log_error "Usage: $0 [production|development|all|push|clean|info]"
            exit 1
            ;;
    esac
    
    if [ "$1" != "clean" ] && [ "$1" != "info" ]; then
        security_scan
        show_info
    fi
    
    log_success "Build process completed!"
}

# Run main function
main "$@" 