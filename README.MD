## fail2ban personal conf

```bash
sudo fail2ban-client -t
sudo systemctl restart fail2ban 
sudo fail2ban-client status
sudo tail -f /var/log/fail2ban.log
sudo tail -f /var/log/auth.log
```