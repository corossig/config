# completion
autoload -U compinit
compinit

setopt correctall
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.zsh_history"
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt autocd
setopt nohup
setopt PRINT_EXIT_VALUE
unsetopt CHASE_LINKS

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

BACK_BLACK=$(tput setab 0)
BACK_RED=$(tput setab 1)
BACK_GREEN=$(tput setab 2)
BACK_YELLOW=$(tput setab 3)
BACK_BLUE=$(tput setab 4)
BACK_MAGENTA=$(tput setab 5)
BACK_CYAN=$(tput setab 6)
BACK_WHITE=$(tput setab 7)

NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
BOLD=$(tput bold)
UNDERLINE=$(tput smul)

case `hostname` in
    rikku*)
        HOST_COLOR="${REVERSE}${YELLOW}"
        ;;
    lulu*)
        HOST_COLOR="${REVERSE}${MAGENTA}"
        ;;
    pandev*|rostand*)
        export FPATH=/usr/share/zsh/site-functions:/usr/share/zsh/4.3.6/functions
        HOST_COLOR="${REVERSE}${YELLOW}"
        export HISTFILE="$HOME/.zsh_rostand_history"
        ;;
    devel*)
        HOST_COLOR="${REVERSE}${GREEN}"
        ;;
    *)
        HOST_COLOR="${REVERSE}${CYAN}"
        ;;
esac

# completion
autoload -U compinit
compinit

PS1="${HOST_COLOR} %n@`hostname` ${NORMAL} -> ${BOLD}${GREEN}%~${NORMAL}
$ "

source ${HOME}/.shellrc

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

set completion-query-items 100
set completion-ignore-case on
set show-all-if-ambiguous off

set input-meta on
set output-meta on
set convert-meta off
set bell-style none

bindkey '\e[1~' beginning-of-line
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey '\177' backward-delete-char
bindkey '\e[2~' overwrite-mode

bindkey "\e[7~" beginning-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

bindkey "^R" history-incremental-search-backward
ulimit -c 0

[ -f ~/.software/module/init/zsh ] && source ~/.software/module/init/zsh
