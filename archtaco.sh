#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchTaco/1-setup.sh
    source /mnt/root/ArchTaco/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTaco/2-user.sh
    arch-chroot /mnt /root/ArchTaco/3-post-setup.sh