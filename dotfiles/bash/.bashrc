#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors-tty.sh
fastfetch

alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'
alias v='nvim'
PS1='[\u@\h \W]\$ '
