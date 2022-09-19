#!/bin/bash

#backup oem
if [ ! -f /etc/network/interfaces-oem ]; then
  cp /etc/network/interfaces /etc/network/interfaces-oem
fi

# Fix network
#TODO fix clobber
sed -i 's/address.*/address 192.168.1.2\/24/' /etc/network/interfaces
sed -i 's/gateway.*/gateway 192.168.1.1/' /etc/network/interfaces
sed -i 's/bridge-ports.*/bridge-ports none/' /etc/network/interfaces
