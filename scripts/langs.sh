#!/usr/bin/env bash
# Language toolchains. Each step is skipped if the tool is already present,
# so this is safe to re-run.
set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"

# ── Python: uv handles interpreters, venvs and tools ──────────────────────────
if have uv; then info "uv already installed"; else
  info "Installing uv (python toolchain)"
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
uv python install 3.12 || true

# ── Node / TypeScript via nvm, pnpm via corepack ──────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then info "nvm already installed"; else
  info "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default "$(nvm current)"
corepack enable || true
corepack prepare pnpm@latest --activate || true

# ── Bun ───────────────────────────────────────────────────────────────────────
if have bun; then info "bun already installed"; else
  info "Installing bun"
  curl -fsSL https://bun.sh/install | bash
fi

# ── Go (brew keeps it updated; fall back to a note if brew is absent) ─────────
if have go; then info "go already installed ($(go version))"
elif have brew; then info "Installing go"; brew install go
else echo "go: install Homebrew first, or grab it from https://go.dev/dl/" >&2
fi

# ── PlatformIO (embedded), installed as an isolated uv tool ───────────────────
if have pio; then info "platformio already installed"; else
  info "Installing platformio"
  uv tool install platformio
fi
