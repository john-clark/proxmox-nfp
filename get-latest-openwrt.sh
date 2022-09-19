#!/usr/bin/env bash
cd ~/proxmox-nfp

#find the latest verison from the web
regex='<strong>Current Stable Release - OpenWrt ([^/]*)<\/strong>' && response=$(curl -s https://openwrt.org) && [[ $response =~ $regex ]] && stableVersion="${BASH_REMATCH[1]}"

#setup the filename we want
FILENAME=openwrt-$stableVersion-x86-64-generic-ext4-combined.img

#check we got it or download
if [ -f ./${FILENAME} ]; then
  echo $FILENAME exists
else	
  wget https://downloads.openwrt.org/releases/$stableVersion/targets/x86/64/${FILENAME}.gz
  #expand
  gunzip ./${FILENAME}.gz
fi
