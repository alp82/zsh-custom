#
# 
# System options
# -------------- 


zmodload zsh/mathfunc


# General aliases, functions and options

alias l=ll

setopt interactivecomments # pound sign in interactive prompt
setopt extendedglob # superglobs
unsetopt caseglob   # -

# default editor
DEFAULT_EDITOR="nano"
export SUDO_EDIT=$DEFAULT_EDITOR
export VISUAL=$DEFAULT_EDITOR
export EDITOR=$DEFAULT_EDITOR


# General environment variables

export M2_HOME=/opt/maven
export VST_PATH=/media/Studio/VST


# History

HISTSIZE=1000000
SAVEHIST=1000000
HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
setopt INC_APPEND_HISTORY
#setopt SHAREHISTORY
setopt EXTENDEDHISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY


# Key mapping

typeset -A key
key[Insert]=${terminfo[kich1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"    overwrite-mode
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward


# Completion

zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey "^F" complete-files

# Fuzzy Search
. /etc/profile.d/fzf.zsh

fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}


# Title bar
# http://blog.bstpierre.org/zsh-prompt
# http://tldp.org/HOWTO/Xterm-Title-4.html

function title_del() {
    # escape '%' chars in $1, make nonprintables visible
    local a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")
    case $TERM in
        screen*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            print -Pn "\ek$a\e\\"      # screen title (in ^A")
            print -Pn "\e_$2   \e\\"   # screen location
            ;;
        *term*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    #title "zsh" "%55<...<%~"
    print -Pn "\e]0;%~\a"
}

# preexec is called just before any command line is executed
function preexec() {
    #title "$1" "%35<...<%~"
    print -Pn "\e]0;$1\a"
}

#precmd() { print -Pn "\e]0;%m:%~\a" }
#preexec () { print -Pn "\e]0;$1\a" }


# 
# Advanced options
# ----------------

REPORTTIME=-10 # Say how long a command took, if it took more than x seconds

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Watch other user login/out
watch=notme
LOGCHECK=60


# Syntax highlighting

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)

# none, fg=, bg=
# red,green,blue,... bold,standout,underline

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
ZSH_HIGHLIGHT_STYLES[alias]=none
ZSH_HIGHLIGHT_STYLES[builtin]=none
ZSH_HIGHLIGHT_STYLES[function]=none
ZSH_HIGHLIGHT_STYLES[command]=none
ZSH_HIGHLIGHT_STYLES[precommand]=none
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=grey
ZSH_HIGHLIGHT_STYLES[hashed-command]=none
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=yellow
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[assign]=fg=blue

ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=cyan
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=yellow
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=blue
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=green
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=magenta
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=bold

ZSH_HIGHLIGHT_PATTERNS+=('rm -r*' 'fg=white,bold,bg=red')

ZSH_HIGHLIGHT_STYLES[cursor]=bg=blue


# 
# Custom functions
# ----------------

function fg_colors {
	for COLOR in $(seq 0 255) 
	do
		for STYLE in "38;5"
		do 
		    TAG="\033[${STYLE};${COLOR}m"
		    STR="${STYLE};${COLOR}"
		    echo -ne "${TAG}${STR}${NONE}  "
		done
		echo
	done
}

function bg_colors {
	for COLOR in $(seq 0 255) 
	do
		for STYLE in "48;5"
		do 
		    TAG="\033[${STYLE};${COLOR}m"
		    STR="${STYLE};${COLOR}"
		    echo -ne "${TAG}${STR}${NONE}  "
		done
		echo
	done
}

# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}

# Screensaver matrix
#TMOUT=60*60*1
#TRAPALRM() {
#    cmatrix -bs -u 4
#}



# 
# Development
# -----------


# tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator


# Python

activate() {
  if [[ -f ./$1/bin/activate  ]]; then
    export VIRTUAL_ENV_DISABLE_PROMPT='1'
    source ./$1/bin/activate
  else
    echo "no ./$1/bin/activate found"
  fi
}


# AAS

function aas {
  source /home/alp/projekte/aas/aas-env/bin/activate
  cd /home/alp/projekte/aas/aas
}


# Squiek

export SQUIEK_PROJECT=/home/alp/squiek/code/squiek
export SQUIEK_ENV=/home/alp/squiek/env/squiek-env
export SQUIEK_DEPLOY=/home/alp/squiek/code/squiek-deploy

function sq {
  cd $SQUIEK_PROJECT
}

function sqe {
  source $SQUIEK_ENV/bin/activate
  sq
}

# 
# MISC
# -----------

export PATH=$PATH:/home/alp/.gem/ruby/2.1.0/bin:/home/alp/bin:/home/alp/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/kde/bin:/usr/bin/core_perl
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
alias pac=pacaur
