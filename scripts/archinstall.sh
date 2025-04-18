#!/bin/bash

# Configuration
LOG_FILE="./setup.log"
SMBPASS="${2:-}"
DOTFILES_DIR="dotfiles"
ASSETS_DIR="assets"

# Utility functions
log_action() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

notify() {
  local message=$1 expire_time=${2:-10000}
  command -v notify-send &>/dev/null && notify-send "$message" --expire-time="$expire_time"
  log_action "$message"
}

check_root() {
  [[ $EUID -eq 0 ]] && {
    echo "This script should not be run as root"
    exit 1
  }
}

check_command() {
  command -v "$1" &>/dev/null || {
    log_action "$1 not found"
    return 1
  }
}

# Setup functions
prepare() {
  log_action "Preparing system..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm git base-devel zsh stow
  if ! check_command yay; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi
  notify "System preparation complete"
}

setup_terminal() {
  log_action "Setting up terminal..."
  sudo pacman -S --needed --noconfirm git zsh stow
  check_command curl || {
    notify "curl required"
    exit 1
  }

  # Install oh-my-zsh
  [[ ! -d ~/.oh-my-zsh ]] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Set zsh as default shell
  chsh -s "$(which zsh)" "$USER"

  # Install zsh plugins
  local zsh_custom=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
  local plugins=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-completions"
  )

  for plugin in "${plugins[@]}"; do
    local dest="$zsh_custom/plugins/${plugin##*/}"
    [[ ! -d "$dest" ]] && git clone "https://github.com/$plugin" "$dest"
  done

  # Install starship
  check_command starship || curl -sS https://starship.rs/install.sh | sh -s -- -y

  # Setup dotfiles
  rm -rf ~/.config/nvim ~/.zshrc ~/.config/starship ~/.config/tmux ~/.config/kitty ~/.config/ghostty
  stow -d "$DOTFILES_DIR" -t ~ zsh starship tmux kitty nvim ghostty wezterm
  notify "Terminal setup complete"
}

setup_ssh() {
  log_action "Configuring SSH..."
  mkdir -p ~/.ssh
  local ssh_keys=(
    "qp_ed25519:sifat@workstation"
    "id_ed25519:mahi@workstation"
  )

  for key in "${ssh_keys[@]}"; do
    IFS=':' read -r filename comment <<<"$key"
    [[ ! -f ~/.ssh/$filename ]] && ssh-keygen -t ed25519 -C "$comment" -f ~/.ssh/"$filename" -N ""
  done

  cat >~/.ssh/config <<EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

Host qp.github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/qp_ed25519
EOF
  chmod 600 ~/.ssh/config
  notify "SSH setup complete"
}

setup_conf() {
  log_action "Configuring system..."
  echo "Color" | sudo tee -a /etc/pacman.conf
  notify "System configuration complete"
}

setup_native() {
  log_action "Installing native applications..."
  check_command fnm || curl -fsSL https://fnm.vercel.app/install | bash
  [[ -f "$ASSETS_DIR/yay.txt" ]] && yay -S --noconfirm - <"$ASSETS_DIR/yay.txt"
  notify "Native applications installed"
}

setup_flatpak() {
  log_action "Setting up Flatpaks..."
  check_command flatpak || {
    notify "Flatpak not installed"
    exit 1
  }
  flatpak update -y
  [[ -f "$ASSETS_DIR/flatpak.sh" ]] && source "$ASSETS_DIR/flatpak.sh" && notify "Flatpaks installed" || log_action "flatpak.sh not found"
}

setup_theme() {
  log_action "Installing themes..."
  yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts noto-fonts-extra noto-fonts-emoji adw-gtk-theme kora-icon-theme ttf-indic-otf
  curl -s https://wallpapers.manishk.dev/install.sh | bash -s Lakeside
  notify "Themes installed"
}

setup_gnome() {
  log_action "Configuring GNOME..."
  check_command gsettings || {
    notify "GNOME settings not available"
    exit 1
  }

  gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans Regular 11'
  gsettings set org.gnome.desktop.interface font-name 'Noto Sans Regular 11'
  gsettings set org.gnome.desktop.interface monospace-font-name 'JetbrainsMono Nerd Font Regular 11'
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.sound theme-name 'Click'
  gsettings set org.gnome.shell.app-switcher current-workspace-only true
  gsettings set org.gnome.desktop.interface accent-color 'green'
  gsettings set org.gnome.desktop.interface clock-show-seconds true
  gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
  gsettings set org.gnome.desktop.background picture-uri 'file:///$HOME/.local/share/backgrounds/gnome/Lakeside-timed.xml'
  gsettings set org.gnome.desktop.background picture-options 'zoom'
  gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
  gsettings set org.gnome.desktop.wm.preferences button-layout 'close:appmenu'

  notify "GNOME configuration complete"
}

# Help function
usage() {
  cat <<EOF
Usage: $0 [OPTIONS]
Options:
  -h    Show this help message
  -f    Setup Flatpaks
  -c    Setup system configuration and themes
  -g    Configure GNOME desktop
  -t    Setup terminal environment
  -p    Prepare system and install yay
  -s    Configure SSH
  -n    Install native applications
  -a    Run all setup functions
EOF
  exit 0
}

# Main
main() {
  check_root
  mkdir -p "$(dirname "$LOG_FILE")"
  touch "$LOG_FILE"

  while getopts ":hfgtpsnca" opt; do
    case $opt in
    h) usage ;;
    f) setup_flatpak ;;
    c)
      setup_conf
      setup_theme
      ;;
    g) setup_gnome ;;
    t) setup_terminal ;;
    p) prepare ;;
    s) setup_ssh ;;
    n) setup_native ;;
    a)
      prepare
      setup_terminal
      setup_ssh
      setup_conf
      setup_native
      setup_flatpak
      setup_theme
      setup_gnome
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    esac
  done

  [[ $OPTIND -eq 1 ]] && {
    echo "No options specified"
    usage
  }
}

main "$@"
