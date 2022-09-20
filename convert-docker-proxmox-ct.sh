#!/bin/bash
#####################################################
#
# Convert Docker container to Proxmox LCX CT
#
# Required
# TODO - auto install
# apt install skopeo umoci jq
#####################################################

# Settings
#----------------------------------------------------
# TODO - make this a command line 

# first part of docker
USER=homeassistant
# sub docker
NAME=home-assistant
# version
VER=latest
# base os
BASEOS=
#
# container settings
#----------------------------------------------------
# Get the next guest VM/LXC ID
CTID=$(pvesh get /cluster/nextid)
# contiaer root passowrd
CTPASS=changeme
# Storage location of the container
STORAGE=local
# Bridge network
BR=vmbr0
# Container Memory size in megs
CTMEMORY=256
# Container Disk size in gigs
CTDISKSZ=10

# container network 
#----------------------------------------------------
# ip of container
IP=192.168.1.40
# name server for the container
NS=192.168.1.1
# gateway for the container
GW=192.168.1.1
#Network settings for the container
NET=${IP}/24,gw=${GW}
# or NET=DHCP
CTNETLINE0="-net0 name=eth0,bridge=${BR},ip=${NET}"

#####################################################
# No need to below
#####################################################

# some color settings for script
R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
C='\033[0m' # No Color
# Internal vars
L=~/docker-pct.log
BACKUPDIRN=/var/lib/vz/template/cache
BACKUPLXCD=/var/lib/lxc/${NAME}
BACKUPNAME=${NAME}_template.tar.gz
CTTEMPLATE=${BACKUPDIRN}/${BACKUPNAME}
#check if defined and format correctly
[[ ! -z ${USER} ]] && USER=${USER}/
[[ ! -z ${BASEOS} ]] && CTOSTYPE=--OSTYPE ${BASEOS}

#####################################################
# Start
#####################################################

# clean log
rm ${L}
pct destroy ${CTID}
lxc-destroy ${CTID}
rm ${CTTEMPLATE}

#----------------------------------------------------
# look for existing container template
echo -e ${B}Checking for CT Template${c}
if [[ ! -f "${CTTEMPLATE}" ]]
then 
	# no template lets go
	echo -e ${G}No CT Template found${C}
	# look for lxc docker image
	echo -e ${B}Checking for Standard LXC${C}
	if [[ ! -d ${BACKUPLXCD} ]]
	then
		echo -e ${G}No Standard LXC Found${C}
		#ok create lxc from docker
		echo -e ${R}CREATE Standard LXC -- Please wait --${C}
		echo -en ${Y}
		echo lxc-create ${NAME} -t oci -- --url docker://${USER}${NAME}:${VER}
		echo -en ${C}
		lxc-create ${NAME} -t oci -- --url docker://${USER}${NAME}:${VER} >> $L 2>&1
		#error check
		if [ ! $? -eq 0 ]; then
			echo -e ${R}ERRROR${C}
			exit 2
		fi
	else
		echo -e ${G}Found Standard LXC${C}
	fi

	# docker lxc now exists ready to backup 
	echo -e ${R}CREATE Proxmox LXC Template${C}
	EXCLUDES=(
		--exclude='sys'
		--exclude='dev'
		--exclude='run'
		--exclude='proc'
		--exclude='*.log'
		--exclude='*.log*'
		--exclude='*.gz'
		--exclude='*.sql'
		--exclude='swap.img'
	)
	# backup
	echo -en ${Y}
	echo tar -czf "${CTTEMPLATE}" -C "${BACKUPLXCD}/rootfs/" "${EXCLUDES[@]}" .
	echo -en ${C}
	tar -czf "${CTTEMPLATE}" -C "${BACKUPLXCD}/rootfs/" "${EXCLUDES[@]}" . >> $L 2>&1
	#check backup
	if [ $? -eq 0 ]; then
		# backup made remove the docker lxc
		echo -e ${G}CREATED ${CTTEMPLATE}
		echo -e ${B}REMOVING Standard LXC${C}
		echo -en ${Y}
		echo lxc-destroy ${NAME}
		echo -en ${C}
		lxc-destroy ${NAME} >> $L 2>&1
		# TODO - error check - assume ok
	else
		# backup failed
		echo -e ${R}FAIL${C}
		exit 2
	fi
	#
else
	# found proxmox lxc template
	echo -e ${R}FOUND TAR${C}: ${CTTEMPLATE}
fi
# proxmox lxc template exists now

# now make a proxmox lxc from the template we just made
echo -e ${R}CREATE Proxmox LXC${C}: ID = ${CTID}
PCTCREATE="
	${CTID} 
	${BACKUPDIRN}/${BACKUPNAME}
	${CTOSTYPE}
	-description ${NAME}
	-hostname ${NAME}
	-nameserver ${NS}
	${CTNETLINE0}
	--rootfs ${CTDISKSZ} -memory ${CTMEMORY}
	-storage ${STORAGE} 
	--features nesting=1
	-password=${CTPASS}
	"
echo -en ${Y}
echo pct create ${PCTCREATE}
echo -en ${C}
pct create ${PCTCREATE} >> $L 2>&1

# check to see if proxmox added the container 
if [ $? -eq 0 ]; then
	echo -e ${G}CREATED Proxmox LXC${C}: ${CTID}
	# start container
	pct start ${CTID} >> $L 2>&1
else
	echo -e ${R}FAIL${C}
	exit 2
fi

# connect to container console
lxc-attach -n ${CTID}
