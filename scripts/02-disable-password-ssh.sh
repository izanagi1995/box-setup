#!/usr/bin/env bash
source tools.sh
step_info "Disabling password authentication"

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old

sudo grep -q "ChallengeResponseAuthentication" /etc/ssh/sshd_config && sudo sed -i "/^[^#]*ChallengeResponseAuthentication[[:space:]]yes.*/c\ChallengeResponseAuthentication no" /etc/ssh/sshd_config || sudo echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
sudo grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config && sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config || sudo echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
sudo service ssh restart || exit_on_error "CANNOT RESTART SSH ! PLEASE DO NOT QUIT THIS TERMINAL AND RESTORE SSH CONFIG FROM /etc/ssh/sshd_config.old"

success
