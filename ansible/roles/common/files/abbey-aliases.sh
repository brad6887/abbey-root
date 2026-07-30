# Abbey Root shell aliases

# Project directories
alias cda='cd ~/git/abbey-root'
alias cdb='cd ~/git/bread-pitt'
alias abbey-site='cd ~/git/abbey-root/site'
alias abbey-content='cd ~/git/abbey-root/content'
alias abbey-pages='cd ~/git/abbey-root/content/pages'
alias abbey-docdir='cd ~/git/abbey-root/docs'
alias abbey-scripts='cd ~/git/abbey-root/scripts'

# Astro / site helpers
alias abuild='cd ~/git/abbey-root/site && npm run build'
alias adev='cd ~/git/abbey-root/site && npm run dev'

# Git helpers
alias gs='git status'
alias ga='git add -A'
alias gp='git push'
alias gl='git pull --ff-only'
alias gll='git log --oneline --graph --decorate -20'

# Safer git commit helper:
# usage: gcm "commit message"
gcm() {
  git commit -m "$*"
}
