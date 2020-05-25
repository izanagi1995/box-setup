#!/usr/bin/env bash
source tools.sh
step_info "Installing argon"

sudo apt-get install -y argon2 > $verbose_path 2>&1 || exit_on_error "CANNOT INSTALL ARGON2"
read -sp 'Please enter password for Flood: ' passvar
read -sp 'Please confirm password for Flood: ' passconfirm

if [ "$passvar" != "$passconfirm" ]
then
  exit_on_error "PASSWORD DO NOT MATCH"
fi

HASH=$(argon_hash $passvar)

step_info "Setup media structure"

id -u media &>/dev/null || sudo useradd -q --system media
sudo mkdir -p /data/media/{tv-shows,movies}
copy_file rtorrent /data/media/
copy_file flood /data/media/
sudo find /data/media \( -type d -exec chmod 775 {} \; \) -o \( -type f -exec chmod 664 {} \; \)

store_glob media_uid $(id -u media)
store_glob media_gid $(id -g media)
store_glob flood_pass $HASH

sudo usermod -a -G media "$USER"
patch_template_file rtorrent-docker/docker-compose.yml .tmp/target/docker-compose.yml
patch_template_file flood/flood-db/users.db /data/media/flood/flood-db/users.db

sudo chown -R media:media /data/media

docker-compose -p rtorrent -f .tmp/target/docker-compose.yml up -d 2>&1 > $verbose_path || exit_on_error "CANNOT START COMPOSE STACK"


success
