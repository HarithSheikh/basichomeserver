# 🏠 Starter Home Server Installer Script

### ⚡ One-Line Setup for a Starter Services

```
curl -fsSL https://get.bloxtuan.com/bhs/install.sh -o install.sh && sudo bash install.sh
```

---

## 🚀 Overview

This is a beginner-friendly script that sets up essential self-hosted services on Ubuntu Server using Docker.

It provides a simple interactive menu so you can install only what you need, no complicated setup required.

---

## ✨ Features

* One-line installation
* Docker-based deployment
* Beginner-friendly interactive setup
* Automatic configuration
* Multiple services in one script
* Works on Ubuntu Server / VMs

---

## 📦 Services Included

* Jellyfin — Media streaming server
* Pi-hole — Network-wide ad blocker
* Tailscale — Secure remote access VPN
* Nextcloud — Personal cloud storage
* Samba — Network file sharing

---

## ⚙️ Requirements

Minimum:

* CPU: 2 cores
* RAM: 4 GB
* Storage: 20 GB
* OS: Ubuntu Server 20.04+

Recommended:

* CPU: 4+ cores
* RAM: 8 GB+
* Storage: 100 GB+

---

# 📥 Beginner Tutorial (Step-by-Step)

## 1. Install Ubuntu Server

* Install Ubuntu Server on:

  * A PC OR Server OR
  * A Virtual Machine (VM)
* Make sure:

  * Internet is working
  * You can log in
  * You have sudo access

---

## 2. Connect to Your Server

Local:

```
login normally
```

Remote (SSH):

```
ssh username@your-server-ip
```

---

## 3. Run the Installer

```
curl -fsSL https://get.bloxtuan.com/bhs/install.sh -o install.sh && sudo bash install.sh
```

---

## 4. Follow the Prompts

You will be asked:

Username:

```
admin
```

Password:

* Enter a password
* Confirm it

Timezone:

```
Australia/Brisbane
```

(or press Enter)

---

## 5. Choose Services

Example menu:

```
1) Jellyfin
2) Pi-hole
3) Tailscale
4) Nextcloud
5) Samba
6) Install ALL
```

Example input:

```
1 3 5
```

---

## 6. Wait for Installation

The script will:

* Install Docker
* Download containers
* Start services

---

## 7. Access Your Services

You will see your server IP at the end.

Open in browser:

* Jellyfin → [http://SERVER-IP:8096](http://SERVER-IP:8096)
* Pi-hole → [http://SERVER-IP:8080](http://SERVER-IP:8080)
* Nextcloud → [http://SERVER-IP:8090](http://SERVER-IP:8090)

---

## 8. Enable Remote Access (Optional)

Run:

```
tailscale up
```

Login and access your server remotely.

---

# 🐳 How It Works

* Uses Docker containers
* Stores everything in:

```
/opt/homelab/
```

* Each service runs independently

---

# 🔧 Useful Commands

Check containers:

```
docker ps
```

Restart a service:

```
docker restart <container_name>
```

View logs:

```
docker logs <container_name>
```

---

# ⚠️ Notes

* Pi-hole uses port 53 (DNS)
  → May fail if already in use

* Change passwords after install

* Performance depends on your hardware

---

## Installers (GitHub + Web)

Direct from web

```
curl -fsSL https://get.bloxtuan.com/bhs/install.sh -o install.sh && sudo bash install.sh
```
Direct From Github (source code can be viewed)

```
curl -fsSL https://raw.githubusercontent.com/HarithSheikh/basichomeserver/main/installer.sh -o install.sh && sudo bash install.sh
```
---

# 🧩 Alternative (GUI Option)

If you prefer a GUI, use **CasaOS**.

It provides:

* Web dashboard
* One-click installs
* Easier management

---

# 📜 License

MIT License

---
