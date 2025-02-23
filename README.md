# ArchTaco Installer Script

<!--img src="https://i.imgur.com/YiNMnan.png" /-->

This script was forked from the [ArchTitus Installer Script](https://github.com/ChrisTitusTech/ArchTitus)

This README contains the steps I do to install and configure a fully-functional Arch Linux installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all my preferred applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

```diff
- WARNING! -
This repository is a work in progress, if you run the script at the moment, it is almost
guaranteed to fail. Please do not use this script to install Arch Linux if you are not
familiarized with the installation process. If you wish to install Arch using a reliable
script please check the original project from where this script is forked.
```

---
## Create Arch ISO or Use Image

Download ArchISO from <https://archlinux.org/download/> and put on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)

## Boot Arch ISO

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/TacoDeTrompo/ArchTaco.git
cd ArchTaco
./archtaco.sh
```

### System Description
This is completely automated arch install of the Cinnamon desktop environment on arch using all the packages I use on a daily basis. 

## Troubleshooting

__[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

### No Wifi

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`. 
