#!/usr/bin/env bash

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

fcitx5 &

1password --silent &

# For some reason, if suspend happens after ligher-locker, it can not lock due to permission issue.
light-locker --lock-on-suspend &

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# suspend 15 minutes after it locks` \
  --timer 900 \
    'systemctl suspend' \
    '' &
