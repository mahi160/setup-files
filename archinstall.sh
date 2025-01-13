#!/bin/bash
SMBPASS=$2
log_action() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}
notify() {
    local message=$1
    local expire_time=${2:-10}
    if command -v notify-send &>/dev/null; then
        notify-send "$message" --expire-time="$expire_time"
    fi
    log_action "$message"
}

prepare() {
    echo "Prepare and setup yay..."
    sudo pacman -Syu
    sudo pacman -Sy --needed --noconfirm git base-devel git zsh stow
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    cd .. && rm -rf yay
    yay
    notify "Prepare Done"
}

setup_terminal() {
    sudo pacman -Sy --needed --noconfirm git zsh stow
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    chsh -s "$(which zsh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    curl -sS https://starship.rs/install.sh | sh
    rm ~/.zshrc ~/.config/alacritty ~/.config/nvim ~/.config/starship.toml ~/.config/tmux ~/.config/ghostty
    stow --dir=dotfiles -t ~/ zsh starship tmux alacritty nvim ghostty
    notify "Terminal Setup"
}

setup_ssh() {
    ssh-keygen -t ed25519 -C "sifat@workstation" -f ~/.ssh/qp_ed25519
    ssh-keygen -t ed25519 -C "mahi@workstation" -f ~/.ssh/id_ed25519
    touch ~/.ssh/config
    echo "
	# Primary GitHub account
	Host github.com
  		HostName github.com
  		User git
  		IdentityFile ~/.ssh/id_ed25519

	# Secondary GitHub account
	Host qp.github.com
  		HostName github.com
  		User git
  		IdentityFile ~/.ssh/qp_ed25519
	" >>~/.ssh/config
}

setup_conf() {
    #sudo echo "
    #/dev/nvme0n1p3 /mnt/Base auto defaults,nofail 0 0
    #//192.168.0.103/groot /mnt/Groot cifs username=mahi,password=$SMBPASS,nofail 0 0
    #//192.168.0.103/mahi160 /mnt/Mahi160 cifs username=mahi,password=$SMBPASS,nofail 0 0" > /etc/fstab
    sudo echo "Color" >>/etc/pacman.conf
}

setup_native() {
    #curl -fsSL https://fnm.vercel.app/install | bash
    #curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    #curl -fsSL https://deno.land/install.sh | sh
    if [ -f ./assets/yay.txt ]; then
        yay -S --noconfirm $(cat ./assets/yay.txt)
    fi
}

setup_flatpak() {
    flatpak update -y
    if [ -f ./assets/flatpak.sh ]; then
        source ./assets/flatpak.sh
        notify "Flatpaks installed"
    else
        log_action "flatpak.sh not found"
    fi
}

setup_theme() {
    yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji adw-gtk-theme papirus-icon-theme ttf-indic-otf
    curl -s https://wallpapers.manishk.dev/install.sh | bash -s Lakeside

}

setup_gnome() {
    # Set font
    # gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans Regular 11'
    # gsettings set org.gnome.desktop.interface font-name 'Noto Sans Regular 11'
    # gsettings set org.gnome.desktop.interface monospace-font-name 'JetbrainsMono Nerd Font Regular 11'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.sound theme-name 'Click'
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.desktop.interface accent-color 'green'
    gsettings set org.gnome.desktop.interface clock-show-seconds true
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
    gsettings set org.gnome.desktop.background picture-uri "file:///$HOME/.local/share/backgrounds/gnome/Lakeside-timed.xml"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
    gsettings set org.gnome.desktop.wm.preferences button-layout "close:appmenu"
}
Help() {
    # Display Help
    echo "Add description of the script functions here."
    echo
    echo "Syntax: scriptTemplate [-g|h|v|V]"
    echo "options:"
    echo "f     Setup flatpaks"
    echo "g     Setup gnome"
    echo "t     Setup terminal"
    echo "p     Prepare and update"
    echo "s     Setup SSH"
    echo "n     Setup native apps"
    echo "c     Setup Conf"
    echo "a     Setup all"
    echo
}
while getopts ":hfgtpsnca" option; do
    case $option in
    h)
        Help
        exit
        ;;
    f)
        setup_flatpak
        exit
        ;;
    c)
        # setup_conf
        setup_theme
        exit
        ;;
    g)
        setup_gnome
        exit
        ;;
    t)
        setup_terminal
        exit
        ;;
    p)
        prepare
        exit
        ;;
    s)
        setup_ssh
        exit
        ;;
    n)
        setup_native
        exit
        ;;

    \?) # Invalid option
        echo "Error: Invalid option"
        exit
        ;;
    esac
done
