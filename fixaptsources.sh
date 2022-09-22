#/bin/bash
APTSDIR=/etc/apt/sources.list.d

#comment out oem
if read -n1 c <"${APTSDIR}/pve-enterprise.list"; [[ $c = "#" ]]; then
        echo enterprise commented already assuming sources are fine
else
        echo commenting enterprise
        sed -i -e '1s/./#&/' ${APTSDIR}/pve-enterprise.list
        echo creating no-sub list
        echo deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription >${APTSDIR}/pve-no-subscription.list
fi

echo "updating and upgrading"
#update and upgrade
pveupdate
pveupgrade
