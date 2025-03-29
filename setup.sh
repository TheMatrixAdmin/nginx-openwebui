#!/bin/bash

# -----------------------------
#
# Copyright (c) 2025 Curi0usIT
# Author: Curi0usIT
# License: MIT
# https://github.com/Curi0usIT/nginx-openwebui/blob/main/LICENSE
#
# -----------------------------

echo "-----------------------------------"
cat <<"EOF"
_________              ._________               .______________
\_   ___ \ __ _________|__\   _  \  __ __  _____|   \__    ___/
/    \  \/|  |  \_  __ \  /  /_\  \|  |  \/  ___/   | |    |   
\     \___|  |  /|  | \/  \  \_/   \  |  /\___ \|   | |    |   
 \______  /____/ |__|  |__|\_____  /____//____  >___| |____|   
        \/                       \/           \/                
EOF
echo "-----------------------------------"
echo "  Curi0usIT - Nginx + OpenWebUI + Ollama Bundle Installer"
echo "-----------------------------------"
echo "GitHub: https://github.com/Curi0usIT"
echo "-----------------------------------"

# ----- Prompt for server details -----
read -p "Enter your server's IPv4 address (e.g., 192.168.1.100): " DOMAIN
read -p "Country (C): " COUNTRY
read -p "State (ST): " STATE
read -p "City (L): " CITY
read -p "Organization (O): " ORG
read -p "Organizational Unit (OU): " ORG_UNIT

# ----- Install dependencies -----
echo "Updating system and installing dependencies..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# ----- Add Docker repository -----
echo "Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# ----- Install Docker & Docker Compose -----
echo "Installing Docker Engine and Docker Compose..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ----- Prompt for NVIDIA Toolkit Installation -----
read -p "Do you want to install NVIDIA Container Toolkit? (Recommended for NVIDIA GPUs) [y/N]: " install_nvidia
if [[ "$install_nvidia" == "y" || "$install_nvidia" == "Y" ]]; then
  echo "Installing NVIDIA Container Toolkit..."
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  sudo apt-get update
  sudo apt-get install -y nvidia-container-toolkit
  echo "NVIDIA Container Toolkit installed successfully!"
fi

# ----- Prompt for number of GPUs -----
read -p "How many GPUs do you want to use? (1 or 2): " GPU_COUNT
if [[ "$GPU_COUNT" == "2" ]]; then
  GPU_DEVICES="- driver: nvidia
              count: 2
              capabilities: [gpu]"
  GPU_ENV="- CUDA_VISIBLE_DEVICES=0,1"
else
  GPU_DEVICES="- driver: nvidia
              count: 1
              capabilities: [gpu]"
  GPU_ENV="- CUDA_VISIBLE_DEVICES=0"
fi

# ----- Create necessary directories -----
echo "Creating necessary directories..."
mkdir -p conf.d ssl

# ----- Create self-signed SSL certificate -----
echo "Generating SSL certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/nginx.key -out ssl/nginx.crt \
  -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/OU=$ORG_UNIT/CN=$DOMAIN"

# ----- Create Nginx configuration -----
echo "Creating Nginx configuration file..."
cat > conf.d/open-webui.conf <<EOL
server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        proxy_pass http://open-webui:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOL

# ----- Create Docker Compose file -----
echo "Creating Docker Compose file..."
cat > docker-compose.yml <<EOL
version: '3'

services:
  nginx:
    image: nginx:alpine
    container_name: nginx-proxy
    restart: always
    ports:
      - "443:443"
    volumes:
      - ./conf.d:/etc/nginx/conf.d
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - open-webui
      
  ollama:
    container_name: ollama
    image: ollama/ollama
    restart: always
    ports:
      - "11434:11434"
    volumes:
      - ollama:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
$GPU_DEVICES

  open-webui:
    container_name: open-webui
    image: ghcr.io/open-webui/open-webui:ollama
    restart: always
    ports:
      - "3000:8080"
    volumes:
      - ollama:/root/.ollama
      - open-webui:/app/backend/data
    environment:
      - OLLAMA_HOST=http://ollama:11434
$GPU_ENV
    depends_on:
    - ollama
    
volumes:
  ollama:
  open-webui:
EOL

# ----- Start Docker Containers -----
echo "Starting services with Docker Compose..."
docker compose up -d

echo "-------------------------------------------"
echo " ✅ Installation Complete!"
echo " Access OpenWebUI at: https://$DOMAIN"
echo "-------------------------------------------"