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

Here is a tutorial from the Ubuntu website: <https://ubuntu.com/tutorials/install-ubuntu-server>

### Create a DNS entry for the new server

Create an A record in your internal DNS pointing to the IP you assigned to the new server. `librenms.demo.org` is a reasonable choice for the fqdn, but feel free to choose any naming scheme that fits your organization. In the remainder of the document, everything to the left of the first dot (`librenms` in the example) is referred to as the `hostname`, and everything to the right of the first dot is referred to as the `domain` (`demo.org` in the example).

### Install Docker-CE from the Docker Repository

Follow the "Install using the `apt` repository" instructions in the official Docker Engine installation instructions found here: <https://docs.docker.com/engine/install/ubuntu/>

NOTE: that guide also provides instructions for removing the unofficial Docker packages, which you can follow if you aren't sure if you're starting from a clean slate.

## Setup the LibreNMS Docker Environment

### Clone this Git repository into the home directory

1. Connect to the librenms server using SSH.

2. In your home directory, copy-paste and enter these commands:

    ```bash
    git clone --single-branch --branch main https://github.com/mskalecki/librenms-setup.git
    ```

### Setup the `/var/librenms` directory for your environment

1. Run the provided `setup.sh` script to make the directory and populate it with the base configuration files.

    ```bash
    cd librenms-setup
    sudo bash ./setup.sh
    ```

2. Modify the `.env` file with information specific to your environment:
    1. Open the file for editting using

        ```bash
        sudo nano /var/librenms/.env
        ```

    2. Replace the `<strong_password>` placeholder with a long and complex password. You should securely store it in case you need to manually access the database some time in the future.

3. Modify the `Caddyfile` file with information specific to your environment:
    1. Open the file for editting using

        ```bash
        sudo nano /var/librenms/Caddyfile
        ```

    2. Replace the `<librenms_fqdn>` placeholder with the fqdn corresponding to the DNS entry for the librenms server (eg: `librenms.demo.org`).

### Bring up the Docker Containers
Run the following command to create and bring online the Docker containers for the first time.

```bash
cd /var/librenms
sudo docker compose up -d
```

This initial start-up will automatically do a few things:

1. Docker will pull down the images you need from Docker Hub.
2. Containers with volumes mapped to mount points on the host will populate sub-directories and files in the `/var/librenms` directory.
3. Create a fresh instance of LibreNMS accessible at `https://<librenms_fqdn>` (hopefully).

## Verify that LibreNMS is online and create the initial admin

1. Navigate to `https://<librenms_fqdn>` (eg: `https://librenms.demo.org`) in a web browser.
2. If all went well, you'll be prompted to create an administrator account.
    1. `librenms` is a reasonable username, but it can be anything that matches your organizations conventions.
    2. This account shouldn't be used for everyday access. It will be used for things that shouldn't be associated with Real People, like Oxidized's API access.
3. Once the account is created, choose to "validate" the configuration.
4. Login with the freshly created credentials, and ignore the handful of warnings and errors that you currently see, because we'll take care of them.

## 
