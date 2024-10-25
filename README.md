# LibreNMS Setup

## Introduction
This repo is designed to guide you through setting up a fully featured LibreNMS environment with as little hassle as practically possible.

**WARNING: do NOT expose LibreNMS to incoming Internet traffic.**

## Prerequisites
This guide assumes requires two things:
- An internal dns server (Active Directory or anything else that is not exposed to the Internet)
- The ability to setup an Ubuntu server
- Enough familiarity with Linux to use ssh and run basic commands and edit text files

## Initial Server Setup
### Sizing
If you're monitoring fewer than 100 devices, this should do well to get you started:
- 2 cpu-cores
- 8gb ram
- 100gb disk (more if you have many network ports and are keeping a full two-year history)

If you out-grow that, you probably want to consider scaling out beyond this simple single node setup

### Initial Setup of Ubuntu Server LTS
The remainder of this guide assumes that you have setup Ubuntu 24.04 with ssh-server.
- This server should have a static IP (or DHCP reservation) on a network that can communicate with all devices to be monitored.
- This sever should NOT have any optional software installed, except for ssh-server. In particular, if you have installed Docker through the initial installer, either remove it or wipe and reinstall Ubuntu.

Here is a tutorial from the Ubuntu website: https://ubuntu.com/tutorials/install-ubuntu-server

### Create a DNS entry for the new server
Create an A record in your internal DNS pointing to the IP you assigned to the new server. `librenms.<my_domain>` is a reasonable choice for the fqdn, but feel free to choose any naming scheme that fits your organization. In the remainder of the document, everything to the left of the first dot (`librenms` in the example) is referred to as the `hostname`, and everything to the right of the first dot is referred to as the `domain` (`<my_domain>` in the example).

### Install Docker-CE from the Docker Repository
Follow the "Install using the `apt` repository" instructions in the official Docker Engine installation instructions found here: https://docs.docker.com/engine/install/ubuntu/

NOTE: that guide also provides instructions for removing the unofficial Docker packages, which you can follow if you aren't sure if you're starting from a clean slate.

## Setup the LibreNMS Docker Environment
### Clone this Git repository into the home directory
1. Connect to the librenms server using SSH.
2. In your home directory, copy-paste and enter these commands:
```bash
git clone --single-branch --branch main https://github.com/mskalecki/librenms-setup.git
cd librenms-setup
chmod 700 setup.sh setup-oxidized.sh
sudo ./setup.sh
```
3. Modify the `.env` file with information specific to your environment:
    1. Open the file for editting using `sudo nano /var/librenms/.env`
    2. Replace the `<strong_password>` placeholder with a long and complex password. You should securely store it in case you need to manually access the database some time in the future.
