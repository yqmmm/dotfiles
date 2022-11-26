This could be a makefile or a script.

# Qtile (Tiling Window Manager)

packages: `qtile`, `qtile-extras-git`.

Becuase we use the `start_once` hook of qtile. We may also install things related to polkit 

The configuration is in `~/.config/qtile/config.py`, use `make qtile` to install.

# Power Managerment

TODO

# Polkit

This is needed by fancy 1password things.

Intallation:
```bash
# Used polkit-kde-agent because I had it. It is actually quite heavy and maybe we can change it to something simpler.
sudo pacman -S polkit polkit-kde-agent
```

Haven't done a fresh installation. But maybe I need to install polkit before 1password to make everything work?
