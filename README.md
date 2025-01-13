## Setup Server

- Make sure docker and docker-compose are installed

### Setup portainer

Portainer is a lightweight management UI which allows you to easily manage your Docker host or Swarm cluster. It is a fully functional, web-based UI for the Docker API which can be used to manage and monitor your Docker containers, images, networks and volumes.

```bash
docker volume create portainer_data && \
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5
```

### Setup Services

- To know your server IP, run `ip addr | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n 1`
- Once the portainer is up and running, you can access it at `https://<server-ip>:9443`
- Go through initial setup
- Go to **Stacks** and create a new stack

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
