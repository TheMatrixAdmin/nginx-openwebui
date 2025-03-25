# 🚀 OpenWebUI + Nginx + Ollama (Self-Hosted)

This repository provides a **ready-to-use** setup for deploying OpenWebUI with Nginx as a reverse proxy and Ollama for AI model serving, on Debian based system.

## Features

✔ Automated installation with `setup.sh`

✔ **Docker Compose** full bundle with Nginx + SSL + OpenWebUI + Ollama

✔ **Self-signed SSL certificate** generation

✔ Secure **HTTPS access** to OpenWebUI from your LAN

✔ Optimized for **GPUs**

---

## 🔧 Installation (Full Setup)
To **automatically install everything**, simply run:

```bash
git clone https://github.com/Curi0usIT/nginx-openwebui.git
cd nginx-openwebui
chmod +x setup.sh
./setup.sh
```

Then, access OpenWebUI at:
➡ https://your-server-ip

## 🛠 Manual Setup (Docker Only)
If you already have Docker installed, you can simply:

```bash
git clone https://github.com/Curi0usIT/nginx-openwebui.git
cd nginx-openwebui
mkdir ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048
docker compose up -d
```

## Important: NVIDIA Container Toolkit Installation
To use NVIDIA GPUs with Docker, including SLI configurations, ensure you install the NVIDIA Container Toolkit. This toolkit enables Docker to access NVIDIA GPU capabilities for applications requiring graphics acceleration.

Installation (Debian/Ubuntu)
```bash
# Configure the repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update package list
sudo apt-get update

# Install NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit
```

This installation allows the use of NVIDIA GPUs in Docker containers, optimizing performance for GPU-accelerated applications.
Source: [NVIDIA Official Documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)