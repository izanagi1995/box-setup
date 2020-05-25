#!/usr/bin/env bash
source tools.sh
step_info "Setup fail2ban"

sudo apt-get install -y fail2ban > $verbose_path 2>&1 || exit_on_error "CANNOT INSTALL FAIL2BAN"

copy_file "fail2ban/jail.local" "/etc/fail2ban/jail.local"
sudo chown root /etc/fail2ban/jail.local
sudo sed -i "s/%HOME_IP%/$home_ip/g" /etc/fail2ban/jail.local
sudo service fail2ban restart

success
