#!/bin/bash
# =====================================================
# 🧰 Server Setup Script
# Installs Git, Node.js, and Docker on Ubuntu/Debian
# =====================================================

set -e  # Exit if any command fails

# ---- Variables ----
LOG_FILE="/var/log/server_setup.log"
NODE_VERSION="20.x"

# ---- Functions ----
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# ---- Root check ----
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root or using sudo."
    exit 1
fi

log "🚀 Starting server setup..."

# ---- Update system ----
log "🔄 Updating system packages..."
apt update -y && apt upgrade -y

# ---- Install Git ----
if ! command -v git &> /dev/null; then
    log "📦 Installing Git..."
    apt install git -y
else
    log "✅ Git is already installed."
fi

# ---- Install Node.js ----
if ! command -v node &> /dev/null; then
    log "📦 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
    apt install -y nodejs
else
    log "✅ Node.js is already installed."
fi

# ---- Install Docker ----
if ! command -v docker &> /dev/null; then
    log "📦 Installing Docker..."
    apt install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable docker
    systemctl start docker
else
    log "✅ Docker is already installed."
fi

# ---- Verify installations ----
log "🔍 Verifying installations..."
git --version | tee -a $LOG_FILE
node -v | tee -a $LOG_FILE
npm -v | tee -a $LOG_FILE
docker --version | tee -a $LOG_FILE

log "✅ Setup complete! All packages installed successfully."

log "📦 Installing monitoring dependencies..."
apt install -y htop mailutils

# copy the monitoring script
cp system_monitor.sh /usr/local/bin/
chmod +x /usr/local/bin/system_monitor.sh

# add it to cron
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/system_monitor.sh") | crontab -
log "🔁 Monitoring script scheduled to run every 5 minutes."