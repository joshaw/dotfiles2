# Created:  Tue 15 Oct 2013
# Modified: Thu 10 Mar 2016
# Author:   Josh Wainwright
# Filename: git.zsh
#

# Return if requirements are not found.
if ! exists git; then
  return 1
fi

#
# Aliases
#

# Commit (c)
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'

# GUI (u)
alias gu='git gui'
alias gitgui-local='/cygdrive/c/progs/Git/cmd/git-gui.exe'
alias gu='gitgui-local'
alias gitk-local='/cygdrive/c/progs/Git/cmd/gitk.cmd'
alias gitk='gitk-local'

# Log (l)
_git_log_oneline_format='%C(yellow)%h%C(reset) %C(green) %ad %C(reset) %s %C(white)- %an%C(reset)%C(yellow)%d%C(reset)'
alias gl='git log --topo-order --pretty=format:${_git_log_medium_format}'
alias gll='git log --graph --abbrev-commit --date=relative --format=format:"${_git_log_oneline_format}" --all'
alias glc='git shortlog --summary --numbered'
alias glh='git log --branches --not --remotes --date=relative --pretty=format:"${_git_log_oneline_format}"'
alias glp='git log --oneline --graph ORIG_HEAD..'

alias gws='git status --ignore-submodules --short'
alias gwd='git diff --no-ext-diff'
alias gwD='git diff --no-ext-diff --word-diff'
