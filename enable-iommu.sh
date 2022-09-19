#!/bin/bash

#enable iommu
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt"/' /etc/default/grub
update-grub
reboot
