This could be a makefile or a script.

# Qtile (Tiling Window Manager)

packages:
```
qtile
xcb-util-cursor
python-psutil
alsa-utils
```

Becuase we use the `start_once` hook of qtile. We may also install things related to polkit 

The configuration is in `~/.config/qtile/config.py`, use `make qtile` to install.

# Power Managerment

TODO

# Polkit

This is needed by fancy 1password things.

Intallation:
```bash
sudo pacman -S polkit polkit-gnome
```

# ScreenShots

`import` from `imagemagick` let you select a region of the screen.

# Font

Mono: `ttf-jetbrains-mono`
Chinese: `wqy-microhei`

TODO: Explore more.

# Fcitx

Packages:
```
fcitx5 fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-configtool
```

Add this to `/etc/environment` or `~/.pam_environment`:
```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

Use `fcitx5-qt` to configure.

# Bluetooth

Packages:
```
bluez
bluez-utils
pipewire-pulse # for audio
```

Connect with the `bluetoothctl` dance.

# Audio

Packages:
```
pipwire
wireplumber
```

Enable and start `pipwire.service`, `wireplumber.service`, `pipewire-pulse.servic`.

# AMD GPU

I used the open source driver installed by archinstall.

```
mesa-vdpau
```

