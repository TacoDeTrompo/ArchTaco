#!/usr/bin/env bash
#--------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗ █████╗  ██████╗ ██████╗ 
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗
#  ███████║██████╔╝██║     ███████║   ██║   ███████║██║     ██║   ██║
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██╔══██║██║     ██║   ██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║  ██║╚██████╗╚██████╔╝
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  
#--------------------------------------------------------------------

echo -e "\nFINAL SETUP AND CONFIGURATION"
echo "--------------------------------------"
echo "-- GRUB EFI Bootloader Install&Check--"
echo "--------------------------------------"
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
fi
grub-mkconfig -o /boot/grub/grub.cfg

# ------------------------------------------------------------------------

echo -e "\nEnabling Login Display Manager"
systemctl enable lightdm
echo -e "\nSetup LightDM Greeter"
sed -i 's/^#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
echo -e "\nSetup LightDM Webkit2 Greeter Theme"
sed -i 's/^webkit-theme       = antergos/webkit-theme       = litarvan' /etc/lightdm/lightdm-webkit2-greeter.conf
# ------------------------------------------------------------------------

echo -e "\nEnabling essential services"


systemctl enable NetworkManager.service
systemctl enable bluetooth.service
echo "
###############################################################################
# Cleaning
###############################################################################
"
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Replace in the same state
cd $pwd
echo "
###############################################################################
# Done - Please Eject Install Media and Reboot
###############################################################################
"
