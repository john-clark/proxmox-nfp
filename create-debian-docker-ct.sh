#!/usr/bin/env bash

# This creates proxmox docker container

#list debian images
#pveam available |grep debian-11
#get it into templates
pveam download local debian-11-standard_11.3-1_amd64.tar.zst

# always use 101 for docker
CTID=101

#destroy first then create
pct stop ${CTID}
pct destroy ${CTID}

#create the vm
pct create ${CTID} local:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst --hostname Docker --rootfs local-lvm:16 --ostype debian --unprivileged 1
#set memory and options
pct set ${CTID} -memory 2048 -cores 2 -cmode shell -onboot 1 -features keyctl=1,fuse=1,nesting=1 -swap 0 
#set networking
pct set ${CTID} -net0 name=eth0,bridge=vmbr0,firewall=0,ip=192.168.1.3/24,gw=192.168.1.1,type=veth

# start the ct
pct start ${CTID} --debug
#lxc-start -n ${CTID} -F -l DEBUG -o /tmp/lxc-CTID.log

#run some stuff in docker
pct exec 101 -- apt update
pct exec 101 -- apt dist-upgrade -y
pct exec 101 -- scp 192.168.1.2:/root/proxmox-nfp/install-docker.sh .
pct exec 101 -- sh install-docker.sh

pct exec 101 -- mkdir /docker
#put the containers here
#run the containers

#enter console
#pct console ${CTID}

#destroy
#pct stop ${CTID}; pct destroy ${CTID} --purge
