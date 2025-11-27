# File server installer

This repository contains scripts and instructions to set up a simple file server using copyparty.

## Prerequisites

Only supported on Debian-based Linux distributions (e.g., Debian, Ubuntu, Pop!\_OS).

## Installation

1. cd into the directory you want to share:

   ```bash
      cd /path/to/your/directory
   ```

1. Download and run the installation script:

   ```bash
   sudo curl -L -0 https://github.com/mathealgou/fileserver/releases/latest/download/install.sh | bash
   ```

1. Follow the on-screen instructions to complete the setup.

1. After installation, you can start the file server with:

   ```bash
   python3 copyparty-sfx.py -c copyparty.conf
   ```

1. By default, the server should start every time the system boots. If you want to disable this behavior, run:

   ```bash
   sudo systemctl disable fileserver.service
   ```
