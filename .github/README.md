# 🚀 Enterprise CI/CD Pipeline Documentation

This repository contains a comprehensive, enterprise-grade CI/CD pipeline for Kubernetes deployment with advanced security, testing, and monitoring capabilities.

---

## 📋 Pipeline Overview

### Main Workflows in `.github/workflows/`

- **ci-cd-pipeline.yml**: The main orchestrator for end-to-end CI/CD, including security, quality, build, deployment, monitoring, and cleanup. Supports both staging and production deployments via manual trigger.
- **enterprise-cicd-pipeline-kubernetes.yml**: Minimal workflow for direct staging deployment, triggered on push to `main` or manually. Useful for quick cluster deployments.
- **security.yml**: Dedicated security and compliance scanning, including Trivy, npm/yarn audit, Bandit (Python), and container image scans. Can be run manually.
- **performance.yml**: Performance and load testing using Artillery, Lighthouse CI, WebPageTest, and database performance checks. Runs on schedule, push, or manually.
- **staging-only.yml**: Fast path for staging deployments, with quick tests and build steps. Manually triggered.
- **production-only.yml**: Fast path for production deployments, with quick tests and build steps. Manually triggered.

---

### 🔄 Main Pipeline (`ci-cd-pipeline.yml`)
The main pipeline orchestrates the entire CI/CD process with the following stages:

1. **🔒 Security & Compliance Scan**
   - Trivy vulnerability scanning
   - npm audit (backend & frontend)
   - OWASP ZAP security testing (if app is available)
   - SARIF report uploads

2. **🧪 Code Quality & Testing**
   - Python and Node.js setup
   - (Optional) SonarQube analysis
   - Backend and frontend lint, coverage, and integration tests
   - Codecov coverage upload

3. **🏗️ Build & Package**
   - Multi-platform Docker builds (backend & frontend)
   - Helm chart packaging and artifact upload

4. **🚀 Staging Deployment**
   - Deploys to staging on `develop` branch or manual trigger
   - Helm upgrade/install
   - Integration tests and health checks

5. **🚀 Production Deployment**
   - Deploys to production on `main` branch or manual trigger
   - Database backup before deployment
   - Helm upgrade/install with resource and autoscaling settings
   - Smoke tests and health checks
   - Slack notification

6. **📊 Monitoring & Alerts**
   - Deploys monitoring stack (Prometheus, Grafana, AlertManager)
   - Configures alerts via AlertManager

7. **🧹 Cleanup & Maintenance**
   - Docker image and backup cleanup
   - Metrics update

---

### 🛠️ Other Workflows

- **enterprise-cicd-pipeline-kubernetes.yml**: Simple Helm-based deployment to staging, triggered on push to `main` or manually. Checks for `KUBE_CLUSTER_CONFIGURED` secret.
- **security.yml**: Manual or scheduled security scanning, including Trivy, npm/yarn audit, Bandit, and container image scans. Uploads SARIF and Bandit reports as artifacts.
- **performance.yml**: Load, stress, and performance testing using Artillery, Lighthouse CI, WebPageTest, and MySQL performance checks. Runs on push, schedule, or manually. Uploads performance and memory reports.
- **staging-only.yml**: Fast staging deployment with quick lint/build/test and image build, then deploys to staging. Manually triggered.
- **production-only.yml**: Fast production deployment with quick lint/build/test and image build, then deploys to production. Manually triggered.

---

## 🚀 Usage

### Manual Deployment

```bash
# Deploy to staging (main pipeline)
gh workflow run ci-cd-pipeline.yml -f environment=staging

# Deploy to production (main pipeline)
gh workflow run ci-cd-pipeline.yml -f environment=production

# Run fast-path staging deployment
gh workflow run staging-only.yml

# Run fast-path production deployment
gh workflow run production-only.yml

# Run security scan
gh workflow run security.yml

# Run performance tests
gh workflow run performance.yml
```

### Automated Deployment

- **ci-cd-pipeline.yml**: Currently only triggers on manual dispatch (auto-triggers are commented out to reduce workflow spam).
- **enterprise-cicd-pipeline-kubernetes.yml**: Triggers on push to `main` or manual dispatch.
- **performance.yml**: Triggers on push to `main`/`develop`, on schedule, or manually.
- **security.yml**: Manual or scheduled only.
- **staging-only.yml** and **production-only.yml**: Manual only.

### Branch Strategy

```
main          → Production deployment
develop       → Staging deployment
feature/*     → Development and testing
hotfix/*      → Emergency fixes
```

---

## 🔧 Required Secrets

Configure the following secrets in your GitHub repository:

### Core Secrets
```bash
# Kubernetes Configuration
KUBE_CONFIG_DATA=<base64-encoded-kubeconfig>

# Container Registry
github_token=<github-personal-access-token>

# Security Tools (Optional)
# SNYK_TOKEN=<snyk-api-token>  # No longer available for free
SONAR_TOKEN=<sonarqube-token>
SONAR_HOST_URL=<sonarqube-host-url>

# Monitoring
ALERTMANAGER_URL=<alertmanager-url>
SLACK_WEBHOOK=<slack-webhook-url>

# Performance Testing
WEBPAGETEST_API_KEY=<webpagetest-api-key>
```

### Optional Secrets
```bash
# Additional Security
TRIVY_USERNAME=<trivy-username>
TRIVY_PASSWORD=<trivy-password>

# External Services
DATADOG_API_KEY=<datadog-api-key>
NEW_RELIC_LICENSE_KEY=<newrelic-license-key>
```

---

## 🛠️ Setup Instructions

### 1. Repository Configuration

```bash
# Clone the repository
git clone https://github.com/your-username/lab-project.git
cd lab-project

# Set up branch protection rules
# - Require status checks to pass
# - Require branches to be up to date
# - Require pull request reviews
```

### 2. Kubernetes Cluster Setup

```bash
# Create namespaces
kubectl create namespace staging
kubectl create namespace production
kubectl create namespace monitoring

# Install required operators
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Configure storage classes
kubectl apply -f k8s/storage/
```

### 3. Helm Chart Setup

```bash
# Add required Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install monitoring stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values helm/monitoring-values.yaml
```

---

## 📊 Monitoring & Observability

- **Application Metrics**: Custom business metrics
- **Infrastructure Metrics**: CPU, memory, disk usage
- **Database Metrics**: Query performance, connections
- **Network Metrics**: Latency, throughput, errors
- **Dashboards**: Prometheus, Grafana
- **Alerting**: AlertManager, Slack notifications

---

## 🔒 Security Features

- **Trivy**: Filesystem and container image scanning
- **npm/yarn audit**: Dependency vulnerability checks
- **OWASP ZAP**: Dynamic application security testing
- **Bandit**: Python code security analysis
- **SARIF**: Security report uploads

---

## 🧪 Testing & Performance

- **Unit, Integration, and Smoke Tests**: For backend and frontend
- **Artillery**: Load and stress testing
- **Lighthouse CI**: Web performance audits
- **WebPageTest**: External performance validation
- **MySQL Performance**: Database checks and reports

---

## 🛠️ Troubleshooting

- Use `gh run list` and `gh run view <run-id> --log` to check workflow status and logs
- Use `kubectl` for pod/service/ingress status and logs
- Use port-forwarding for Prometheus, Grafana, and AlertManager
- See workflow logs for detailed error messages and artifact uploads

---

## 🤝 Contributing

- Create feature branches from `develop`
- Run local validation and tests
- Ensure all checks pass before PR
- Update documentation as needed
- Follow security and performance guidelines

---

**Last Updated**: July 2024
**Version**: 1.1.0
**Maintainer**: DevOps Team 