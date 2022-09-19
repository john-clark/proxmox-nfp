##Prereq:

1. Download and install Ventoy
2. Download and copy Proxmox iso to the Ventoy data folder
3. Download and extract this folder to your Ventoy data folder
4. Download openwrt to the proxmox-nfp folder

##Instructions

* unplug net
* Boot computer

1. Install proxmox - choose defaults except for network
 * hostname: pve.lan
 * ip: 192.168.1.2/24
 * gw: 192.168.1.1
 * dns: 192.168.1.1

2. After Proxmox Install finished reboot
 * login
 * mount /dev/sda1 /mnt
 * /mnt/proxmox-nfp/runme1st.sh 

* plug in network
* Boot computer

3. Run setup
 * sh proxmox-nfp/baseline.sh

4. Install Docker
 * sh proxmox-nfp/create-debian-docker-ct.sh
