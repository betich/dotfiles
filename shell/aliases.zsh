# ── Editor ────────────────────────────────────────────────────────────────────
alias c='code'

# ── Git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gb='git branch'
alias gch='git checkout'
alias gl='git log --oneline --decorate --graph --all'
alias gp='git push'
alias gpl='git pull'

# ── Files ─────────────────────────────────────────────────────────────────────
alias ll='ls -lh'
alias la='ls -lha'
alias ..='cd ..'
alias ...='cd ../..'

# ── Node / package managers ───────────────────────────────────────────────────
alias pn='pnpm'
alias nd='npm run dev'
alias nb='npm run build'
alias ns='npm run start'
alias bunx='bun x'

# ── Misc ──────────────────────────────────────────────────────────────────────
alias please='sudo'
alias pls='sudo'
alias clauded='claude --dangerously-skip-permissions'

# Jump back to the real cd when zoxide's guessing gets in the way.
alias cdd='builtin cd'
