#!/bin/bash
# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions go here (override system defaults)
export PATH="/home/mstearn/bin:$PATH"

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

export EDITOR=vim
alias ls="ls -F --color"
alias ll="ls -lh"
alias d="cd -"
alias svn="colorsvn"
alias grep="grep --color"

#export LESS='-iRM -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

#export PAGER="most -s"
#export BROWSER="most -s"

# Adds a blank line between commands, puts command entry on its own line, and adds color

if [ -n "$SSH_CONNECTION" ]
then
  PROMPT_COLOR="\e[37;1;41m"
else
  PROMPT_COLOR="\e[37;1;44m"
fi
PS1="\n$PROMPT_COLOR[\h]\w \d, \@\e[0m \n$ "

#
#  where:
#    \n           start with a blank line
#    \e[37;1;     white text (37), bold (1) characters
#    44m          blue (44) background with terminator (m)
#    [\h]         host name displayed in square brackets
#    \w           print working directory
#    \e[0m        default colors for command line itself
#    \n           start a new line for following prompt
#    $            dollar sign followed by a space separator character


# Put your fun stuff here.

#source /etc/profile.d/bash-completion

_CORES=$(grep -c processor /proc/cpuinfo )
_COMPILE_THREADS=$(echo $CORES '* 3 / 2' | bc)

export SCONSFLAGS="-j$_COMPILE_THREADS"

alias sudo="sudo -E"
alias emerge="sudo emerge"
alias pacman="sudo pacman"
alias modprobe="sudo modprobe"
alias euse="sudo euse"
alias etc-update="sudo etc-update"
alias rc-update="sudo rc-update"
alias layman="sudo layman"
alias ifconfig="sudo ifconfig"
alias iwconfig="sudo iwconfig"
alias batstat="cat /proc/acpi/battery/BAT0/state"
#alias hg="history |grep "
alias ls="ls --color"
alias gentags="ctags --extra=+qf --fields=+iasnfSKtm --c++-kinds=+p --sort=foldcase"
alias grep="grep -n --color"

. /etc/bash_completion
