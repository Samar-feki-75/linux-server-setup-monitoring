# 🖥️ Linux Server Automation & Monitoring Project

This project automates the setup of a new Linux server by installing essential tools and configuring basic system monitoring with automated alerts.

---

## ⚙️ Features

### 🧰 Automated Setup
- Installs **Git**, **Node.js**, **Docker**, and other dependencies  
- Updates system packages  
- Sets up Docker service to start on boot  

### 📊 System Monitoring
- Uses tools like `top`, `htop`, `uptime`, and `df`
- Monitors CPU load, memory usage, and disk space
- Sends alerts via email if resource usage exceeds defined thresholds
- Scheduled automatically via `cron` every 5 minutes

> ⚠️ **Important:**  
> Before running the monitoring script, **edit `system_monitor.sh`** and replace  
> `your_email@example.com` with your own email address to receive alerts.

---

## 🧩 Project Structure
```
linux-server-automation/
├── setup_server.sh # Installs Git, Node.js, Docker, monitoring tools
├── system_monitor.sh # Tracks CPU, memory, disk usage and sends alerts
└── README.md
```

---

## 🚀 How to Use

### 1️⃣ Run Setup Script
```bash
sudo chmod +x setup_server.sh
sudo ./setup_server.sh
This installs all required packages and sets up monitoring.

2️⃣ Verify Monitoring
Check the log:

bash
```
tail -f /var/log/system_monitor.log
```
Or list your cron jobs:

```bash
crontab -l
```
## 🧠 Learning Outcomes
By completing this project, you’ll learn:

Linux package management with apt

Writing automation scripts in Bash

Scheduling tasks with cron

Monitoring system metrics and sending alerts

Standardizing server setup across environments

---

