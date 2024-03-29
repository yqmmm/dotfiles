# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# DistroTube's config: https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/qtile/config.py
# DEPENDENCIES:
# 1. alacritty
# 2. rofi
# 3. Wallpaper image.
# 4. Some packages required by qtile widgets.

import os
import subprocess

from libqtile import bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# from qtile_extras.widget.decorations import BorderDecoration

# Color Definition
cl_gray         = ["#282c34", "#282c34"]
cl_another_gray = ["#1c1f24", "#1c1f24"]
cl_white        = ["#dfdfdf", "#dfdfdf"]
cl_red          = ["#881111", "#881111"]
cl_light_red    = ["#ff6c6b", "#ff6c6b"]
cl_green        = ["#98be65", "#98be65"]
cl_orange       = ["#da8548", "#da8548"]
cl_blue         = ["#51afef", "#51afef"]
cl_purple       = ["#c678dd", "#c678dd"]
cl_green_blue   = ["#46d9ff", "#46d9ff"]
cl_blue_purple  = ["#a9a1e1", "#a9a1e1"]

# Functions to move windows
@lazy.function
def window_to_prev_group(qtile):
    i = qtile.groups.index(qtile.current_group)
    if qtile.current_window is not None and i != 0:
        qtile.current_window.togroup(qtile.groups[i - 1].name)
        qtile.current_screen.toggle_group(qtile.groups[i - 1])

@lazy.function
def window_to_next_group(qtile):
    i = qtile.groups.index(qtile.current_group)
    if qtile.current_window is not None and i != 9:
        qtile.current_window.togroup(qtile.groups[i + 1].name)
        qtile.current_screen.toggle_group(qtile.groups[i + 1])

@lazy.function
def rename_group(qtile):
    from libqtile.log_utils import logger

    def callback(text):
        if text:
            idx = qtile.groups.index(qtile.current_group)
            if idx is not None:
                qtile.groups[idx].set_label(f"{idx+1} [{text}]")

    try:
        mb = qtile.widgets_map['prompt']
        mb.start_input('Rename current group to', callback, None)
    except KeyError:
        logger.error("No widget named '%s' present.", widget)


#mod = "mod4" # win/super
mod = "mod1" # alt
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Move window
    Key([mod, "shift"], "i", window_to_prev_group(), desc="Move window to the previous group"),
    Key([mod, "shift"], "o", window_to_next_group(), desc="Move window to the next group"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # My Keymaps
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "m",
        lazy.layout.toggle_maximize(),
        desc='toggle window between minimum and maximum sizes'
    ),
    Key([mod], "bracketleft", lazy.screen.prev_group(), desc="Move focus up"),
    Key([mod], "bracketright", lazy.screen.next_group(), desc="Move focus up"),

    Key([mod], "period", lazy.next_screen(), desc='Next monitor'),

    Key([mod], "x", rename_group(), desc="Rename group"),
    
    # rofi
    Key([mod], "r", lazy.spawn("rofi -show run")),
    Key([mod], "p", lazy.spawn("rofi -show window")),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc="Switch to & move focused window to group {}".format(i.name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

# After adding key bindings, we can add a ScratchPad.
groups.append(
    ScratchPad("scratchpad", [
        DropDown("term", terminal, opacity=0.7, height=0.8),
    ])
)

keys.extend([
    Key([mod], "t", lazy.group["scratchpad"].dropdown_toggle("term")),
])

# Common layout settings.
layout_theme = {
    "border_width": 6,
    "margin": 4,
    "border_normal": "1D2330",
}

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Columns(
        **layout_theme,
        border_focus = cl_green,
        border_focus_stack = cl_red,
        insert_position = 1, # insert after current window, instead of before
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=24,
    icon_size=24,
    padding=14,
)

def parse_text(text):
    if "Firefox" in text:
        return "Firefox"
    return text

def init_widgets_list(is_primary):
    widges = [
        widget.CurrentLayout(
            fmt="{:^7s}", # Fixed length and align center
            font="mono"   # So it's fixed length
        ),
        widget.GroupBox(highlight_method='block'),
        widget.Prompt(),
        widget.TaskList(
            fontsize=20,
            margin=1,
            padding=12,
            parse_text=parse_text,
            theme_mode="fallback",
        ),
        # widget.WindowName(font='sans'),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        # widget.CheckUpdates(
        #     update_interval = 1800,
        #     distro = "Arch_yay",
        #     no_update_string = "No updates",
        #     display_format = "Updates: {updates} ",
        #     # foreground = colors[5],
        #     mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("alacritty" + ' -e sudo pacman -Syu')},
        #     padding = 5,
        # ),
        widget.Volume(
            foreground=cl_purple,
            fmt="Vol:{}",
            padding=5,
        ),
        widget.Memory(
            foreground=cl_blue_purple,
            fmt='Mem:{}',
            format='{MemUsed:.1f}{mm}/{MemTotal:.0f}{mm}',
            measure_mem='G',
        ),
        # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        # widget.StatusNotifier(),
        (widget.Systray() if is_primary else None),
        widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
        # widget.QuickExit(),
    ]

    return [w for w in widges if w is not None]


extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            init_widgets_list(True),
            50,
            border_width=[6, 0, 8, 0],  # Draw top and bottom borders
        ),
        # wallpaper='~/Pictures/clouds-over-mountain.jpg',
    ),
    Screen(
        top=bar.Bar(
            init_widgets_list(False),
            50,
            border_width=[6, 0, 8, 0],  # Draw top and bottom borders
        ),
        # wallpaper='~/Pictures/clouds-over-mountain.jpg',
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def start_once():
	home = os.path.expanduser("~")
	subprocess.call([home + "/.config/qtile/autostart.sh"])

