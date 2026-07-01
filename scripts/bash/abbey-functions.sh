# Abbey Root shell functions

abbey-status() {
  echo "========================================"
  echo " Abbey Root Status"
  echo "========================================"
  echo
  echo "Repository: ~/git/abbey-root"
  echo

  cd ~/git/abbey-root || return 1

  echo "Git status:"
  git status --short
  echo

  echo "Recent commits:"
  git log --oneline -5
  echo
}

abbey-git-status() {
  cd ~/git/abbey-root || return 1
  git status
}

abbey-git-history() {
  cd ~/git/abbey-root || return 1
  git log --oneline -10
}

abbey-git-sync() {
  cd ~/git/abbey-root || return 1
  git pull
  git status
}
