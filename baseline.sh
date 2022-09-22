#!/bin/bash

#configure apt - https://pve.proxmox.com/wiki/Package_Repositories
source ~/proxmox-nfp/fixaptsources.sh

#install gui
apt install --no-install-recommends git vim xorg openbox lightdm freerdp2-shadow-x11 chromium pulseaudio

#add user
#TODO check if user exists
adduser --gecos "" --disabled-password pve
chpasswd <<<"pve:pve"

#set autologin for lightdm
#TODO check if exists & make sure in right section
sed -i 's/#autologin-user=/autologin-user=pve/' /etc/lightdm/lightdm.conf

#set openbox to autostart browser
#TODO check if exists
cat >> /etc/xdg/openbox/autostart << EOF
xset -dpms
xset s off
freerdp-shadow-x11 /port:3389 -auth >>/home/pve/freerdp.log 2>&1 &
chromium --no-sandbox --ignore-certificate-errors --kiosk https://localhost:8006 &
EOF
