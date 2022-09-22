# Proxmox NFP (NOT FOR PRODUCTION)

Automate Proxmox for home or development use.

Typically, Proxmox environment requires multiple machines: Proxmox server, user console, and network management. Proxmox typically bridges its network management interface to the local lan, it is expected that you run a firewall/dns/router in front of Proxmox, then use a desktop to interact with the Proxmox server.  

The purpose of this is to incorporate everything into a single machine. We remove the bridge to the local lan, install OpenWRT to manage the network, and set Proxmox to bridge the internal OpenWRT NAT network. Then we install a GUI desktop on the machine so you can browse to the local Proxmox and OpenWRT management consoles. To create an empirical environment when testing cloud systems and services locally.

`TODO:` we will add VPN/Wireguard access and cloudflared tunneling to our inside network.

> **Warning**  This is not for Enterprise Environments
>
> **Warning**  This is not supported by Proxmox or affiliated in anyway!
> 
> **Warning**  You probably will delete or corrupt your computer with this!
> 
> **Warning**  Absolutely NO support, guarantee, or warranty is given or implied!

## Information

> **Note** Proxmox is meant to be a server so it only has a minimal Operating System. This project is the opposite of their design. Since Proxmox was **not** designed for this functionality, do not ask them for support.
>
> **Note** As an paid or unpaid user of Proxmox you are subject to their changes, and therefor this may not function as designed. This project combines the work from **many** different people and which is also subject to change at anytime. Onkly an attempt was made to make this version independent.
>
> **Note** This project is still a work in progress and therefore it is not complete.

## Quick Instructions

> On a functioning machine create the installer media and copy this repo to the USB key
> 
> Ensure VTx enabled in BIOS `https://pve.proxmox.com/wiki/Pci_passthrough#Enable_the_IOMMU`
> 
> Install the machine with Proxmox USB key, following the specifics in this guide
> 
> Run the setup scripts in this repo from the usb key following the instructions
> 
> The final reboot will be into KIOSK mode. Press CTRL-N in browser, 192.168.1.1 for OpenWRT

### Requirements

- CPU: 64bit (Intel EMT64 or AMD64)
- Intel VT/AMD-V capable CPU/Mainboard (for KVM Full Virtualization support)
- Minimum 8GB RAM ( Recommanded 16 or more)
- Hard Drive 256GB ( Recommended 512GB or more)
- One Hardware NIC ( Recommended 2nd NIC for LAN and Wifi if you want OpenWRT to be an AP)
- USB key for installation

### Prereq:

1. Download and install Ventoy on the USB key
   * https://github.com/ventoy/Ventoy/releases
2. Download and copy Proxmox iso to the Ventoy data folder
   * https://www.proxmox.com/en/downloads/category/iso-images-pve
3. Download openwrt to the proxmox-nfp folder
   * https://downloads.openwrt.org/releases/22.03.0/targets/x86/64/

### Preinstall
1. Create Ventoy USB Key following their instructions
   * `https://www.ventoy.net/en/doc_start.html`
3. Copy Proxmox ISO to USB key
4. git clone this repo, or download the zip and extract to the USB key
5. Copy `openwrt...gz` to the root of the USB key

## Installation Detailed Instructions

`unplug network cable` To avoid DHCP

`Boot computer` from USB key

1. Install proxmox - choose defaults except for network
   * hostname: `pve.lan`
   * ip: `192.168.1.2/24`
   * gw: `192.168.1.1`
   * dns: `192.168.1.1`

2. After Proxmox Install finished reboot
   * login
   * `mount /dev/sda1 /mnt`
   * `/mnt/proxmox-nfp/runme1st.sh` 

`plug in network cable`

`Boot computer` 

3. Run setup
   * log in as root
   * run `proxmox-nfp/baseline.sh`
   * After reboot you will be brought to a GUI Proxmox Login

     > **Warning**  If DHCP is not available on the outside proxmox network, you will need to setup OpenWRT with a static ip. Press `CTRL-N` and browse to `192.168.1.1` to configure your outside connection.

4. Install Docker
   * log in as root in the Proxmox Gui
   * Browse to Console
   * Wait until you can ping the outside and you know OpenWRT has an ip address.
   * `proxmox-nfp/create-debian-docker-ct.sh`

## Not quite there yet

`TODO:` Docker containers
  * Yacht
  * Cloudflared
  * Traefik
  * Wireguard
  * AdGuard - point OpenWRT here

`TODO:` Reverse Proxy overlay/menu

# THANKS
 * Debian team - https://wiki.debian.org/Teams
 * Proxmox team - https://proxmox.com/about
 * OpenWRT team - https://openwrt.org/infrastructure
 * Docker team - https://docker.com/company/
 * Ventoy team - https://ventoy.net/en/donation.html
 * All the people that have shared their code - **Open Source FTW**
