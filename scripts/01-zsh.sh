#!/usr/bin/env bash
source tools.sh
step_info "Updating apt..."

sudo apt-get update > $verbose_path 2>&1 || exit_on_error "CANNOT UPDATE APT"
sudo apt-get install -y zsh > $verbose_path 2>&1 || exit_on_error "CANNOT INSTALL ZSH"
sudo chsh -s $(which zsh) "${USER}"

success
