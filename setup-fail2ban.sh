#!/bin/bash

# Script untuk mengonfigurasi Fail2ban dengan proteksi agresif
# Jalankan sebagai root atau dengan sudo

echo "=== Konfigurasi Fail2ban untuk Proteksi SSH Agresif ==="
echo ""

# Cek apakah Fail2ban sudah terinstall
if ! command -v fail2ban-server &> /dev/null; then
    echo "❌ Fail2ban belum terinstall. Installing..."
    apt update
    apt install -y fail2ban
fi

# Backup konfigurasi yang ada
echo "📁 Backup konfigurasi existing..."
if [ -f /etc/fail2ban/jail.local ]; then
    cp /etc/fail2ban/jail.local /etc/fail2ban/jail.local.backup.$(date +%Y%m%d-%H%M%S)
    echo "✅ Backup jail.local dibuat"
fi

# Copy konfigurasi baru
echo "⚙️  Mengaplikasikan konfigurasi baru..."
cp /tmp/jail.local /etc/fail2ban/jail.local
cp /tmp/sshd-aggressive.conf /etc/fail2ban/filter.d/sshd-aggressive.conf

# Set permission yang benar
chmod 644 /etc/fail2ban/jail.local
chmod 644 /etc/fail2ban/filter.d/sshd-aggressive.conf

# Restart Fail2ban service
echo "🔄 Restart Fail2ban service..."
systemctl restart fail2ban
systemctl enable fail2ban

# Cek status
echo ""
echo "📊 Status Fail2ban:"
systemctl status fail2ban --no-pager -l

echo ""
echo "🔍 Jail yang aktif:"
fail2ban-client status

echo ""
echo "📋 Untuk monitoring:"
echo "- Cek status: sudo fail2ban-client status"
echo "- Cek jail SSH: sudo fail2ban-client status sshd"
echo "- Unban IP: sudo fail2ban-client set sshd unbanip IP_ADDRESS"
echo "- Cek log: sudo tail -f /var/log/fail2ban.log"

# Ban IP yang sudah terdeteksi mencurigakan (opsional)
echo ""
echo "🚫 Mem-ban IP yang mencurigakan dari log..."
SUSPICIOUS_IPS=("109.241.24.186" "92.191.96.171" "80.94.95.112" "62.60.131.157")

for ip in "${SUSPICIOUS_IPS[@]}"; do
    echo "Banning IP: $ip"
    fail2ban-client set sshd banip $ip 2>/dev/null || echo "Failed to ban $ip (might already be banned)"
done

echo ""
echo "✅ Konfigurasi selesai!"
echo ""
echo "📝 Konfigurasi yang diterapkan:"
echo "- Ban time: 1 hari (24 jam) untuk percobaan pertama"
echo "- Max retry: 1 (langsung ban)"
echo "- Find time: 5 menit"
echo "- Monitoring: /var/log/auth.log"