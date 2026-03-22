if [[ -n "${ZSH_VERSION:-}" ]]; then
  autoload -Uz add-zsh-hook

  _zellij_set_title() {
    [[ -n "${ZELLIJ:-}" ]] || return
    printf '\033]0;%s\007' "$1"
  }

  _zellij_precmd_title() {
    _zellij_set_title "${(%):-%~}"
  }

  _zellij_preexec_title() {
    local -a cmd
    local token

    cmd=("${(z)1}")
    for token in "${cmd[@]}"; do
      case "$token" in
        sudo|env|command|builtin|noglob|nocorrect|time)
          continue
          ;;
        *=*)
          continue
          ;;
        *)
          _zellij_set_title "$token"
          return
          ;;
      esac
    done
  }

  add-zsh-hook precmd _zellij_precmd_title
  add-zsh-hook preexec _zellij_preexec_title
fi
