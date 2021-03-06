# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ (\1)/'"

reset=`tput sgr0`
bold=`tput bold`
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
user_color=$green
[ "$UID" -eq 0 ] && { user_color=$red; }

color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}[\[$reset\]\[$bold$user_color\]\u\[$reset$bold\]@\[$red\]\h\[$reset$bold\]:\[$blue\]\W\[$reset\]\[$bold$cyan\]$(__git_ps1)\[$reset\]]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}[\u@\h:\W\[\033[1;36m\]$(__git_ps1)\[\033[0m\]]$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
os=`uname`

if [ $os = "Darwin" ];
then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


alias grep='grep --color=auto --exclude=*.svn --exclude *.git'
alias g='grep'
alias gi='grep -i'
alias gr='grep -R'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias s='source ~/.bashrc'
alias hexdump='hexdump -C'

if [ $os = "Darwin" ];
then
    XC_PATH=`xcode-select -p`
    IOS_SDK="$XC_PATH/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
    OSX_SDK="$XC_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk"
    XC_DATA="$HOME/Library/Developer/Xcode/DerivedData"
    alias isdk='xcrun --sdk iphoneos --show-sdk-path'
    alias msdk='xcrun --sdk macosx --show-sdk-path'
fi

pushd()
{
    if [ $# -eq 0 ] ;
    then
        DIR="${HOME}"
    else
        DIR="$1"
    fi

    builtin pushd "${DIR}" > /dev/null
}

pushd_builtin()
{
    builtin pushd > /dev/null
}

popd() 
{
    builtin popd > /dev/null
}

if [ $UID -ne 0 ] ; 
then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
fi

alias cd='pushd'
alias b='popd'
alias flip='pushd_builtin'
alias 2='python2'
alias 3='python3'
alias py='ipython3'

LOCAL_ROOT="$HOME/root"
LOCAL_BIN="$LOCAL_ROOT/bin"

NDK="$LOCAL_BIN/android-ndk-r10e"
if [ $os = "Darwin" ];
then
    AVR="/Applications/Arduino.app/Contents/Java/hardware/tools/avr"
else
    AVR="/usr/lib/avr"
fi
AVR_BIN="$AVR/bin"
AVR_LIB="$AVR/avr/lib"
AVR_INC="$AVR/avr/include"
ANDROID_SDK_PATH="$LOCAL_BIN/Android/SDK"
ANDROID_NDK_PATH="$LOCAL_BIN/Android/NDK"
ANDROID_NDK_BIN="$ANDROID_NDK_PATH"
ANDROID_X86_64_BIN="$ANDROID_NDK_PATH/toolchains/x86_64-4.9/prebuilt/linux-x86_64/bin"
ANDROID_ARM_BIN="$ANDROID_NDK_PATH/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin"
ANDROID_AARCH64_BIN="$ANDROID_NDK_PATH/toolchains/aarch64-linux-androideabi-4.9/prebuilt/linux-x86_64/bin"
ANDROID_BUILD_TOOLS="$ANDROID_SDK_PATH/build-tools/23.0.3"
ANDROID_PLATFORM_TOOLS="$ANDROID_SDK_PATH/platform-tools"
ANDROID_TOOLS="$ANDROID_SDK_PATH/tools"
ANDROID_BIN="$ANDROID_BUILD_TOOLS:$ANDROID_PLATFORM_TOOLS:$ANDROID_TOOLS:$ANDROID_NDK_BIN:$ANDROID_AARCH64_BIN:$ANDROID_ARM_BIN:$ANDROID_X86_64_BIN"
PATH="$LOCAL_BIN:$PATH:$AVR_BIN:$ANDROID_BIN"


git_completion=/usr/local/git/contrib/completion

if [ -e $git_completion ];
then
	source /usr/local/git/contrib/completion/git-completion.bash
	source /usr/local/git/contrib/completion/git-prompt.sh
fi
