# Lab Project - Kubernetes Deployment

This directory contains Kubernetes manifests to deploy the lab project to a Kubernetes cluster.

## Prerequisites

1. Kubernetes cluster (local or cloud)
2. kubectl configured to access your cluster
3. NGINX Ingress Controller installed
4. Docker image for backend built and available

## Deployment Steps

### 1. Build and Push Backend & Frontend Images

First, build your backend and frontend Docker images:

```bash
# Build the backend image
docker build -t lab-backend:latest ../backend
# Build the frontend image
docker build -t lab-frontend:latest ../frontend

# If using a registry, tag and push:
# docker tag lab-backend:latest your-registry/lab-backend:latest
# docker push your-registry/lab-backend:latest
# docker tag lab-frontend:latest your-registry/lab-frontend:latest
# docker push your-registry/lab-frontend:latest
```

### 2. Update Secrets

Update the MySQL credentials in `mysql-secret.yaml`:

```bash
# Generate base64 encoded password
echo -n "your-secure-password" | base64

# Update the secret file with your encoded password
```

### 3. Deploy to Kubernetes

Deploy all resources using kustomize:

```bash
# Apply all resources
kubectl apply -k .

# Or apply individually:
kubectl apply -f namespace.yaml
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-persistent-volume.yaml
kubectl apply -f mysql-init-configmap.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f mysql-exporter-deployment.yaml
kubectl apply -f mysql-exporter-service.yaml
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
kubectl apply -f ingress.yaml
kubectl apply -f cronjob.yaml
kubectl apply -f cronjob-advanced.yaml
```

### 4. Check Deployment Status

```bash
# Check all resources in the namespace
kubectl get all -n lab-project

# Check pods status
kubectl get pods -n lab-project

# Check services
kubectl get svc -n lab-project

# Check ingress
kubectl get ingress -n lab-project

# Check CronJobs
kubectl get cronjobs -n lab-project
```

### 5. Access Applications

Add the following entries to your `/etc/hosts` file (or configure DNS):

```
<cluster-ip> backend.local
<cluster-ip> frontend.local
<cluster-ip> prometheus.local
<cluster-ip> grafana.local
```

Then access:
- **Backend**: http://backend.local
- **Frontend**: http://frontend.local
- **Prometheus**: http://prometheus.local
- **Grafana**: http://grafana.local (admin/admin)

## 🕐 Automated Maintenance (CronJobs)

The deployment includes automated daily maintenance tasks that run at 2:00 AM.

### CronJob Types

1. **Simple Maintenance** (`daily-maintenance`)
   - Health checks for all services
   - Lightweight monitoring tasks
   - Uses `busybox:latest` image

2. **Advanced Maintenance** (`daily-maintenance-advanced`)
   - Database backup using `mysqldump`
   - Database optimization (`OPTIMIZE TABLE`, `ANALYZE TABLE`)
   - Cleanup old backups (keeps last 7 days)
   - Comprehensive health monitoring
   - Uses `mysql:8` image

### CronJob Schedule

- **Schedule**: `0 2 * * *` (2:00 AM every day)
- **Concurrency Policy**: `Forbid` (only one job runs at a time)
- **Successful Jobs History**: 3-7 jobs
- **Failed Jobs History**: 1-3 jobs
- **Restart Policy**: `OnFailure`

### Managing CronJobs

Use the `manage-cronjob.sh` script for easy CronJob management:

```bash
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

### Manual CronJob Management

```bash
# Check CronJob status
kubectl get cronjobs -n lab-project

# View CronJob details
kubectl describe cronjob daily-maintenance -n lab-project

# Run CronJob manually
kubectl create job --from=cronjob/daily-maintenance manual-$(date +%Y%m%d-%H%M%S) -n lab-project

# View job logs
kubectl get jobs -n lab-project
kubectl logs job/manual-YYYYMMDD-HHMMSS -n lab-project

# Suspend CronJob
kubectl patch cronjob daily-maintenance -n lab-project -p '{"spec" : {"suspend" : true}}'

# Resume CronJob
kubectl patch cronjob daily-maintenance -n lab-project -p '{"spec" : {"suspend" : false}}'
```

### CronJob Configuration

#### Simple Maintenance (`cronjob.yaml`)
```yaml
schedule: "0 2 * * *"  # 2:00 AM daily
concurrencyPolicy: Forbid
successfulJobsHistoryLimit: 3
failedJobsHistoryLimit: 1
```

#### Advanced Maintenance (`cronjob-advanced.yaml`)
```yaml
schedule: "0 2 * * *"  # 2:00 AM daily
concurrencyPolicy: Forbid
successfulJobsHistoryLimit: 7
failedJobsHistoryLimit: 3
```

### CronJob Tasks

#### Simple Maintenance Tasks:
- Health check for Backend service
- Health check for Prometheus
- Health check for Grafana
- Basic system monitoring

#### Advanced Maintenance Tasks:
- Wait for MySQL to be ready
- Create daily backup directory
- Database backup using `mysqldump`
- Database optimization (`OPTIMIZE TABLE`, `ANALYZE TABLE`)
- Clean up old backups (keep last 7 days)
- Comprehensive health monitoring

### Monitoring CronJobs

```bash
# Check CronJob status
kubectl get cronjobs -n lab-project

# View recent jobs
kubectl get jobs -n lab-project

# Check job status
kubectl describe job <job-name> -n lab-project

# View job logs
kubectl logs job/<job-name> -n lab-project

# Check pod status for a job
kubectl get pods -l job-name=<job-name> -n lab-project
```

## Architecture

The deployment includes:
- **Namespace**: `lab-project` for resource isolation
- **MySQL**: Database with persistent storage and initialization scripts
- **Backend**: Node.js application with health checks and scaling
- **Frontend**: React application with health checks and scaling
- **Prometheus**: Monitoring with custom configuration
- **MySQL Exporter**: Database metrics collection
- **Grafana**: Dashboard for visualization
- **Ingress**: External access with host-based routing
- **CronJobs**: Automated daily maintenance tasks

## Features

- **Persistent Storage**: MySQL data persists across pod restarts
- **Health Checks**: Liveness and readiness probes for backend and frontend
- **Resource Limits**: CPU and memory limits for all containers
- **Secrets Management**: Secure storage of database credentials
- **Monitoring Stack**: Complete observability with Prometheus and Grafana
- **Scaling**: Backend and frontend configured for horizontal scaling
- **Automated Maintenance**: Daily CronJobs for backup and optimization

## Cleanup

To destroy all resources:
```bash
./delete-all.sh
```

## Troubleshooting

### Check Pod Logs
```bash
kubectl logs -f deployment/backend -n lab-project
kubectl logs -f deployment/mysql -n lab-project
kubectl logs -f deployment/prometheus -n lab-project
kubectl logs -f deployment/grafana -n lab-project
```

### Check Service Connectivity
```bash
kubectl exec -it deployment/backend -n lab-project -- curl mysql:3306
```

### Port Forward for Direct Access
```bash
kubectl port-forward svc/backend 8080:80 -n lab-project
kubectl port-forward svc/prometheus 9090:9090 -n lab-project
kubectl port-forward svc/grafana 3000:3000 -n lab-project
```

### CronJob Troubleshooting
```bash
# Check if CronJob is scheduled
kubectl get cronjobs -n lab-project

# Check if jobs are being created
kubectl get jobs -n lab-project

# Check job status
kubectl describe job <job-name> -n lab-project

# Check pod logs for failed jobs
kubectl logs job/<job-name> -n lab-project

# Check if CronJob is suspended
kubectl get cronjob daily-maintenance -n lab-project -o jsonpath='{.spec.suspend}'
``` 