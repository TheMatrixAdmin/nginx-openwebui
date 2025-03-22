# 🚀 OpenWebUI + Nginx + Ollama (Self-Hosted)

This repository provides a **ready-to-use** setup for deploying OpenWebUI with Nginx as a reverse proxy and Ollama for AI model serving, on Debian based system.

## Features
✔ Automated installation with `setup.sh` in one command 
✔ **Docker Compose** setup  
✔ **Self-signed SSL certificate** generation  
✔ Secure **HTTPS access** to OpenWebUI from your LAN 

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