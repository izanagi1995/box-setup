#!/usr/bin/env bash
source tools.sh
step_info "Updating apt..."

sudo apt-get update > $verbose_path 2>&1 || exit_on_error "CANNOT UPDATE APT"
sudo apt-get install -y zsh wget git > $verbose_path 2>&1 || exit_on_error "CANNOT INSTALL ZSH"
sudo chsh -s $(which zsh) "${USER}"

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh > $verbose_path 2>&1
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

caveat "Run 'source ~/.zshrc' to load the .zshrc config"

success
