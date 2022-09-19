#!/bin/bash

#copy scripts
cp -r /mnt/proxmox-nfp ~/

#copy openwrt image
cp /mnt/openwrt-x86* ~/proxmox-nfp/

#uncompress openwrt
gunzip ~/proxmox-nfp/openwrt-x86*

#remove bridge from nic - from now on proxmox only available from the inside
source ~/proxmox-nfp/remove-bridge.sh

#turn on iommu - so openwrt will work
#TODO check if its on
source ~/proxmox-nfp/enable-iommu.sh

#create openwrt
source ~/proxmox-nfp/create-openwrt-vm.sh

#done
shutdown -h now
