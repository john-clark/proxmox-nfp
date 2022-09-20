# Proxmox Setup

## Requirements
- CPU: 64bit (Intel EMT64 or AMD64)
- Intel VT/AMD-V capable CPU/Mainboard (for KVM Full Virtualization support)
- Minimum 8GB RAM ( Recommanded 16 or more)
- Hard Drive 256GB ( Recommended 512GB or more)
- One Hardware NIC ( Recommended 2nd NIC for LAN and Wifi if you want OpenWRT to be an AP)
- 1GB USB key

## Install Server via USB
- Download 
    https://www.proxmox.com/en/downloads
- Create USB key
    https://pve.proxmox.com/wiki/Prepare_Installation_Media
- Boot computer and follow Installation wizard defaults
    https://pve.proxmox.com/wiki/Installation#chapter_installation
- Reboot computer

## Change from enterprise to community edition
Login Proxmox console and change repositories
```
$ vi /etc/apt/sources.list.d/pve-enterprise.list

    #deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise
    deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription

# update and upgrade
$ pveupdate
$ pveupgrade
```
Turn off nag
```
$ nonag.sh
```

## Enable IOMMU
This allows you to passthrough the physical ethernets to a vm
https://pve.proxmox.com/wiki/Pci_passthrough

```
$ vi /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"

$ update-grub
$ reboot
```
## Add Proxmox local user and GUI
Manage Proxmox and VMs via the console ( useful is you screw up networking )
```
apt install --no-install-recommends xorg openbox lightdm chromium pulseaudio
adduser pve
groupadd -r autologin
gpasswd -a pve autologin
```
vi /etc/lightdm/lightdm.conf
search for autologin, uncomment and add user
```
autologin-guest=false
autologin-user=pve
autologin-user-timeout=0
```
config openbox to start chrome
vi /etc/xdg/openbox/autostart
```
xset -dpms
xset s off
chromium --no-sandbox --kiosk https://localhost:8006
reboot
```

## Setup Network
Remove the Proxmox OEM Bridge then readd internal bridge to proxmox
this acts like internal switch for openwrt to manage for proxmox
if you have 2nd real ethernet bridge it here for local lan
```
brctl stop vmbr0; brctl delbr vmbr0
brctl addbr vmbr0
echo -e "\nauto vmbr0\niface vmbr0 inet manual" >> /etc/network/interfaces
echo -e "\taddress 192.168.1.2/24\n\tgateway 192.168.1.1" >> /etc/network/interfaces
ifup vmbr0
```
## Setup Openwrt
```
$ sh ./openwrt-vm-template.sh
```
## Port forwarding 
using proxmox openwrt console
```
$ vi /etc/config/firewall

config 'redirect'
        option 'name' 'Proxmox Admin'
        option 'src' 'wan'
        option 'proto' 'tcpudp'
        option 'src_dport' '8006'
        option 'dest_ip' '192.168.1.2'
        option 'dest_port' '8006'
        option 'target' 'DNAT'
        option 'dest' 'lan'

$ /etc/init.d/firewall restart
```
## setup openwrt
On Proxmox console kiosk press CTRL+N
type in 192.168.1.1
