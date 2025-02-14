# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mstearn/.zshrc'

fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit
# End of lines added by compinstall

#fix delete key
#bindkey    "^[[3~"          delete-char
#bindkey    "^[3;5~"         delete-char
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# bind special keys according to readline configuration
eval "$(sed -n 's/^\( *[^#][^:]*\):/bindkey \1/p' /etc/inputrc)"

setopt always_to_end
setopt complete_in_word
setopt glob_complete
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_lex_words
setopt hist_verify
setopt inc_append_history
#setopt share_history # unsure on this
setopt correct_all
setopt no_flow_control
setopt interactive_comments
setopt auto_continue

# case insensitive completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
                  #'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# highlight selected completion
zstyle ':completion:*' menu select

# http://blog.viridian-project.de/2008/07/03/zsh-tip-handling-urls-with-url-quote-magic/
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'

autoload -U promptinit && promptinit
autoload -U colors && colors

if [[ -n "$SSH_CONNECTION" ]]
then
  PROMPT_COLOR="%B$bg[red]"
else
  PROMPT_COLOR="%B$bg[blue]"
fi

ROOT_SYMBOL="%(!:%B$fg[red]ROOT$reset_color%b :)" # a bold red 'ROOT'
VIRTENV_SYMBOL='%B$fg[yellow]$(basename "$VIRTUAL_ENV")$reset_color%b '
STATUS_SYMBOL="%B%(?.$fg[green]:).$fg[red]:( %?)$reset_color%b"

setopt prompt_subst
PROMPT="
${PROMPT_COLOR}[%U%M%u]%~ %T$reset_color%b ${ROOT_SYMBOL}${VIRTENV_SYMBOL}${STATUS_SYMBOL}
%!> "

export VIRTUAL_ENV_DISABLE_PROMPT=1

export PATH="$HOME/bin:$HOME/bin/mongo_versions:$HOME/.cargo/bin:$HOME/.nimble/bin:$HOME/.local/bin:/snap/node/current/bin:/usr/local/bin:$PATH"
export EDITOR=nvim
export BROWSER=wslview
export BAT_PAGER="less -iRM -j5"

export LESS='-iRM -j5 -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

_CORES=$(grep -c processor /proc/cpuinfo )
_COMPILE_THREADS=$(($_CORES * 3 / 2))

#export SCONSFLAGS="-j$_COMPILE_THREADS"
export NINJA_STATUS='[%f/%t (%p) %es] '

export REALM_DISABLE_ANALYTICS=1

export HISTCONTROL=ignoreboth

#export GOBIN=~/bin
#export GOPATH=~/go_path

eval `dircolors -b`

alias ls="ls -F --color"
alias ll="ls -lh"
alias d="cd -"
alias svn="colorsvn"
alias grep="grep --color"
alias sudo="sudo -E"
alias pacman="sudo pacman"
alias yaourt='PATH=${PATH#/home/*/bin:} yaourt'
alias yay='PATH=${PATH#/home/*/bin:} yay'
alias modprobe="sudo modprobe"
alias ifconfig="sudo ifconfig"
alias iwconfig="sudo iwconfig"
alias batstat="cat /proc/acpi/battery/BAT[01]/state"
#alias hg="history |grep "
alias gentags="ctags --extras=+qf --fields=+iasnfSKtm --c++-kinds=+p --sort=foldcase"
alias grep="grep -n --color"
#alias vimdiff="vimdiff --noplugin"
alias vamplayer="mplayer -vo vaapi -va vaapi "

alias sr='ssh -l root'
alias resmoke="python3 buildscripts/resmoke.py"
#alias scons="nice scons"
alias ninja="nice -n 1 ninja"

alias cr='python2 ~/10gen/kernel-tools/codereview/upload.py -y '
alias cru='cr -e mathias@10gen.com --jira_user redbeard0531 '

alias vim=nvim

if which fzf > /dev/null; then
    source <(fzf --zsh)
fi

# _FZF_PATH=/opt/homebrew/opt/fzf/shell
# /usr/share/fzf
# if [ -d $_FZF_PATH -a -z "$VIM_SERVER" ]; then
#     for file in $_FZF_PATH/*.zsh; do
#         source $file
#     done
# fi

# opam configuration
test -r /home/mstearn/.opam/opam-init/init.zsh && . /home/mstearn/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVIM_GTK_PREFER_DARK_THEME=1
export NVIM_GTK_NO_HEADERBAR=1

if [ "$TERM" = "xterm-kitty" ]; then
    kitty + complete setup zsh | source /dev/stdin
    alias ssh="kitten ssh"
fi

alias activate="source python3-venv/bin/activate"
