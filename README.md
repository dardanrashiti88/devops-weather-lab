# Lab Project

A complete lab environment with Node.js backend, MySQL database, Prometheus monitoring, and Grafana dashboards. Supports both Docker Compose and Kubernetes deployments.

## 🏗️ Architecture

- **Backend**: Node.js Express application
- **Database**: MySQL 8.0 with initialization scripts
- **Monitoring**: Prometheus + Grafana + MySQL Exporter
- **Deployment**: Docker Compose and Kubernetes support
- **Automation**: Daily maintenance CronJobs
- **Frontend**: React app (see below for deployment)

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- Kubernetes cluster (optional, for K8s deployment)
- kubectl (optional, for K8s deployment)

### Option 1: Docker Compose (Recommended for Development)

```bash
# Start the environment
docker-compose up --build frontend
# Or start all services
docker-compose up --build

# Stop the environment
docker-compose down
```

- **Frontend**: http://localhost:5173

### Option 2: Kubernetes (Recommended for Production)

```bash
cd k8s
# Build the frontend image
docker build -t lab-frontend:latest ../frontend
# Push to your registry if needed
# docker tag lab-frontend:latest your-registry/lab-frontend:latest
# docker push your-registry/lab-frontend:latest

# Deploy everything
./deploy.sh

# Check status
kubectl get all -n lab-project

# Clean up
./delete-all.sh
```

- **Frontend**: http://frontend.local (add to /etc/hosts)

### Option 3: Auto-detect (Recommended)

```bash
# Start (auto-detects best option)
./scripts/start.sh

# Stop (auto-detects running environments)
./scripts/stop.sh
```

## 📁 Project Structure

```
lab2/
├── backend/                 # Node.js application
│   ├── server.js           # Express server
│   ├── package.json        # Dependencies
│   └── Dockerfile          # Container image
├── db/                     # Database scripts
│   ├── 01-create-table.sql # Table creation
│   └── 02-seed-data.sql    # Sample data
├── monitoring/             # Monitoring configuration
│   └── prometheus.yml      # Prometheus config
├── scripts/                # Management scripts
│   ├── start.sh           # Start environment
│   └── stop.sh            # Stop environment
├── k8s/                    # Kubernetes manifests
│   ├── deploy.sh          # K8s deployment script
│   ├── delete-all.sh      # K8s cleanup script
│   ├── manage-cronjob.sh  # CronJob management
│   └── *.yaml             # K8s resource files
├── terraform/              # Terraform for Azure
│   ├── main.tf            # Azure resources
│   ├── variables.tf       # Input variables
│   └── outputs.tf         # Output values
└── docker-compose.yaml     # Docker Compose config
```

## 🕐 Automated Maintenance (CronJobs)

The project includes automated daily maintenance tasks that run at 2:00 AM.

### CronJob Types

1. **Simple Maintenance** (`daily-maintenance`)
   - Health checks for all services
   - Lightweight monitoring tasks

2. **Advanced Maintenance** (`daily-maintenance-advanced`)
   - Database backup using `mysqldump`
   - Database optimization (`OPTIMIZE TABLE`, `ANALYZE TABLE`)
   - Cleanup old backups (keeps last 7 days)
   - Comprehensive health monitoring

### Managing CronJobs

```bash
cd k8s

# Check CronJob status
./manage-cronjob.sh status
./manage-cronjob.sh status advanced

# Run maintenance manually
./manage-cronjob.sh run simple
./manage-cronjob.sh run advanced

# View execution logs
./manage-cronjob.sh logs simple
./manage-cronjob.sh logs advanced

# Suspend/Resume scheduled jobs
./manage-cronjob.sh suspend simple
./manage-cronjob.sh resume advanced

# Delete CronJob
./manage-cronjob.sh delete simple
```

### CronJob Schedule

- **Schedule**: `0 2 * * *` (2:00 AM every day)
- **Concurrency**: Only one job runs at a time
- **History**: Keeps last 3-7 successful jobs
- **Failure Handling**: Automatic retry on failure

## 🌐 Accessing Applications

### Docker Compose
- **Backend**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin)
- **MySQL**: localhost:3306

### Kubernetes
- **Backend**: http://backend.local
- **Prometheus**: http://prometheus.local
- **Grafana**: http://grafana.local (admin/admin)

*Note: For Kubernetes, add hostnames to `/etc/hosts` or configure DNS*

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `MYSQL_ROOT_PASSWORD` | MySQL root password | Required |
| `MYSQL_HOST` | MySQL host | `mysql` (K8s) / `mysql-db` (Docker) |
| `MYSQL_USER` | MySQL username | `root` |
| `MYSQL_DATABASE` | Database name | `lab_db` |
| `BACKEND_PORT` | Backend port | `3000` |

### Kubernetes Secrets

Update `k8s/mysql-secret.yaml` with your passwords:

```bash
# Generate base64 encoded password
echo -n "your-secure-password" | base64

# Update the secret file
```

## 🚀 Deployment Options

### 1. Docker Compose (Development)

```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f
```

### 2. Kubernetes (Production)

```bash
cd k8s

# Deploy everything
./deploy.sh

# Check status
kubectl get all -n lab-project

# View logs
kubectl logs -f deployment/backend -n lab-project

# Clean up
./delete-all.sh
```

### 3. Azure (Cloud)

```bash
cd terraform

# Initialize
terraform init

# Deploy
terraform apply

# Destroy
terraform destroy
```

## 📊 Monitoring

### Prometheus
- **URL**: http://localhost:9090 (Docker) / http://prometheus.local (K8s)
- **Targets**: Backend, MySQL Exporter, Prometheus itself
- **Metrics**: Application metrics, database performance

### Grafana
- **URL**: http://localhost:3001 (Docker) / http://grafana.local (K8s)
- **Credentials**: admin/admin
- **Dashboards**: Pre-configured for monitoring

### MySQL Exporter
- **Port**: 9104
- **Metrics**: Database performance, connection stats

## 🔍 Troubleshooting

### Common Issues

1. **Backend can't connect to MySQL**
   - Check if MySQL is running
   - Verify environment variables
   - Check network connectivity

2. **CronJob not running**
   - Check CronJob status: `./manage-cronjob.sh status`
   - Verify schedule: `kubectl get cronjob -n lab-project`
   - Check logs: `./manage-cronjob.sh logs`

3. **Persistent Volume issues (K8s)**
   - Check PVC status: `kubectl get pvc -n lab-project`
   - Verify storage class: `kubectl get storageclass`

### Useful Commands

```bash
# Check all resources
kubectl get all -n lab-project

# View pod logs
kubectl logs -f <pod-name> -n lab-project

# Describe resource
kubectl describe <resource> <name> -n lab-project

# Port forward for direct access
kubectl port-forward svc/backend 8080:80 -n lab-project
```

## 🧹 Cleanup

### Docker Compose
```bash
./scripts/stop.sh docker
```

### Kubernetes
```bash
cd k8s
./delete-all.sh
```

### Azure
```bash
cd terraform
terraform destroy
```

## 📝 Development

### Adding New Services

1. **Docker Compose**: Add service to `docker-compose.yaml`
2. **Kubernetes**: Create deployment and service YAML files
3. **Monitoring**: Add Prometheus targets and Grafana dashboards

### Modifying CronJobs

1. Edit `k8s/cronjob.yaml` or `k8s/cronjob-advanced.yaml`
2. Apply changes: `kubectl apply -f k8s/cronjob.yaml`
3. Test manually: `./manage-cronjob.sh run`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with both Docker Compose and Kubernetes
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details. 