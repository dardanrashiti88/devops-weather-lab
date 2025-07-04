# Lab Project Makefile
# Provides easy commands for managing the lab environment

.PHONY: help build deploy start stop status logs clean test backup restore

# Default target
.DEFAULT_GOAL := help

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Variables
PROJECT_NAME := lab-project
NAMESPACE := lab-project
BACKEND_IMAGE := lab-backend:latest
DOCKER_COMPOSE_FILE := docker-compose.yaml
FRONTEND_IMAGE := lab-frontend:latest

# Help target
help: ## Show this help message
	@echo "$(BLUE)Lab Project Management Commands$(NC)"
	@echo "=================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make build          # Build backend Docker image"
	@echo "  make start          # Start environment (auto-detect)"
	@echo "  make start-docker   # Start with Docker Compose"
	@echo "  make start-k8s      # Start with Kubernetes"
	@echo "  make status         # Show environment status"
	@echo "  make logs           # Show logs"
	@echo "  make stop           # Stop environment"
	@echo "  make clean          # Clean up everything"

# Build targets
build: ## Build backend Docker image
	@echo "$(BLUE)Building backend Docker image...$(NC)"
	docker build -t $(BACKEND_IMAGE) backend/
	@echo "$(GREEN)Backend image built successfully!$(NC)"

build-frontend: ## Build frontend Docker image
	@echo "$(BLUE)Building frontend Docker image...$(NC)"
	docker build -t $(FRONTEND_IMAGE) frontend/
	@echo "$(GREEN)Frontend image built successfully!$(NC)"

build-minikube: ## Build backend image for minikube
	@echo "$(BLUE)Building backend image for minikube...$(NC)"
	eval $$(minikube docker-env) && docker build -t $(BACKEND_IMAGE) backend/
	@echo "$(GREEN)Backend image built for minikube!$(NC)"

build-frontend-minikube: ## Build frontend image for minikube
	@echo "$(BLUE)Building frontend image for minikube...$(NC)"
	eval $$(minikube docker-env) && docker build -t $(FRONTEND_IMAGE) frontend/
	@echo "$(GREEN)Frontend image built for minikube!$(NC)"

# Start targets
start: ## Start environment (auto-detect best option)
	@echo "$(BLUE)Starting environment with auto-detection...$(NC)"
	./scripts/start.sh

start-docker: ## Start environment with Docker Compose
	@echo "$(BLUE)Starting environment with Docker Compose...$(NC)"
	./scripts/start.sh docker

start-k8s: ## Start environment with Kubernetes
	@echo "$(BLUE)Starting environment with Kubernetes...$(NC)"
	./scripts/start.sh k8s

# Stop targets
stop: ## Stop environment (auto-detect)
	@echo "$(BLUE)Stopping environment...$(NC)"
	./scripts/stop.sh

stop-docker: ## Stop Docker Compose environment
	@echo "$(BLUE)Stopping Docker Compose environment...$(NC)"
	./scripts/stop.sh docker

stop-k8s: ## Stop Kubernetes environment
	@echo "$(BLUE)Stopping Kubernetes environment...$(NC)"
	./scripts/stop.sh k8s

stop-all: ## Stop all environments
	@echo "$(BLUE)Stopping all environments...$(NC)"
	./scripts/stop.sh all

# Status targets
status: ## Show environment status
	@echo "$(BLUE)Checking environment status...$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ]; then \
		echo "$(YELLOW)Docker Compose Status:$(NC)"; \
		docker-compose ps 2>/dev/null || echo "Docker Compose not running"; \
		echo ""; \
	fi
	@if command -v kubectl >/dev/null 2>&1; then \
		echo "$(YELLOW)Kubernetes Status:$(NC)"; \
		kubectl get all -n $(NAMESPACE) 2>/dev/null || echo "Kubernetes namespace not found"; \
		echo ""; \
		echo "$(YELLOW)CronJob Status:$(NC)"; \
		kubectl get cronjobs -n $(NAMESPACE) 2>/dev/null || echo "No CronJobs found"; \
	fi

status-docker: ## Show Docker Compose status
	@echo "$(BLUE)Docker Compose Status:$(NC)"
	docker-compose ps

status-k8s: ## Show Kubernetes status
	@echo "$(BLUE)Kubernetes Status:$(NC)"
	kubectl get all -n $(NAMESPACE)
	@echo ""
	@echo "$(BLUE)CronJob Status:$(NC)"
	kubectl get cronjobs -n $(NAMESPACE)

# Logs targets
logs: ## Show logs (auto-detect)
	@echo "$(BLUE)Showing logs...$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		docker-compose logs -f; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl logs -f deployment/backend -n $(NAMESPACE); \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi

logs-docker: ## Show Docker Compose logs
	@echo "$(BLUE)Docker Compose Logs:$(NC)"
	docker-compose logs -f

logs-backend: ## Show backend logs
	@echo "$(BLUE)Backend Logs:$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		docker-compose logs -f backend; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl logs -f deployment/backend -n $(NAMESPACE); \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi

logs-mysql: ## Show MySQL logs
	@echo "$(BLUE)MySQL Logs:$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		docker-compose logs -f mysql-db; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl logs -f deployment/mysql -n $(NAMESPACE); \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi

logs-frontend: ## Show frontend logs
	@echo "$(BLUE)Frontend Logs:$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		docker-compose logs -f frontend; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl logs -f deployment/frontend -n $(NAMESPACE); \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi

# CronJob targets
cronjob-status: ## Show CronJob status
	@echo "$(BLUE)CronJob Status:$(NC)"
	cd k8s && ./manage-cronjob.sh status

cronjob-run: ## Run CronJob manually
	@echo "$(BLUE)Running CronJob manually...$(NC)"
	cd k8s && ./manage-cronjob.sh run simple

cronjob-run-advanced: ## Run advanced CronJob manually
	@echo "$(BLUE)Running advanced CronJob manually...$(NC)"
	cd k8s && ./manage-cronjob.sh run advanced

cronjob-logs: ## Show CronJob logs
	@echo "$(BLUE)CronJob Logs:$(NC)"
	cd k8s && ./manage-cronjob.sh logs simple

cronjob-logs-advanced: ## Show advanced CronJob logs
	@echo "$(BLUE)Advanced CronJob Logs:$(NC)"
	cd k8s && ./manage-cronjob.sh logs advanced

cronjob-suspend: ## Suspend CronJob
	@echo "$(BLUE)Suspending CronJob...$(NC)"
	cd k8s && ./manage-cronjob.sh suspend simple

cronjob-resume: ## Resume CronJob
	@echo "$(BLUE)Resuming CronJob...$(NC)"
	cd k8s && ./manage-cronjob.sh resume simple

# Deploy targets
deploy: ## Deploy to Kubernetes
	@echo "$(BLUE)Deploying to Kubernetes...$(NC)"
	cd k8s && ./deploy.sh

deploy-azure: ## Deploy to Azure (Terraform)
	@echo "$(BLUE)Deploying to Azure...$(NC)"
	cd terraform && terraform init && terraform apply

deploy-frontend: ## Deploy only frontend to Kubernetes
	@echo "$(BLUE)Deploying frontend to Kubernetes...$(NC)"
	cd k8s && kubectl apply -f frontend-deployment.yaml && kubectl apply -f frontend-service.yaml
	@echo "$(GREEN)Frontend deployed to Kubernetes!$(NC)"

# Test targets
test: ## Run tests
	@echo "$(BLUE)Running tests...$(NC)"
	@echo "$(YELLOW)No tests configured yet$(NC)"

test-backend: ## Test backend connectivity
	@echo "$(BLUE)Testing backend connectivity...$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		curl -f http://localhost:3000/health || echo "$(RED)Backend not responding$(NC)"; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl port-forward svc/backend 8080:80 -n $(NAMESPACE) --address=0.0.0.0 & \
		sleep 3 && \
		curl -f http://localhost:8080/health || echo "$(RED)Backend not responding$(NC)"; \
		pkill -f "kubectl port-forward"; \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi

test-frontend: ## Test frontend connectivity
	@echo "$(BLUE)Testing frontend connectivity...$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		curl -f http://localhost:5173 || echo "$(RED)Frontend not responding$(NC)"; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl port-forward svc/frontend 8081:80 -n $(NAMESPACE) --address=0.0.0.0 & \
		sleep 3 && \
		curl -f http://localhost:8081 || echo "$(RED)Frontend not responding$(NC)"; \
		pkill -f "kubectl port-forward"; \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi

# Backup and restore targets
backup: ## Create database backup
	@echo "$(BLUE)Creating database backup...$(NC)"
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		docker-compose exec mysql-db mysqldump -u root -p$$MYSQL_ROOT_PASSWORD lab_db > backup_$$(date +%Y%m%d_%H%M%S).sql; \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl exec deployment/mysql -n $(NAMESPACE) -- mysqldump -u mysqladmin -p$$(kubectl get secret mysql-secret -n $(NAMESPACE) -o jsonpath='{.data.mysql-root-password}' | base64 -d) lab_db > backup_$$(date +%Y%m%d_%H%M%S).sql; \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi
	@echo "$(GREEN)Backup created!$(NC)"

restore: ## Restore database from backup
	@echo "$(BLUE)Restoring database from backup...$(NC)"
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "$(RED)Please specify backup file: make restore BACKUP_FILE=backup_20231201_120000.sql$(NC)"; \
		exit 1; \
	fi
	@if [ -f "$(DOCKER_COMPOSE_FILE)" ] && docker-compose ps | grep -q "Up"; then \
		docker-compose exec -T mysql-db mysql -u root -p$$MYSQL_ROOT_PASSWORD lab_db < $(BACKUP_FILE); \
	elif command -v kubectl >/dev/null 2>&1 && kubectl get namespace $(NAMESPACE) >/dev/null 2>&1; then \
		kubectl exec -i deployment/mysql -n $(NAMESPACE) -- mysql -u mysqladmin -p$$(kubectl get secret mysql-secret -n $(NAMESPACE) -o jsonpath='{.data.mysql-root-password}' | base64 -d) lab_db < $(BACKUP_FILE); \
	else \
		echo "$(YELLOW)No running environment detected$(NC)"; \
	fi
	@echo "$(GREEN)Database restored!$(NC)"

# Cleanup targets
clean: ## Clean up everything
	@echo "$(BLUE)Cleaning up everything...$(NC)"
	./scripts/stop.sh all
	@echo "$(GREEN)Cleanup completed!$(NC)"

clean-docker: ## Clean up Docker resources
	@echo "$(BLUE)Cleaning up Docker resources...$(NC)"
	docker-compose down -v --remove-orphans
	docker system prune -f
	@echo "$(GREEN)Docker cleanup completed!$(NC)"

clean-k8s: ## Clean up Kubernetes resources
	@echo "$(BLUE)Cleaning up Kubernetes resources...$(NC)"
	cd k8s && ./delete-all.sh
	@echo "$(GREEN)Kubernetes cleanup completed!$(NC)"

clean-images: ## Remove Docker images
	@echo "$(BLUE)Removing Docker images...$(NC)"
	docker rmi $(BACKEND_IMAGE) 2>/dev/null || true
	docker system prune -f
	@echo "$(GREEN)Images cleaned!$(NC)"

# Development targets
dev: ## Start development environment
	@echo "$(BLUE)Starting development environment...$(NC)"
	make build
	make start-docker
	@echo "$(GREEN)Development environment ready!$(NC)"

dev-k8s: ## Start development environment with Kubernetes
	@echo "$(BLUE)Starting development environment with Kubernetes...$(NC)"
	make build-minikube
	make start-k8s
	@echo "$(GREEN)Kubernetes development environment ready!$(NC)"

# Port forwarding targets
port-forward: ## Set up port forwarding for Kubernetes
	@echo "$(BLUE)Setting up port forwarding...$(NC)"
	@echo "$(YELLOW)Backend: http://localhost:8080$(NC)"
	@echo "$(YELLOW)Prometheus: http://localhost:9090$(NC)"
	@echo "$(YELLOW)Grafana: http://localhost:3000$(NC)"
	@echo "$(YELLOW)Press Ctrl+C to stop$(NC)"
	kubectl port-forward svc/backend 8080:80 -n $(NAMESPACE) & \
	kubectl port-forward svc/prometheus 9090:9090 -n $(NAMESPACE) & \
	kubectl port-forward svc/grafana 3000:3000 -n $(NAMESPACE) & \
	wait

# Utility targets
check-prereqs: ## Check prerequisites
	@echo "$(BLUE)Checking prerequisites...$(NC)"
	@command -v docker >/dev/null 2>&1 || { echo "$(RED)Docker is not installed$(NC)"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "$(RED)Docker Compose is not installed$(NC)"; exit 1; }
	@echo "$(GREEN)Prerequisites check passed!$(NC)"

check-k8s: ## Check Kubernetes prerequisites
	@echo "$(BLUE)Checking Kubernetes prerequisites...$(NC)"
	@command -v kubectl >/dev/null 2>&1 || { echo "$(RED)kubectl is not installed$(NC)"; exit 1; }
	@kubectl cluster-info >/dev/null 2>&1 || { echo "$(RED)Cannot connect to Kubernetes cluster$(NC)"; exit 1; }
	@echo "$(GREEN)Kubernetes prerequisites check passed!$(NC)"

version: ## Show version information
	@echo "$(BLUE)Lab Project Version Information$(NC)"
	@echo "Docker: $$(docker --version)"
	@echo "Docker Compose: $$(docker-compose --version)"
	@echo "Kubectl: $$(kubectl version --client --short 2>/dev/null || echo 'Not installed')"
	@echo "Make: $$(make --version | head -n1)"

# Quick access targets
up: start ## Alias for start
down: stop ## Alias for stop
ps: status ## Alias for status 