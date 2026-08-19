# Run claude with the current directory's .env loaded, without exporting it
# into the interactive shell.
claude() {
  SHELL=/bin/bash bash -c '[[ -f .env ]] && source .env; exec claude "$@"' _ "$@"
}

# mkdir + cd
mkcd() { mkdir -p "$1" && builtin cd "$1"; }
