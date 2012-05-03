#!/bin/bash
# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Source global definitions
[ -r /etc/bashrc ] && . /etc/bashrc
[ -r /etc/bash.bashrc ] && . /etc/bash.bashrc
[ -r /etc/profile ] && . /etc/profile

# User specific aliases and functions go here (override system defaults)
export PATH="/home/mstearn/bin:/usr/local/bin:/usr/lib/colorgcc/bin/:$PATH"

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

function _showStatus {
    local _last=$?
    if `return $_last`;  then
        echo -e '\e[1;32m:)\e[0m' # green smile
    else
        echo -e '\e[1;31m:(\e[0m' # red frown
    fi
    return $_last
}

if [ -n "$SSH_CONNECTION" ]
then
  PROMPT_COLOR="\e[37;1;41m"
else
  PROMPT_COLOR="\e[37;1;44m"
fi

if [ "$USER" == "root" ]
then
  ROOT_SYMBOL="\e[1;31mROOT\e[0m" # a bold red 'ROOT'
else
  ROOT_SYMBOL=""
fi

PS1="\n${PROMPT_COLOR}[\h]\w \@\e[0m ${ROOT_SYMBOL} \`_showStatus\`\n$ "

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
_COMPILE_THREADS=$(echo $_CORES '* 3 / 2' | bc)

export SCONSFLAGS="-j$_COMPILE_THREADS"

export HISTCONTROL=ignoreboth

export GOBIN=~/bin
export GOPATH=~/go_path

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
alias batstat="cat /proc/acpi/battery/BAT[01]/state"
#alias hg="history |grep "
alias ls="ls --color"
alias gentags="ctags --extra=+qf --fields=+iasnfSKtm --c++-kinds=+p --sort=foldcase"
alias grep="grep -n --color"
alias vimdiff="vimdiff --noplugin"
alias vamplayer="mplayer -vo vaapi -va vaapi "

alias sr='ssh -l root'
alias smoke="python2 buildscripts/smoke.py"
alias rebuildPCH="clang++ -x c++-header ~/pch.h -o ~/pch.h.pch -DMONGO_EXPOSE_MACROS"
alias scons="nice scons"


alias cr='python ~/10gen/scratch/tools/upload.py -y -s codereview.10gen.com'
alias cru='cr -e mathias@10gen.com --jira_user redbeard0531'

cruc () {
    local REV="$1"
    shift

    if [ -z "$REV" ]; then
        REV="HEAD"
    fi

    local REV_SELECTOR="${REV}~..${REV}"
    local SUBJ=$(git log "$REV_SELECTOR" --pretty=format:"%s")
    local BODY=$(git log "$REV_SELECTOR" --pretty=format:"%b")

    cru --rev "${REV}~:$REV" \
        -m "$SUBJ" \
        --description "$BODY" \
        "$@"
}
