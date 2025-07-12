# 📊 Monitoring Guide

Your lab environment now has comprehensive monitoring set up! Here's how to access and use it.

## 🌐 Access Points

### **Grafana Dashboards**
- **URL:** http://localhost:3001
- **Login:** admin / admin
- **Available Dashboards:**
  - MySQL Monitoring Dashboard
  - System Monitoring Dashboard

### **Prometheus**
- **URL:** http://localhost:9090
- **Features:** Query metrics, view targets, explore data

### **MySQL Exporter**
- **URL:** http://localhost:9104/metrics
- **Shows:** MySQL server metrics, connection stats, query performance

## 📈 What You Can Monitor

### **MySQL Metrics**
- Server status (up/down)
- Active connections
- Queries per second
- InnoDB buffer pool usage
- Slow queries
- Table locks

### **System Metrics**
- CPU usage percentage
- Memory usage
- Disk usage
- Network traffic
- Process count
- Load average

### **Application Metrics**
- Backend API health
- Request rates
- Response times
- Error rates

## 🔍 Quick Queries to Try

### **In Prometheus (http://localhost:9090):**

1. **MySQL Status:**
   ```
   mysql_up
   ```

2. **Active Connections:**
   ```
   mysql_global_status_threads_connected
   ```

3. **CPU Usage:**
   ```
   100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
   ```

4. **Memory Usage:**
   ```
   (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
   ```

5. **Queries per Second:**
   ```
   rate(mysql_global_status_queries[5m])
   ```

## 🎯 Generate Load for Testing

Run this script to generate activity and see metrics in action:

```bash
./scripts/generate-load.sh
```

This will:
- Execute MySQL queries
- Make API calls to the backend
- Generate system activity

## 📊 Dashboard Features

### **MySQL Dashboard**
- Real-time server status
- Connection monitoring
- Query performance graphs
- Buffer pool statistics

### **System Dashboard**
- CPU and memory usage
- Disk utilization
- Network traffic
- System load

## 🔧 Troubleshooting

### **If MySQL metrics show as down:**
```bash
# Check MySQL exporter
curl http://localhost:9104/metrics | grep mysql_up

# Restart exporter if needed
docker-compose restart mysqld-exporter
```

### **If no data appears:**
1. Check Prometheus targets: http://localhost:9090/targets
2. Verify all targets are "UP"
3. Wait 15-30 seconds for data collection
4. Generate some load with the script above

### **If Grafana shows no data:**
1. Check datasource configuration
2. Verify Prometheus is accessible
3. Check time range settings
4. Try refreshing the dashboard

## 🚀 Next Steps

1. **Explore Grafana:** Create custom dashboards
2. **Set up Alerts:** Configure notification rules
3. **Add More Metrics:** Instrument your applications
4. **Scale Monitoring:** Add more exporters and targets

## 📝 Useful Commands

```bash
# Check all container status
docker-compose ps

# View container logs
docker-compose logs prometheus
docker-compose logs grafana
docker-compose logs mysqld-exporter

# Generate load for testing
./scripts/generate-load.sh

# Check specific metrics
curl http://localhost:9104/metrics | grep mysql_up
curl http://localhost:9090/api/v1/targets
```

Your monitoring is now live and collecting real data! 🎉 