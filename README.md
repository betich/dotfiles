# dotfiles

Terminal setup for macOS: zsh, [Starship](https://starship.rs), [Ghostty](https://ghostty.org),
[cmux](https://github.com/manaflow-ai/cmux), and the language toolchains I actually use.

## Install

```bash
git clone git@github.com:betich/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Then `exec zsh`.

Partial installs, all idempotent:

| Command | What it does |
| --- | --- |
| `./install.sh shell` | Symlinks only — no downloads, no Homebrew |
| `./install.sh brew` | Homebrew + everything in the `Brewfile` |
| `./install.sh langs` | Python, Node/TS, Bun, Go, PlatformIO |
| `./install.sh` | All three |

Existing files are moved to `<name>.bak-<timestamp>` before being replaced.

## What's here

```
shell/       zshrc + path / aliases / functions / tools modules
starship/    prompt
ghostty/     terminal
cmux/        multiplexer
git/         gitconfig + global gitignore
scripts/     language toolchain installer
```

### Shell

`~/.zshrc` is a symlink to `shell/zshrc`, which sources four modules in order:

- **path.zsh** — Homebrew shellenv, `~/.local/bin`, Bun, pnpm, Go. Every entry is
  added only if the directory exists, so the same file works on a bare machine.
- **aliases.zsh** — git shorthands, `pn`, `nd`/`nb`/`ns`, `pls`, `clauded`.
- **functions.zsh** — `claude` wrapper that loads the project's `.env`, `mkcd`.
- **tools.zsh** — completions, history, autosuggestions, fzf, Starship, zoxide,
  syntax highlighting (last, so it wraps every widget defined before it).

`cd` is zoxide. `cdd` is the plain builtin when zoxide guesses wrong.

nvm is lazy-loaded: the default Node version goes on `PATH` directly and nvm
itself only sources on first `nvm` call. That takes shell startup from ~600ms
to ~120ms.

### Toolchains

| Language | Manager |
| --- | --- |
| Python | `uv` (interpreters, venvs, tools) |
| JS/TS | `nvm` + `corepack`/`pnpm` |
| Bun | official installer |
| Go | Homebrew |
| PlatformIO | `uv tool install platformio` |

## Machine-specific settings

Nothing private lives in this repo. Three files stay untracked on each machine:

- `~/.zshrc.local` — tokens, work paths, one-off aliases (sourced last)
- `~/.gitconfig.local` — name, email, GPG signing key (see `git/gitconfig.local.example`)
- `~/.config/ghostty/local.conf` — per-machine font size, theme overrides

The installer creates the first two for you.
