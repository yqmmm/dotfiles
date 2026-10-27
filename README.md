# dotfiles

This is my personal dotfiles that is not expected to work on any others' computer.

## Things I use

[Karabiner](https://pqrs.org/osx/karabiner/) is a keyboard customizer for macOS. It is Powerful and Stable. But the advanced configuration is in JSON, making it quite verbose.

[Goku](https://github.com/yqrashawn/GokuRakuJoudo) is a tool that manages Karabiner configuration with ease. It is written in Clojure and the configuration file is in Clojure edn format.

[fzf](https://github.com/junegunn/fzf#installation): Just for `CTRL-R` with super power.

[neovim](http://neovim.io): A bless to use with all the Lua, LSP, terminal support.

[alacritty](https://github.com/alacritty/alacritty): Super fast terminal emulator.

[ghostty](https://ghostty.org): GPU-accelerated terminal emulator with native platform integrations.

[Zellij](https://zellij.dev): Terminal workspace and multiplexer.

## Agent skills

Skill source lives in the separate private `agent-skills` repository, normally at `~/code/agent-skills`. This repository manages installation links only.

```sh
make -C "$HOME/.dotfiles" skills
```

This links each `<name>/SKILL.md` skill into `~/.agents/skills/<name>`. `make install` also includes this step. Re-running it is safe; it upgrades links from the former dotfiles skill location and refuses to replace unrelated files or links.

Override `AGENT_SKILLS_DIR` to use another checkout, or `AGENT_SKILLS_TARGET` to install links for another agent:

```sh
make -C "$HOME/.dotfiles" skills AGENT_SKILLS_TARGET="$HOME/.claude/skills"
```

The real skill files remain in `agent-skills`; neither installation path contains a separate copy.
