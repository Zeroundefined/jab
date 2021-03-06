#! /bin/bash

cat > ~/.profile << EOB
# ~/.profile: executed by the command interpreter for login shells.

[[ \$- != *i* ]] && return
Welcome_to $BASH_SOURCE
[[ -n "\$BASH_VERSION" ]] && source ~/.bashrc
[[ -n $WELCOME_BYE ]] && echo Bye from $(basename_ $BASH_SOURCE) in $(dirname_ $(readlink -f $BASH_SOURCE)) on $(hostname -f)
echo Bye from /home/jab/.profile
EOB

cat > ~/.bashrc << EOB
# ~/.bashrc: executed by bash(1) for non-login shells.

Welcome_to $BASH_SOURCE
if [[ \$- == *i* ]]; then
    [[ -f ~/bash/bashrc ]] && . ~/bash/bashrc >/dev/null 2>&1
fi
[[ -n $WELCOME_BYE ]] && echo Bye from $(basename_ $BASH_SOURCE) in $(dirname_ $(readlink -f $BASH_SOURCE)) on $(hostname -f)
echo Bye from /home/jab/.bashrc
EOB

echo "# ~/.bash_logout: executed by bash(1) when login shell exits" > ~/.bash_logout
