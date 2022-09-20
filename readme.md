# Proxmox NFP (NOT FOR PRODUCTION)

> **Warning**  This is not for Enterprise Environments
>
> **Warning**  This is not supported by Proxmox or affiliated in anyway!
> 
> **Warning**  You probably will delete or corrupt your computer with this!
> 
> **Warning**  Absolutely NO support, guarantee, or warranty is given or implied!

## Information

> **Note** Proxmox by design is meant to be a server, therefore it has a minimal OS.
>
> **Note** The purpose of this is create a home server and provide additional functionality.
>
> **Note** Proxmox typically bridges to the local lan, this puts everything behind OpenWrt.
>
> **Note** Typically Proxmox takes 2 machines, this is full GUI from a single console.

## Quick Instructions

> On your functioning machine create the installer media
> 
> Ensure IOMMU supported https://pve.proxmox.com/wiki/Pci_passthrough#Enable_the_IOMMU
> 
> Reinstall the machine with Proxmox, following the guide
> 
> Run the setup scripts
> 
> When you reboot into KIOSK mode press CTRL-N and browse to 192.168.1.1 for OpenWRT

### Prereq:

1. Download and install Ventoy
   * https://github.com/ventoy/Ventoy/releases
2. Download and copy Proxmox iso to the Ventoy data folder
   * https://www.proxmox.com/en/downloads/category/iso-images-pve
3. Download openwrt to the proxmox-nfp folder
   * https://downloads.openwrt.org/releases/22.03.0/targets/x86/64/

### Preinstall
1. Create Ventoy USB Key following their instructions
   * https://www.ventoy.net/en/doc_start.html
3. Copy Proxmox ISO to USB key
4. git clone this repo to the root of the USB key
5. Copy openwrt...gz to the root of the USB key

## Instructions

`unplug net`

`Boot computer`

1. Install proxmox - choose defaults except for network
   * hostname: `pve.lan`
   * ip: `192.168.1.2/24`
   * gw: `192.168.1.1`
   * dns: `192.168.1.1`

2. After Proxmox Install finished reboot
   * login
   * `mount /dev/sda1 /mnt`
   * `/mnt/proxmox-nfp/runme1st.sh` 

`plug in network`

`Boot computer`

3. Run setup
   * `proxmox-nfp/baseline.sh`

4. Install Docker
   * `proxmox-nfp/create-debian-docker-ct.sh`

## Not quite there yet

`TODO:` Docker containers
  * Yacht
  * Cloudflared
  * Traefik
  * Wireguard
  * AdGuard - point OpenWRT here

`TODO:` Reverse Proxy overlay/menu
