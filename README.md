# Lab Project

A modern, full-stack lab environment for enterprise-grade application development, monitoring, and automation. This project includes a Node.js backend, React frontend, MySQL database, Prometheus & Grafana monitoring, automated maintenance, and supports deployment via Docker Compose, Kubernetes, Azure (Terraform), and Helm.

---

## 🆕 2025 Upgrades & Advanced Features

### Frontend (WeatherTech)
- **Multi-city dashboard:** Add, remove, and view weather for multiple favorite cities in a responsive grid.
- **Unit switching:** Instantly toggle Celsius/Fahrenheit, km/h/mph, etc. (Settings menu).
- **Weather radar overlays:** Precipitation, clouds, etc. with animated radar and layer toggles.
- **Advanced analytics:** Precipitation, wind, UV, and date range selection for analytics.
- **Personalization:** Theme and accent color picker, preferences saved locally.
- **Weather news feed:** Articles and tips, with unread indicators and category filters.
- **Accessibility:** Voice search, high-contrast mode, screen reader support.
- **User accounts & sync:** (Optional) Sign in, sync preferences and favorites to the cloud.
- **Modern UI:** Glassmorphism, smooth animations, dark/light mode, and fully responsive design.

### Monitoring & Observability
- **MySQL Exporter:** Securely exposes MySQL metrics for Prometheus using a `.my.cnf` file and a dedicated exporter user.
- **Prometheus:** Now scrapes MySQL metrics via mysqld-exporter (`/metrics` on port 9104).
- **Grafana:** Ready for MySQL dashboards and advanced analytics.

### Docker & DevOps
- **High-end, multi-stage Dockerfile** for frontend with security, performance, and best practices.
- **Custom Nginx config** for SPA routing, security headers, and caching.
- **Docker Compose volumes** for secrets/configs (e.g., `.my.cnf` for exporter credentials).
- **Health checks** for all services.
- **.my.cnf** for exporter credentials (best practice).

---

## 📁 Project Structure

```
lab2/
├── backend/                 # Node.js API server
├── frontend/                # React app (WeatherTech)
├── db/                      # MySQL schema & seed scripts, exporter.my.cnf
├── monitoring/              # Prometheus config
├── scripts/                 # Automation scripts (start, stop, deploy, backup, etc.)
├── k8s/                     # Kubernetes manifests & deployment scripts
├── terraform/               # Azure infrastructure as code
├── helm/                    # Helm chart for K8s deployment
├── docker-compose.yaml      # Docker Compose config
└── README.md                # Project documentation
```

---

## ✨ Features

- **Node.js Backend:**
  - REST API with health, metrics, and environment endpoints
  - MySQL integration (teams, roles, employees, projects)
  - Prometheus metrics endpoint (`/metrics`)
  - Graceful shutdown & security best practices

- **React Frontend:**
  - WeatherTech UI: dashboard, map, forecast, analytics, settings, login/register
  - Multi-city, unit switching, radar overlays, advanced analytics, news feed, personalization, accessibility, authentication, and more
  - Modern, responsive, animated UI (glassmorphism, dark/light mode)
  - Settings page with all advanced options
  - Mock weather data for demo; easy to connect to real APIs

- **Database:**
  - MySQL 8.0 with rich schema (teams, roles, employees, projects)
  - Seed data for realistic org structure
  - User creation for phpMyAdmin and exporters

- **Monitoring:**
  - Prometheus scrapes backend, node exporter, Grafana, and MySQL exporter
  - Grafana dashboards (pre-configured, admin/admin)
  - MySQL exporter for DB metrics (secure `.my.cnf` config)

- **Automation & Maintenance:**
  - Daily CronJobs (health checks, backup, optimization, cleanup)
  - Scripts for backup, cleanup, health-check, deploy, start/stop

- **Deployment:**
  - Docker Compose (dev), Kubernetes (prod), Azure (cloud), Helm (K8s package)
  - Infrastructure as code (Terraform for Azure)

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- (Optional) Kubernetes cluster & kubectl
- (Optional) Azure CLI & Terraform

### 1. Docker Compose (Development)
```bash
docker-compose up --build
# Access: Frontend http://localhost:3002, Backend http://localhost:3000
# Prometheus: http://localhost:9090, Grafana: http://localhost:3001, MySQL Exporter: http://localhost:9104/metrics
```

### 2. Kubernetes (Production)
```bash
cd k8s
./deploy.sh
# Access: http://frontend.local, http://backend.local (add to /etc/hosts)
```

### 3. Azure (Cloud)
```bash
cd terraform
terraform init
terraform apply
# See outputs for URLs
```

### 4. Helm (K8s Package)
```bash
cd helm/lab-project
helm install lab-project .
```

### 5. Auto-detect Scripts
```bash
./scripts/start.sh   # Starts best environment
./scripts/stop.sh    # Stops running environments
```

---

## 🌤️ Frontend (WeatherTech)

- **Stack:** React, React Router, Framer Motion, Recharts, Leaflet, Styled Components
- **Features:**
  - Multi-city dashboard, unit switching, radar overlays, advanced analytics, news feed, personalization, accessibility, user accounts, and more
  - Modern, responsive, animated UI (glassmorphism, dark/light mode)
  - Settings page with all advanced options
  - Mock weather data for demo; easy to connect to real APIs

---

## 📊 Monitoring & Observability

- **Prometheus:**
  - Scrapes backend (`/metrics`), node exporter, Grafana, and MySQL exporter
  - Config: `monitoring/prometheus.yml`
- **Grafana:**
  - Pre-configured dashboards
  - Access: admin/admin (default)
- **MySQL Exporter:**
  - Exposes DB metrics for Prometheus
  - Uses secure `.my.cnf` file for credentials (see `db/exporter.my.cnf`)

---

## 🐳 Docker Compose & DevOps

- **Frontend:**
  - Multi-stage Dockerfile for production and development
  - Custom Nginx config for SPA routing, security, and caching
  - Volumes for secrets/configs (e.g., `.my.cnf` for exporter)
  - Health checks for all services
- **MySQL Exporter:**
  - Uses `.my.cnf` for credentials (best practice)
  - Dedicated exporter user with least-privilege permissions
- **All services:**
  - Health checks, restart policies, and secure networking

---

## 🖥️ Backend API

- **Stack:** Node.js, Express, MySQL, Prometheus client
- **Key Endpoints:**
  - `GET /` — Welcome message
  - `GET /health` — Health check (JSON)
  - `GET /metrics` — Prometheus metrics
  - `GET /env` — Safe environment info
  - `POST /register` — User registration (username, password)
  - `POST /login` — User login (returns JWT)
  - `GET /profile` — Protected endpoint (requires JWT)
- **Config:**
  - Reads DB config from environment variables
  - Exposes Prometheus metrics for monitoring

---

## 🔐 Authentication & User Accounts (2025)

- **User Registration & Login:**
  - Secure registration and login with username and password
  - Passwords are hashed with bcrypt before storage
  - JWT-based authentication for protected endpoints
  - `/register` and `/login` endpoints in the backend
  - `/profile` endpoint requires a valid JWT

- **Frontend Login/Register UI:**
  - Modern, animated login and registration pages
  - Responsive design, glassmorphism, and error handling
  - Google OAuth login button (optional, backend endpoint can be added)

- **Security:**
  - JWT secret and DB credentials managed via environment variables
  - All sensitive data is never exposed to the frontend

---

## 🌤️ Frontend (WeatherTech)

- **Stack:** React, React Router, Framer Motion, Recharts, Leaflet, Styled Components
- **Features:**
  - Dashboard: Current, hourly, daily weather (mock data, easy to connect to real API)
  - Map: Kosovo cities with weather markers
  - Analytics, Forecast, Settings (placeholders for extension)
  - Modern, responsive, animated UI

---

## 🗄️ Database Schema

- **Tables:**
  - `teams` — Team info
  - `roles` — Roles, departments, levels
  - `employees` — Employee info, team/role/manager relations
  - `projects` — Projects, status, team assignment
- **Seed Data:**
  - Realistic teams, roles, employees, projects
- **Users:**
  - `pma_user` for phpMyAdmin
  - `exporter` for Prometheus MySQL exporter

---

## 📊 Monitoring & Observability

- **Prometheus:**
  - Scrapes backend (`/metrics`), node exporter, Grafana
  - Config: `monitoring/prometheus.yml`
- **Grafana:**
  - Pre-configured dashboards
  - Access: admin/admin (default)
- **MySQL Exporter:**
  - Exposes DB metrics for Prometheus

---

## 🤖 Automation & Scripts

- **scripts/start.sh** — Start environment (auto-detects Docker/K8s)
- **scripts/stop.sh** — Stop environment
- **scripts/deploy.sh** — Deploy (Docker Compose, K8s, Azure)
- **scripts/backup.sh** — Backup MySQL, app data, Docker volumes
- **scripts/cleanup.sh** — Remove all resources (Docker, K8s, Azure)
- **scripts/health-check.sh** — Health check for all services

---

## ☸️ Kubernetes & Helm

- **Manifests:** Deployments, Services, Ingress, ConfigMaps, Secrets, CronJobs
- **Namespace:** `lab-project` (resource isolation)
- **Helm Chart:** Parameterized, supports autoscaling, resource limits, network policies, backup, RBAC, security context
- **CronJobs:**
  - `daily-maintenance`: Health checks, log cleanup
  - `daily-maintenance-advanced`: Backup, optimization, cleanup

---

## ☁️ Azure (Terraform)

- **Resources:**
  - Resource Group, Container Registry, MySQL Server & DB, Container Apps (backend, frontend, prometheus, grafana)
- **Outputs:** URLs, connection strings
- **Variables:** Passwords, region, resource names

---

## ⚙️ Configuration

- **Environment Variables:**
  - `MYSQL_ROOT_PASSWORD` (required)
  - `MYSQL_HOST` (default: `mysql`/`mysql-db`)
  - `MYSQL_USER` (default: `root`)
  - `MYSQL_DATABASE` (default: `lab_db`)
  - `BACKEND_PORT` (default: `3000`)
- **Kubernetes Secrets:**
  - Update `k8s/mysql-secret.yaml` with base64-encoded passwords
- **Helm Values:**
  - See `helm/lab-project/values.yaml` for all tunables

---

## 🕐 Maintenance & CronJobs

- **Types:**
  - Simple: Health checks, log cleanup
  - Advanced: Backup, optimization, old backup cleanup
- **Schedule:** 2:00 AM daily (`0 2 * * *`)
- **Management:**
  - `./k8s/manage-cronjob.sh status|run|logs|suspend|resume|delete`

---

## 🌐 Accessing Applications

| Service     | Docker Compose           | Kubernetes             | Azure (Terraform)         |
|-------------|-------------------------|------------------------|---------------------------|
| Backend     | http://localhost:3000   | http://backend.local   | terraform output backend  |
| Frontend    | http://localhost:5173   | http://frontend.local  | terraform output frontend |
| Prometheus  | http://localhost:9090   | http://prometheus.local| terraform output prometheus|
| Grafana     | http://localhost:3001   | http://grafana.local   | terraform output grafana  |
| MySQL       | localhost:3306          | mysql service (K8s)    | terraform output mysql    |

*For K8s, add hostnames to `/etc/hosts` or configure DNS.*

---

## 🛠️ Troubleshooting

- **Backend can't connect to MySQL:**
  - Check MySQL is running, env vars, network
- **CronJob not running:**
  - Check status/logs: `./k8s/manage-cronjob.sh status|logs`
- **Persistent Volume issues (K8s):**
  - Check PVC status: `kubectl get pvc -n lab-project`
- **Useful K8s Commands:**
  - `kubectl get all -n lab-project`
  - `kubectl logs -f <pod> -n lab-project`
  - `kubectl describe <resource> <name> -n lab-project`
  - `kubectl port-forward svc/backend 8080:80 -n lab-project`

---

## 🧹 Cleanup

- **Docker Compose:** `./scripts/stop.sh docker`
- **Kubernetes:** `cd k8s && ./delete-all.sh`
- **Azure:** `cd terraform && terraform destroy`

---

## 📝 Development & Contribution

- **Add new services:**
  - Docker: Add to `docker-compose.yaml`
  - K8s: Add deployment/service YAML or Helm values
  - Monitoring: Add Prometheus targets, Grafana dashboards
- **Modify CronJobs:**
  - Edit `k8s/cronjob.yaml` or `k8s/cronjob-advanced.yaml`, apply with `kubectl`
- **Contribute:**
  1. Fork repo, create feature branch
  2. Make changes, test with Docker & K8s
  3. Submit pull request

---

## 📄 License

MIT License — see LICENSE file for details. 