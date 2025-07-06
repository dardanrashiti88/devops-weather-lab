# 🚀 Enterprise CI/CD Pipeline Documentation

This repository contains a comprehensive, enterprise-grade CI/CD pipeline for Kubernetes deployment with advanced security, testing, and monitoring capabilities.

## 📋 Pipeline Overview

### 🔄 Main Pipeline (`ci-cd-pipeline.yml`)
The main pipeline orchestrates the entire CI/CD process with the following stages:

1. **🔒 Security & Compliance Scan**
   - Trivy vulnerability scanning
   - Snyk dependency analysis
   - OWASP ZAP security testing
   - CodeQL analysis

2. **🧪 Code Quality & Testing**
   - SonarQube analysis
   - Unit and integration tests
   - Code coverage reporting
   - Linting and code quality checks

3. **🏗️ Build & Package**
   - Multi-platform Docker builds
   - Helm chart packaging
   - Container registry push
   - Build caching optimization

4. **🚀 Staging Deployment**
   - Automated staging deployment
   - Integration testing
   - Health checks
   - Performance validation

5. **🚀 Production Deployment**
   - Blue-green deployment
   - Database backups
   - Smoke testing
   - Monitoring setup

6. **📊 Monitoring & Alerts**
   - Prometheus/Grafana deployment
   - AlertManager configuration
   - Performance monitoring

7. **🧹 Cleanup & Maintenance**
   - Resource cleanup
   - Backup management
   - Metrics collection

## 🔧 Required Secrets

Configure the following secrets in your GitHub repository:

### Core Secrets
```bash
# Kubernetes Configuration
KUBE_CONFIG_DATA=<base64-encoded-kubeconfig>

# Container Registry
GITHUB_TOKEN=<github-personal-access-token>

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

## 🚀 Usage

### Manual Deployment

```bash
# Deploy to staging
gh workflow run ci-cd-pipeline.yml -f environment=staging

# Deploy to production
gh workflow run ci-cd-pipeline.yml -f environment=production
```

### Automated Deployment

The pipeline automatically triggers on:
- **Push to `main`**: Deploys to production
- **Push to `develop`**: Deploys to staging
- **Pull Request**: Runs tests and security scans
- **Tags**: Creates releases and deploys

### Branch Strategy

```
main          → Production deployment
develop       → Staging deployment
feature/*     → Development and testing
hotfix/*      → Emergency fixes
```

## 📊 Monitoring & Observability

### Metrics Collection
- **Application Metrics**: Custom business metrics
- **Infrastructure Metrics**: CPU, memory, disk usage
- **Database Metrics**: Query performance, connections
- **Network Metrics**: Latency, throughput, errors

### Alerting Rules
- **Critical**: Service down, high error rates
- **Warning**: High resource usage, slow response times
- **Info**: Deployment success, backup completion

### Dashboards
- **Application Overview**: Key business metrics
- **Infrastructure**: Cluster health and performance
- **Security**: Vulnerability and compliance status
- **Cost Analysis**: Resource utilization and costs

## 🔒 Security Features

### Vulnerability Scanning
- **Container Images**: Trivy scans for CVE vulnerabilities
- **Dependencies**: Snyk monitors for known vulnerabilities
- **Code Analysis**: CodeQL detects security issues
- **Runtime Protection**: OWASP ZAP tests running applications

### Compliance
- **Pod Security Standards**: Enforces security policies
- **Network Policies**: Controls pod-to-pod communication
- **RBAC**: Role-based access control
- **Secrets Management**: Secure credential storage

### Access Control
- **Service Accounts**: Least privilege principle
- **Network Policies**: Micro-segmentation
- **Ingress Security**: TLS termination and rate limiting

## 🧪 Testing Strategy

### Test Types
1. **Unit Tests**: Individual component testing
2. **Integration Tests**: Service interaction testing
3. **End-to-End Tests**: Full user journey testing
4. **Performance Tests**: Load and stress testing
5. **Security Tests**: Vulnerability and penetration testing

### Test Environments
- **Local**: Developer testing
- **CI**: Automated testing in pipeline
- **Staging**: Pre-production validation
- **Production**: Smoke testing after deployment

## 📈 Performance Optimization

### Build Optimization
- **Multi-stage Docker builds**: Reduced image size
- **Build caching**: Faster subsequent builds
- **Parallel execution**: Reduced pipeline time
- **Resource optimization**: Efficient resource usage

### Deployment Optimization
- **Blue-green deployment**: Zero-downtime updates
- **Rolling updates**: Gradual service updates
- **Auto-scaling**: Dynamic resource allocation
- **Load balancing**: Traffic distribution

### Monitoring Optimization
- **Metrics aggregation**: Centralized monitoring
- **Alert correlation**: Intelligent alerting
- **Performance baselines**: Trend analysis
- **Capacity planning**: Resource forecasting

## 🛠️ Troubleshooting

### Common Issues

#### Pipeline Failures
```bash
# Check pipeline status
gh run list --workflow=ci-cd-pipeline.yml

# View detailed logs
gh run view <run-id> --log

# Rerun failed jobs
gh run rerun <run-id>
```

#### Deployment Issues
```bash
# Check pod status
kubectl get pods -n production

# View pod logs
kubectl logs -f deployment/lab-project-backend -n production

# Check service status
kubectl get svc -n production

# Verify ingress
kubectl get ingress -n production
```

#### Monitoring Issues
```bash
# Check Prometheus targets
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring

# Check Grafana
kubectl port-forward svc/grafana 3000:3000 -n monitoring

# View alertmanager
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:9093 -n monitoring
```

### Debug Commands
```bash
# Check cluster health
kubectl get nodes
kubectl top nodes
kubectl top pods -A

# Check resource usage
kubectl describe node <node-name>
kubectl describe pod <pod-name> -n <namespace>

# Check network connectivity
kubectl exec -it <pod-name> -n <namespace> -- nslookup <service-name>
kubectl exec -it <pod-name> -n <namespace> -- curl <service-url>
```

## 📚 Additional Resources

### Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

### Tools
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Snyk Documentation](https://docs.snyk.io/)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Artillery Documentation](https://www.artillery.io/docs/)

### Best Practices
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/)
- [CI/CD Best Practices](https://www.gitops.tech/)
- [Monitoring Best Practices](https://prometheus.io/docs/practices/)
- [Performance Testing Best Practices](https://www.artillery.io/docs/guides/best-practices)

## 🤝 Contributing

### Development Workflow
1. Create feature branch from `develop`
2. Make changes and add tests
3. Run local validation
4. Create pull request
5. Address review feedback
6. Merge to `develop`

### Code Standards
- Follow linting rules
- Maintain test coverage > 80%
- Update documentation
- Follow security guidelines
- Performance considerations

### Review Process
- Automated checks must pass
- Security scan approval
- Performance test validation
- Documentation review
- Code review approval

## 📞 Support

For issues and questions:
- **GitHub Issues**: Create issue in repository
- **Documentation**: Check this README and linked docs
- **Community**: Join our Slack/Discord channels
- **Email**: Contact the DevOps team

---

**Last Updated**: July 2024  
**Version**: 1.0.0  
**Maintainer**: DevOps Team 