#!/bin/sh
BACKUP_PATH="/opt/backups/"
BACKUP_FILE="proxmox"
KEEP_DAYS=7
PVE_BACKUP_SET="/etc/.
                /root/.
                /usr/share/kvm/*.vbios
                /var/spool/cron
                /var/lib/pve-cluster/."
PVE_CUSTOM_BACKUP_SET="" #"/etc/apcupsd/ /etc/multipath/ /etc/multipath.conf"

if [ ! -d $BACKUP_PATH ]; then
  mkdir $BACKUP_PATH
fi

tar --warning='no-file-ignored' -cvzPf $BACKUP_PATH$BACKUP_FILE-$(date +%Y_%m_%d-%H_%M_%S).tar.gz \
        --absolute-names $PVE_BACKUP_SET $PVE_CUSTOM_BACKUP_SET

#prune
find $BACKUP_PATH$BACKUP_FILE-* -mindepth 0 -maxdepth 0 -depth -mtime +$KEEP_DAYS -delete
