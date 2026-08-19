# Interactive tooling: prompt, completions, fuzzy finding, directory jumping.

# ── Node via nvm, lazy-loaded so new shells stay fast ─────────────────────────
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # Put the default node on PATH immediately, defer nvm itself until first use.
  _nvm_resolve() {                       # follow the alias chain to a version
    local v="$1" i=0
    while [ -n "$v" ] && [ "${v#v}" = "$v" ] && [ $i -lt 5 ]; do
      [ -r "$NVM_DIR/alias/$v" ] || return 1
      v="$(command cat "$NVM_DIR/alias/$v")"
      i=$((i + 1))
    done
    printf '%s' "$v"
  }
  if [ -r "$NVM_DIR/alias/default" ]; then
    _nvm_ver="$(_nvm_resolve "$(command cat "$NVM_DIR/alias/default")")"
    # An alias may name a major line (v22) rather than an exact build.
    if [ -n "$_nvm_ver" ] && [ ! -d "$NVM_DIR/versions/node/$_nvm_ver" ]; then
      _nvm_ver="$(command ls "$NVM_DIR/versions/node" 2>/dev/null |
        grep "^${_nvm_ver}" | sort -V | tail -1)"
    fi
    [ -n "$_nvm_ver" ] && [ -d "$NVM_DIR/versions/node/$_nvm_ver/bin" ] &&
      PATH="$NVM_DIR/versions/node/$_nvm_ver/bin:$PATH"
    unset _nvm_ver
  fi
  unset -f _nvm_resolve
  nvm() {
    unset -f nvm
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi

# ── Completions ───────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' menu select

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS AUTO_CD

# ── zsh autosuggestions (brew) ────────────────────────────────────────────────────────
if command -v brew >/dev/null 2>&1; then
  _brew_share="$(brew --prefix)/share"
  [ -f "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] &&
    . "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  unset _brew_share
fi

# ── fzf ───────────────────────────────────────────────────────────────────────
if command -v fzf >/dev/null 2>&1; then
  # fzf >=0.48 ships shell integration; older installs use ~/.fzf.zsh
  if fzf --zsh >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
  elif [ -f "$HOME/.fzf.zsh" ]; then
    . "$HOME/.fzf.zsh"
  fi
fi

# ── Prompt ────────────────────────────────────────────────────────────────────
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ── zoxide replaces cd (after any other cd override) ─────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

# ── Syntax highlighting (must be last: it wraps every widget defined before it)
if command -v brew >/dev/null 2>&1; then
  _hl="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [ -f "$_hl" ] && . "$_hl"
  unset _hl
fi
