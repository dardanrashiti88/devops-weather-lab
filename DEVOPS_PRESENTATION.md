# 🚀 Enterprise DevOps & Cloud Infrastructure Presentation
## Lab Project - Modern Full-Stack Application

---

## 📋 Agenda

1. **Project Overview & Architecture**
2. **CI/CD Pipeline & Automation**
3. **Containerization with Docker**
4. **Kubernetes Orchestration**
5. **Database Management & Monitoring**
6. **Cloud Infrastructure (Azure/AWS)**
7. **Monitoring & Observability**
8. **Security & Compliance**
9. **Deployment Strategies**
10. **Best Practices & Lessons Learned**

---

## 🏗️ Project Overview & Architecture

### **Multi-Environment Deployment Strategy**
- **Development**: Docker Compose (Local)
- **Staging**: Kubernetes (On-prem/Cloud)
- **Production**: Azure Container Apps + Kubernetes
- **Infrastructure**: Terraform IaC

### **Technology Stack**
```
Frontend: React + Vite + TypeScript
Backend: Node.js + Express + MySQL
Database: MySQL 8.0 + Monitoring
Monitoring: Prometheus + Grafana + Node Exporter
Containerization: Docker + Multi-stage builds
Orchestration: Kubernetes + Helm
Cloud: Azure Container Registry + Container Apps
CI/CD: GitHub Actions + ArgoCD
```

---

## 🔄 CI/CD Pipeline & Automation

### **GitHub Actions Workflow Architecture**

```yaml
# Multi-Stage Pipeline
1. Security & Compliance Scan
2. Code Quality & Testing
3. Container Build & Security Scan
4. Infrastructure Validation
5. Deployment (Staging/Production)
6. Post-Deployment Verification
```

### **Key Pipeline Features**

#### **🔒 Security & Compliance**
- **Trivy Vulnerability Scanner**: Container & code scanning
- **npm audit**: Dependency vulnerability checks
- **CodeQL**: Static code analysis
- **SARIF Integration**: Security reporting

#### **🧪 Testing & Quality**
- **Unit Tests**: Backend & Frontend
- **Integration Tests**: API endpoints
- **Performance Tests**: Artillery.js load testing
- **Code Coverage**: Jest coverage reports

#### **📦 Container Management**
- **Multi-stage Docker builds**
- **Container registry**: GitHub Container Registry
- **Image signing**: Cosign for supply chain security
- **Automated tagging**: Semantic versioning

---

## 🐳 Containerization with Docker

### **Multi-Stage Dockerfile Strategy**

```dockerfile
# Frontend - Production Optimized
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM nginx:alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
```

### **Docker Compose Architecture**

```yaml
services:
  backend:
    build: ./backend
    ports: ["4000:4000"]
    environment:
      - MYSQL_HOST=mysql-db
    depends_on:
      - mysql-db
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:4000/health"]
      
  mysql-db:
    image: mysql:8
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
      - ./db:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD", "mysqladmin", "ping"]
```

### **Key Docker Features**
- **Health Checks**: All services with proper health monitoring
- **Volume Management**: Persistent data storage
- **Network Isolation**: Custom networks for security
- **Environment Variables**: Secure configuration management
- **Resource Limits**: CPU/Memory constraints

---

## ☸️ Kubernetes Orchestration

### **Cluster Architecture**

```yaml
# Namespace Isolation
apiVersion: v1
kind: Namespace
metadata:
  name: lab-project
  labels:
    environment: production
```

### **Deployment Strategy**

#### **Backend Deployment**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: lab-project
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    spec:
      containers:
      - name: backend
        image: ghcr.io/org/lab-project:latest
        ports:
        - containerPort: 4000
        env:
        - name: MYSQL_HOST
          value: mysql-db
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 4000
          initialDelaySeconds: 30
          periodSeconds: 10
```

### **Service Mesh & Networking**

#### **Ingress Configuration**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: lab-project-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - frontend.local
    - backend.local
    secretName: lab-project-tls
  rules:
  - host: frontend.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
```

### **Persistent Storage**
```yaml
# MySQL Persistent Volume
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: managed-premium
```

---

## 🗄️ Database Management & Monitoring

### **MySQL Architecture**

#### **Database Schema**
```sql
-- Core Tables
CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    level ENUM('junior', 'mid', 'senior', 'lead')
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    team_id INT,
    role_id INT,
    manager_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
```

#### **Monitoring Integration**
```yaml
# MySQL Exporter Configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-exporter-config
data:
  .my.cnf: |
    [client]
    host=mysql-db
    port=3306
    user=exporter
    password=${MYSQL_EXPORTER_PASSWORD}
```

### **Database Backup Strategy**
```yaml
# CronJob for Automated Backups
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mysql-backup
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: mysql:8
            command:
            - /bin/bash
            - -c
            - |
              mysqldump -h mysql-db -u root -p${MYSQL_ROOT_PASSWORD} \
                --all-databases > /backup/backup-$(date +%Y%m%d).sql
            volumeMounts:
            - name: backup-volume
              mountPath: /backup
          volumes:
          - name: backup-volume
            persistentVolumeClaim:
              claimName: backup-pvc
```

---

## ☁️ Cloud Infrastructure (Azure/AWS)

### **Terraform Infrastructure as Code**

#### **Azure Container Registry**
```hcl
# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
  
  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = var.allowed_ip_ranges
    }
  }
}
```

#### **Azure Container Apps**
```hcl
# Backend Container App
resource "azurerm_container_app" "backend" {
  name                         = "backend-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      image  = "${azurerm_container_registry.acr.login_server}/backend:latest"
      cpu    = 0.5
      memory = "1Gi"
      
      env {
        name  = "MYSQL_HOST"
        value = azurerm_mysql_server.mysql.fqdn
      }
    }
  }

  ingress {
    external_enabled = true
    target_port     = 4000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
```

#### **Azure MySQL Database**
```hcl
# MySQL Server
resource "azurerm_mysql_server" "mysql" {
  name                = var.mysql_server_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = var.mysql_admin_username
  administrator_login_password = var.mysql_admin_password

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "8.0"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
}
```

### **Multi-Cloud Strategy**
- **Primary**: Azure Container Apps + Azure MySQL
- **Secondary**: AWS EKS + RDS (Terraform modules)
- **Disaster Recovery**: Cross-region replication
- **Cost Optimization**: Spot instances for non-critical workloads

---

## 📊 Monitoring & Observability

### **Prometheus Configuration**
```yaml
# Prometheus Targets
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'backend'
    static_configs:
      - targets: ['backend:4000']
    metrics_path: '/metrics'
    
  - job_name: 'mysql-exporter'
    static_configs:
      - targets: ['mysql-exporter:9104']
      
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

### **Grafana Dashboards**
- **Application Metrics**: Response times, error rates, throughput
- **Infrastructure Metrics**: CPU, memory, disk, network
- **Database Metrics**: Connections, queries, performance
- **Business Metrics**: User activity, feature usage

### **Alerting Rules**
```yaml
# Kubernetes Alerting
groups:
  - name: kubernetes.rules
    rules:
      - alert: HighCPUUsage
        expr: container_cpu_usage_seconds_total > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          
      - alert: DatabaseConnectionHigh
        expr: mysql_global_status_threads_connected > 100
        for: 2m
        labels:
          severity: critical
```

---

## 🔐 Security & Compliance

### **Security Measures**

#### **Container Security**
- **Image Scanning**: Trivy vulnerability scanning
- **Base Image**: Alpine Linux (minimal attack surface)
- **Non-root User**: Application runs as non-root
- **Secrets Management**: Kubernetes secrets + Azure Key Vault

#### **Network Security**
- **Network Policies**: Pod-to-pod communication control
- **Ingress Security**: TLS termination + rate limiting
- **Service Mesh**: mTLS encryption between services

#### **Database Security**
- **Encryption at Rest**: Azure Disk Encryption
- **Encryption in Transit**: TLS 1.3
- **Access Control**: RBAC + Azure AD integration
- **Audit Logging**: Database activity monitoring

### **Compliance Features**
- **GDPR Compliance**: Data residency controls
- **SOC 2**: Security controls implementation
- **PCI DSS**: Payment data protection (if applicable)
- **Audit Trails**: Complete activity logging

---

## 🚀 Deployment Strategies

### **Blue-Green Deployment**
```yaml
# ArgoCD Application
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: lab-project
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/lab-project
    targetRevision: HEAD
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: lab-project
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

### **Canary Deployment**
```yaml
# Istio Virtual Service
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: backend-vs
spec:
  hosts:
  - backend.local
  http:
  - route:
    - destination:
        host: backend
        subset: v1
      weight: 90
    - destination:
        host: backend
        subset: v2
      weight: 10
```

### **Rolling Updates**
- **Strategy**: RollingUpdate with maxSurge=1, maxUnavailable=0
- **Health Checks**: Liveness + readiness probes
- **Rollback**: Automatic rollback on health check failures
- **Gradual Traffic**: Traffic shifting with service mesh

---

## 📈 Best Practices & Lessons Learned

### **Infrastructure Best Practices**

#### **Resource Management**
- **Resource Limits**: Always set CPU/memory limits
- **Horizontal Pod Autoscaling**: Based on CPU/memory usage
- **Vertical Pod Autoscaling**: Automatic resource optimization
- **Cluster Autoscaling**: Node pool scaling based on demand

#### **Monitoring & Alerting**
- **SLI/SLO Definition**: Service level indicators/objectives
- **Error Budget**: Track error rates and availability
- **Golden Signals**: Latency, traffic, errors, saturation
- **Runbooks**: Automated incident response

#### **Security Hardening**
- **Pod Security Standards**: Enforce security policies
- **Network Policies**: Zero-trust network model
- **RBAC**: Least privilege access control
- **Secret Rotation**: Automated credential management

### **CI/CD Best Practices**

#### **Pipeline Optimization**
- **Parallel Execution**: Run independent jobs in parallel
- **Caching**: Docker layer caching + npm cache
- **Artifact Management**: Store and version artifacts
- **Environment Promotion**: Automated promotion between environments

#### **Quality Gates**
- **Code Coverage**: Minimum 80% coverage requirement
- **Security Scanning**: Block deployment on critical vulnerabilities
- **Performance Tests**: Load testing before production
- **Compliance Checks**: Automated compliance validation

### **Cost Optimization**
- **Right-sizing**: Optimize resource requests/limits
- **Spot Instances**: Use for non-critical workloads
- **Reserved Instances**: Commit to long-term usage
- **Resource Tagging**: Track costs by team/project

---

## 🎯 Key Takeaways

### **Architecture Benefits**
1. **Scalability**: Horizontal scaling with Kubernetes
2. **Reliability**: Multi-environment deployment strategy
3. **Security**: Defense in depth approach
4. **Observability**: Complete monitoring stack
5. **Automation**: Full CI/CD pipeline

### **Business Value**
- **Faster Time to Market**: Automated deployments
- **Reduced Downtime**: Blue-green deployments
- **Cost Efficiency**: Resource optimization
- **Compliance**: Built-in security controls
- **Developer Productivity**: Self-service deployments

### **Future Roadmap**
- **Service Mesh**: Istio for advanced traffic management
- **GitOps**: ArgoCD for declarative deployments
- **Multi-cluster**: Federation for global deployment
- **Serverless**: Azure Functions integration
- **AI/ML**: Automated anomaly detection

---

## 📞 Questions & Discussion

### **Contact Information**
- **GitHub**: [Project Repository]
- **Documentation**: [Wiki/README]
- **Issues**: [GitHub Issues]
- **Slack**: [Team Channel]

### **Resources**
- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **Azure Container Apps**: https://docs.microsoft.com/en-us/azure/container-apps/
- **Terraform Best Practices**: https://www.terraform.io/docs/cloud/guides/recommended-practices/
- **Prometheus Monitoring**: https://prometheus.io/docs/

---

*Thank you for your attention! 🚀*