#!/usr/bin/env bash

#this will always be first
VMID=100

#just incase
qm stop ${VMID}
qm destroy ${VMID}

#create the vm
qm create ${VMID} --name OpenWRT --memory 2048 --cores 2 --machine q35

#import the disk image to the store and vm
qm importdisk ${VMID} ~/proxmox-nfp/openwrt-2* local-lvm

#attach the disk to a controller in the vm
qm set ${VMID} --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-${VMID}-disk-0

#set the vm to boot from the disk
qm set ${VMID} --boot c --bootdisk virtio0 --onboot 1

#resize the disk
qm resize ${VMID} scsi0 +2000M

# the virtal network that will be shared with proxmox 
qm set ${VMID} -net0 virtio,bridge=vmbr0,firewall=0 

#loop through network controllers and add to vm
i=0
for DEV in $(lspci |grep -i net |cut -f 1 -d\ )
do 
  qm set ${VMID} --hostpci${i} ${DEV}
  ((i++))
done

#start
qm start ${VMID}
