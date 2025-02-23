#!/usr/bin/env bash
#--------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗ █████╗  ██████╗ ██████╗ 
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗
#  ███████║██████╔╝██║     ███████║   ██║   ███████║██║     ██║   ██║
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██╔══██║██║     ██║   ██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║  ██║╚██████╗╚██████╔╝
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  
#--------------------------------------------------------------------
echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi
echo "-------------------------------------------------"
echo "       Setup Language to US and set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone America/Monterrey
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap la-latin1

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

echo -e "\nInstalling Base System\n"

PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'accountsservice'
'adobe-source-han-sans-cn-fonts'
'adobe-source-han-sans-hk-fonts'
'adobe-source-han-sans-jp-fonts'
'adobe-source-han-sans-kr-fonts'
'adobe-source-han-sans-otc-fonts'
'adobe-source-han-sans-tw-fonts'
'base'
'bluez'
'bluez-libs'
'bluez-tools'
'blues-utils'
'blueberry'
'caribou'
'cinnamon'
'cinnamon-control-center'
'cinnamon-menus'
'cinnamon-screensaver'
'cinnamon-session'
'cinnamon-settings-daemon'
'cinnamon-translations'
'cjs'
'dbus-python'
'dnsmasq'
'edk2-ovmf'
'efibootmgr' # EFI boot
'gnome-backgrounds'
'gnome-themes-extra'
'gnome-terminal'
'gstreamer'
'grub'
'grub-customizer'
'gcc'
'gimp' # Photo editing
'git'
'gparted' # partition management
'gptfdisk'
'htop'
'iptables-nft'
'libcroco'
'libgnomekbd'
'libkeybinder3'
'librsvg'
'libvirt'
'linux'
'linux-firmware'
'linux-headers'
'lightdm'
'lightdm-webkit2-greeter'
'lightdm-webkit-theme-litarvan'
'lutris'
'make'
'metacity'
'mpv'
'muffin'
'nemo'
'nemo-fileroller'
'network-manager-applet'
'neofetch'
'ntfs-3g'
'noto-fonts'
'noto-fonts-emoji'
'pacman-contrib'
'pipewire' # audio framework
'wireplumber'
'pipewire-pulse'
'polkit-gnome'
'python-cairo'
'python-gobject'
'python-pam'
'python-pexpect'
'python-pillow'
'python-pyinotify'
'python-pytz'
'python-tinycss'
'python-xapp'
'python-pip'
'qemu'
'timezonemap'
'rar'
'system-config-printer'
'steam'
'steam-native-runtime'
'sudo'
'xapp'
'xed'
'xreader'
'unzip'
'unrar'
'usbutils'
'vim'
'virt-manager'
'wget'
'wine'
'wine-gecko'
'wine-mono'
'winetricks'
'zip'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

#
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia nvidia-utils lib32-nvidia-utils --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo -e "\nDone!\n"
if ! source install.conf; then
	read -p "Please enter username:" username
echo "username=$username" >> ${HOME}/ArchTaco/install.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel,libvirt -s /bin/bash $username 
	passwd $username
	cp -R /root/ArchTaco /home/$username/
    chown -R $username: /home/$username/ArchTaco
	read -p "Please name your machine:" nameofmachine
	echo $nameofmachine > /etc/hostname
else
	echo "You are already a user proceed with aur installs"
fi

