# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# Use vim-editing in the command-line
set -o vi
export EDITOR='vim'
export VISUAL='vim'

# Use 'jj' to exit insert-mode in command-line
bind -m vi-insert '"jj": vi-movement-mode'

# Prevent acciental overwrite with ">" (override with ">|")
set -o noclobber


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Combine multiline commands into one in history
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# add timestamp to history
HISTTIMEFORMAT="%F %H:%M "


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Make 'less' display ansi-colors
alias less='less -R'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -Aplthr'
alias l='ls -NApt'
alias python='python3'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Enable 256 colour terminal in  tmux
alias tmux='tmux -2'

# moving
alias ~="cd ~;pwd"
alias ..="cd ..;pwd"
alias ...="cd ../..;pwd"
alias ....="cd ../../..;pwd"
alias .....="cd ../../../..;pwd"

# misc aliases
alias df='df -h'
alias du='du -h'
alias df='df -h'
alias python3-pep8='python3 -m flake8 '
alias diskspace="du -S | sort -n -r |more"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn" # size (sorted) of only the folders in this directory
alias c='clear'
alias h='history'
alias hgrep='history | grep'
alias p='ps aux'
alias pgrep='ps aux | grep'
alias mkdir='mkdir -pv'
alias tree='tree --dirsfirst -F'
alias date='date +"%a %b %d %H:%M"'
alias jan='cal -m 01'
alias feb='cal -m 02'
alias mar='cal -m 03'
alias apr='cal -m 04'
alias may='cal -m 05'
alias jun='cal -m 06'
alias jul='cal -m 07'
alias aug='cal -m 08'
alias sep='cal -m 09'
alias oct='cal -m 10'
alias nov='cal -m 11'
alias dec='cal -m 12'

# More alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

# shows last installed packages from history
apt-history(){
    zcat -qf /var/log/apt/history.log* | grep --color=never -Po '^Commandline: apt install (?!.*--reinstall)\K.*'
}

# print the type of arg1, e.g. function, builtin, alias, executable
# if exectuable, give `ls` info about the arg [& symlink location]
which2(){ 
    if [ "$#" -ne 1 ]; then
	echo 'Usage:> which2 <cmd_name>'
	return 1
    fi

    local var1                                   # alias 
    local var2=false                             # executable/exists
    local var3=$(type -t "$1" 2>/dev/null)       # bash func

    # check for function/builtin
    if [ "$var3" = 'function' ] || [ "$var3" = 'builtin' ]; then
	printf "$1 is a bash $var3\n" # print type info
	var2=true                     # it's at LEAST a funciton/builtin
    fi
    var3="$1" # now set as arg1

    # check for alias
    var1=$(alias "$1" 2>/dev/null)    # alias 
    if [ "$?" -eq 0 ]; then
	printf "$var1\n"              # print the alias
	var2=true                     # it's at LEAST an alias
	var3="${var1#*=}"             # get alias'd command
	var3="${var3:1:-1}"           # remove quotes
	var3="${var3%%' '*}"          # remove any args
    fi

    # Check for executable
    var1=$(which "$var3" 2>/dev/null) # checking arg1 or alias cmd
    if [ -n "$var1" ]; then
	var3=$(readlink -f "$var1")   # check for symlinks
	if [ "$var3" = "$var1" ]; then
	    ls --color=always -lh "$var1" |cut -f 4- -d ' '
	else
	    var1="$(ls --color=always -lh $var1 $var3 |cut -f 4- -d' ')"
	    printf "LINK: ${var1/$'\n'/$'\nSRC : '}\n"
	fi
    elif ! $var2; then
       return 1                       # no command found
    fi
}

# Update system
update(){
	sudo apt update && sudo apt upgrade -y
}

# Convert comma separated list to long format e.g. id user | tr "," "\n"
# See also n2c() and n2s() for the opposite behaviour
c2n() {
    while read -r; do 
        printf -- '%s\n' "${REPLY}" | tr "," "\\n"
    done < "${1:-/dev/stdin}"
}

# Convert multiple lines to comma separated format
# See also c2n() for the opposite behaviour
n2c() { paste -sd ',' "${1:--}"; }

# Convert multiple lines to space separated format
n2s() { paste -sd ' ' "${1:--}"; }

# Print string letter-by-letter
slowprint() {
	string="$@"
	for i in $(seq 0 $((${#string} - 1))); do
		echo -n "${string:i:1}"
		sleep .001
	done
	echo
}

# Print system information
fancysysinfo(){
	clear

    echo 
	slowprint $(echo -e "   \e[1;93mDate\e[0m: \t\t\t$(date)")
    slowprint $(echo -e "   \e[1;93mUser\e[0m: \t\t\t$(echo $USER)")
    slowprint $(echo -e "   \e[1;93mHostname\e[0m: \t\t\t$(hostname -f)")
    slowprint $(echo -e "   \e[1;93mIP Address (public)\e[0m: \t$(curl -s ifconfig.me)")
    slowprint $(echo -e "   \e[1;93mIP Address (local)\e[0m: \t\t$(ifconfig | grep --color=never -oE "inet 192\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sed 's/inet //' | n2s)")
	slowprint $(echo -e "   \e[1;93mUptime\e[0m: \t\t\t$(uptime -p)")
	slowprint $(echo -e "   \e[1;93mCPU Use\e[0m: \t\t\t$(top -bn 1 | awk '/%Cpu/ { cpu = "" 100 - $8 "%" } END { print cpu }')")
	slowprint $(echo -e "   \e[1;93mMemory\e[0m: \t\t\t$(free -h | awk '/Mem/ {print $3 "/" $2}')") 
	slowprint $(echo -e "   \e[1;93mDisk Use\e[0m: \t\t\t$(df -h | awk '/\/$/ {print $5}')")
    slowprint $(echo -e "   \e[1;93mCPU\e[0m: \t\t\t$(lscpu | sed -nE 's/Model name: *//p')")
    slowprint $(echo -e "   \e[1;93mKernel\e[0m: \t\t\t$(uname -rms)")
    slowprint $(echo -e "   \e[1;93mPackages\e[0m: \t\t\t$(dpkg --get-selections | wc -l)")
    slowprint $(echo -e "   \e[1;93mResolution\e[0m: \t\t\t$(xrandr | awk '/\*/{printf $1" "}')")
    echo
}

sysinfo(){
	clear

    echo 
    echo -e "   \e[1;93mDate\e[0m: \t\t\t$(date)"
    echo -e "   \e[1;93mUser\e[0m: \t\t\t$(echo $USER)"
    echo -e "   \e[1;93mHostname\e[0m: \t\t\t$(hostname -f)"
    echo -e "   \e[1;93mIP Address (public)\e[0m: \t$(curl -s ifconfig.me)"
    echo -e "   \e[1;93mIP Address (local)\e[0m: \t\t$(ifconfig | grep --color=never -oE "inet 192\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sed 's/inet //' | n2s)"
	echo -e "   \e[1;93mUptime\e[0m: \t\t\t$(uptime -p)"
	echo -e "   \e[1;93mCPU Use\e[0m: \t\t\t$(top -bn 1 | awk '/%Cpu/ { cpu = "" 100 - $8 "%" } END { print cpu }')"
	echo -e "   \e[1;93mMemory\e[0m: \t\t\t$(free -h | awk '/Mem/ {print $3 "/" $2}')" 
	echo -e "   \e[1;93mDisk Use\e[0m: \t\t\t$(df -h | awk '/\/$/ {print $5}')"
    echo -e "   \e[1;93mCPU\e[0m: \t\t\t$(lscpu | sed -nE 's/Model name: *//p')"
    echo -e "   \e[1;93mKernel\e[0m: \t\t\t$(uname -rms)"
    echo -e "   \e[1;93mPackages\e[0m: \t\t\t$(dpkg --get-selections | wc -l)"
    echo -e "   \e[1;93mResolution\e[0m: \t\t\t$(xrandr | awk '/\*/{printf $1" "}')"
    echo
}

# Grep colors
export GREP_COLORS='ms=31:mc=31:sl=:cx=:fn=33:ln=32:bn=32:se=36'

# Command prompt
export PS1="\[\033[0;37m\][\D{%a %Y-%m-%d} \A]\[\033[00m\] \[\033[0;33m\][\[\033[0;93m\]\u\[\033[0;33m\]@\[\033[0;93m\]\h\[\033[0;33m\]:\w]\[\033[00m\] \[\033[0;37m\][\!]\[\033[0;00m\] \$ "

if [ "$SSH_CONNECTION" ]; then
	export PS1="\[\033[0;33m\][SSH]\[\033[0;00m\] ${PS1}"
fi

export PATH="/usr/local/cuda-10.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:"

# This is where you put your hand rolled scripts (remember to chmod them)
export PATH="$HOME/bin:$PATH"

# Created by `pipx` on 2025-09-16 17:09:39
export PATH="$PATH:~/.local/bin"

# fancysysinfo
neofetch --ascii_distro CentOS | lolcat

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
