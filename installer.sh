#!/bin/bash

clear
echo "====================================="
echo "   Homelab Installer (Starter)       "
echo "====================================="

# --- Root check ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run with sudo"
  exit 1
fi

# --- Detect IP ---
SERVER_IP=$(ip route get 1 | awk '{print $7; exit}')
[ -z "$SERVER_IP" ] && SERVER_IP=$(hostname -I | awk '{print $1}')

# --- User input ---
echo ""
echo "👤 Setup Configuration"

read -p "Enter username (default: admin): " USERNAME
USERNAME=${USERNAME:-admin}

while true; do
  echo ""
  read -p "Enter password: " PASSWORD
  read -p "Confirm password: " PASSWORD2

  if [ -z "$PASSWORD" ]; then
    echo "❌ Password cannot be empty"
  elif [ "$PASSWORD" != "$PASSWORD2" ]; then
    echo "❌ Passwords do not match. Try again."
  else
    break
  fi
done

read -p "Timezone (default: Australia/Brisbane): " TZ
TZ=${TZ:-Australia/Brisbane}

# --- Update system ---
echo ""
echo "[+] Updating system..."
apt update -y && apt upgrade -y

# --- Install dependencies ---
echo "[+] Installing Docker & dependencies..."
apt install -y docker.io docker-compose curl samba lsof

systemctl enable docker
systemctl start docker

# --- Detect docker compose ---
if command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
elif docker compose version >/dev/null 2>&1; then
  DC="docker compose"
else
  echo "❌ Docker Compose not found"
  exit 1
fi

# --- Base directory ---
BASE_DIR="/opt/homelab"
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# --- Menu ---
echo ""
echo "📦 Select services to install:"
echo "1) Jellyfin"
echo "2) Pi-hole"
echo "3) Tailscale"
echo "4) Nextcloud"
echo "5) Samba"
echo "6) Install ALL"
echo ""

read -p "Enter choice (e.g. 1 3 5): " CHOICE

FAILED_SERVICES=""

# --- Install functions ---

install_jellyfin() {
  echo "[+] Installing Jellyfin..."
  mkdir -p jellyfin && cd jellyfin

  cat <<EOF > docker-compose.yml
services:
  jellyfin:
    image: jellyfin/jellyfin
    network_mode: host
    volumes:
      - ./config:/config
      - ./media:/media
    restart: unless-stopped
EOF

  $DC up -d || FAILED_SERVICES+=" Jellyfin"
  cd ..
}

install_pihole() {
  echo "[+] Installing Pi-hole..."
  mkdir -p pihole && cd pihole

  cat <<EOF > docker-compose.yml
services:
  pihole:
    image: pihole/pihole
    ports:
      - "8080:80"
      - "53:53/tcp"
      - "53:53/udp"
    environment:
      TZ: "$TZ"
      WEBPASSWORD: "$PASSWORD"
    volumes:
      - ./etc-pihole:/etc/pihole
    restart: unless-stopped
EOF

  $DC up -d || FAILED_SERVICES+=" Pi-hole"
  cd ..
}

install_tailscale() {
  echo "[+] Installing Tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh || FAILED_SERVICES+=" Tailscale"
}

install_nextcloud() {
  echo "[+] Installing Nextcloud..."
  mkdir -p nextcloud && cd nextcloud

  cat <<EOF > docker-compose.yml
services:
  nextcloud:
    image: nextcloud
    ports:
      - "8090:80"
    environment:
      NEXTCLOUD_ADMIN_USER: "$USERNAME"
      NEXTCLOUD_ADMIN_PASSWORD: "$PASSWORD"
    volumes:
      - ./data:/var/www/html
    restart: unless-stopped
EOF

  $DC up -d || FAILED_SERVICES+=" Nextcloud"
  cd ..
}

install_samba() {
  echo "[+] Installing Samba..."
  mkdir -p /opt/homelab/shared

  if ! grep -q "\[Shared\]" /etc/samba/smb.conf; then
    cat <<EOF >> /etc/samba/smb.conf

[Shared]
   path = /opt/homelab/shared
   browseable = yes
   writable = yes
   guest ok = yes
EOF
  fi

  systemctl restart smbd || FAILED_SERVICES+=" Samba"
}

# --- Run installs ---
if [[ "$CHOICE" == "6" ]]; then
  install_jellyfin
  install_pihole
  install_tailscale
  install_nextcloud
  install_samba
else
  [[ "$CHOICE" == *"1"* ]] && install_jellyfin
  [[ "$CHOICE" == *"2"* ]] && install_pihole
  [[ "$CHOICE" == *"3"* ]] && install_tailscale
  [[ "$CHOICE" == *"4"* ]] && install_nextcloud
  [[ "$CHOICE" == *"5"* ]] && install_samba
fi

# --- Final output ---
echo ""
echo "====================================="

if [ -z "$FAILED_SERVICES" ]; then
  echo " ✅ Installation Complete!"
else
  echo "⚠️ Completed with issues"
  echo "Failed services:$FAILED_SERVICES"
fi

echo "====================================="
echo ""
echo "🌐 Server IP: $SERVER_IP"
echo ""
echo "Jellyfin   → http://$SERVER_IP:8096"
echo "Pi-hole    → http://$SERVER_IP:8080"
echo "Nextcloud  → http://$SERVER_IP:8090"
echo ""
echo "🔐 Username: $USERNAME"
echo ""
echo "👉 Run this for remote access:"
echo "tailscale up"
echo ""
echo ""
