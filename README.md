# 🚀 OpenWebUI + Nginx + Ollama (Self-Hosted)

This repository provides a **ready-to-use** setup for deploying OpenWebUI with Nginx as a reverse proxy and Ollama for AI model serving, on Debian based system.

<a href="https://ibb.co/zWzMRk07"><img src="https://i.ibb.co/cKjBFm7C/curi0us-IT-openwebui-ollama-nginx-ssl-automated.png" alt="curi0us-IT-openwebui-ollama-nginx-ssl-automated" border="0"></a>

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

🛠️ Accessing OpenWebUI & Configuring Ollama
Once your setup is complete, follow these steps to access and configure OpenWebUI:

1️⃣ Open OpenWebUI

Visit https://<your-server-ip> in your browser.

2️⃣ Create an Account

Register and log in to your OpenWebUI instance.

3️⃣ Update Ollama API Connection

Navigate to Admin Panel > Settings > Connections.

Under "Manage Ollama API Connections", replace "localhost" with your server's IP address.

4️⃣ Download Models

You can now pull models directly from Ollama via the "Models" tab.

Alternatively, you can manually pull models inside the Docker container using:

```bash
docker exec -it ollama ollama pull <your-model>
```

After downloading, refresh OpenWebUI to use the new model.

✅ Your OpenWebUI is now ready to use with Ollama! 🚀

<a href="https://ibb.co/hr3JnWK"><img src="https://i.ibb.co/6Gj7pP4/Capture-d-cran-du-2025-03-28-22-09-20.png" alt="Capture-d-cran-du-2025-03-28-22-09-20" border="0"></a>



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