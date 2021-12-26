#!/usr/bin/env bash
#--------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗ █████╗  ██████╗ ██████╗ 
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗
#  ███████║██████╔╝██║     ███████║   ██║   ███████║██║     ██║   ██║
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██╔══██║██║     ██║   ██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║  ██║╚██████╗╚██████╔╝
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  
#--------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm
cd ~

PKGS=(
'brave-bin' # Brave Browser
'dxvk-bin' # DXVK DirectX to Vulcan
'gnome-terminal-fedora'
'papirus-icon-theme'
'papirus-folders'
'pamac-aur'
'protontricks'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'
'xviewer'
'pix'
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

git clone "https://github.com/schorpy/Cinnazor.git"
if [[ ! -d "${HOME}/.themes" ]]; then
    mkdir ${HOME}/.themes
fi
cp -r Cinnazor/Cinnazor/ .themes
rm -r Cinnazor

gsettings set org.cinnamon.theme name "Cinnazor"
gsettings set org.cinnamon.desktop.interface gtk-theme "Cinnazor"
gsettings set org.cinnamon.desktop.wm.preferences theme "Cinnazor"
gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus-Dark'

echo -e "\nDone!\n"
exit
