## Fixes

### Run Flameshot with shortcut in wayland

```bash
gsettings set org.gnome.mutter keybindings "['<Super>F11', 'script --command "flameshot gui" /dev/null']"
```

### Fix for `flatpak run --filesystem=host` in wayland

```bash
flatpak override --user --talk-name=org.freedesktop.Flatpak --filesystem=host
```

### Swap Partitions

- Create a swap partition

```bash
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 16g --uuid clear /swap/swapfile
swapon /swap/swapfile
```

- Add to `/etc/fstab`

```bash
/swap/swapfile none swap defaults 0 0
```
