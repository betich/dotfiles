# PATH entries, most-specific last. Each is added only if it exists.

path_prepend() { [ -d "$1" ] && case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH" ;; esac; }
path_append()  { [ -d "$1" ] && case ":$PATH:" in *":$1:"*) ;; *) PATH="$PATH:$1" ;; esac; }

# Homebrew (Apple Silicon and Intel prefixes)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User binaries (uv, pipx, platformio all land here)
path_prepend "$HOME/.local/bin"

# Bun
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[ -d "$PNPM_HOME" ] || PNPM_HOME="$HOME/.local/share/pnpm"
path_prepend "$PNPM_HOME"

# Go
export GOPATH="${GOPATH:-$HOME/go}"
path_append "$GOPATH/bin"
path_append "/usr/local/go/bin"

export PATH
