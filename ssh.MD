
```bash
sudo nano /etc/ssh/sshd_config

PermitRootLogin no 
PubkeyAuthentication yes 
PasswordAuthentication no

sudo grep -n "PermitRootLogin\|PasswordAuthentication\|PubkeyAuthentication" /etc/ssh/sshd_config | grep -v "^#"

sudo systemctl restart sshd
sudo systemctl status sshd
```