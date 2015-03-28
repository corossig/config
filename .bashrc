#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

None='\[$(tput sgr0)\]'
Red='\[$(tput bold ; tput setaf 1)\]'
Green='\[$(tput bold ; tput setaf 2)\]'
Yellow='\[$(tput bold ; tput setaf 3)\]'
Blue='\[$(tput bold ; tput setaf 4)\]'
BlueCyan='\[$(tput bold ; tput setaf 6)\]'


export PS1="${Yellow}\u${None}@${Green}\w$ ${None}"
export PS2="Finit d'ecrire au lieu de revasser: "

source /home/corossig/.shellrc

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
    devel*)
        HOST_COLOR="${REVERSE}${GREEN}"
        ;;
    *)
        HOST_COLOR="${REVERSE}${CYAN}"
        ;;
esac

PS1="${HOST_COLOR} \u@`hostname` ${NORMAL} -> ${BOLD}${GREEN}\w${NORMAL}
> "
