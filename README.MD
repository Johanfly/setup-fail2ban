## fail2ban personal conf

```bash

sudo nano /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/filter.d/sshd-aggressive.conf
sudo chmod 644 /etc/fail2ban/jail.local
sudo chmod 644 /etc/fail2ban/filter.d/sshd-aggressive.conf

sudo fail2ban-client -t
sudo systemctl restart fail2ban 
sudo fail2ban-client status
sudo tail -f /var/log/fail2ban.log
sudo tail -f /var/log/auth.log

sudo fail2ban-client get sshd bantime
```
