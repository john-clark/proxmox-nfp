#!/usr/bin/env bash

# This creates proxmox template for Debian with Cloud init - no touch install
# https://cloud.debian.org/images/cloud/

# get the next available id
VMID=$(pvesh get /cluster/nextid)

# use the var and download the archive
FILENAME=debian-11-generic-amd64-daily
[ -e ./${FILENAME}.qcow2 ] && echo “$FILENAME exists.” || wget https://cloud.debian.org/images/cloud/bullseye/daily/latest/${FILENAME}.qcow2

#create the vm
qm create ${VMID} --name ${FILENAME} --memory 2048 --cores 2 --machine q35 --agent enabled=1 --autostart 1

#import the disk image to the store and vm
qm importdisk ${VMID} ${FILENAME}.qcow2 local-lvm

#attach the disk to a controller in the vm
qm set ${VMID} --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-${VMID}-disk-0

#add a disk for settings
qm set ${VMID} --ide2 local-lvm:cloudinit

#set the vm to boot from the disk
qm set ${VMID} --boot c --bootdisk scsi0 --serial0 socket --vga serial0

#resize the disk
qm resize ${VMID} scsi0 +30G

# the virtal network that will be shared with proxmox 
qm set ${VMID} -net0 virtio,bridge=vmbr0,firewall=0 
qm set ${VMID} --ipconfig0 ip=dhcp

# allow hotplug
qm set ${VMID} -hotplug disk,network,usb

# user authentication - don't need since this is cloud-init
#qm set ${VMID} --ciuser user
#qm set ${VMID} --cipassword password
#qm set ${VMID} --sshkey ~/.ssh/id_rsa.pub

#TODO: test this
#      need to add/check storage for snippets
#add snippets to storage type
cp cloud-init.yml to /var/lib/vz/snippets/${VMID}-cloud-init.yml
qm set ${VMID} --cicustom "user=local:snippets/${VMID}-cloud-init.yml"

# check the cloud-init config
qm cloudinit dump ${VMID} user

# make it so
qm start ${VMID} 
