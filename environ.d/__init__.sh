#! /bin/cat

Welcome_to $BASH_SOURCE

ENVIRON_DIR=~/jab/environ.d
. $ENVIRON_DIR/jab.sh
. $ENVIRON_DIR/environ.sh
. $ENVIRON_DIR/colour.sh
. $ENVIRON_DIR/python.sh
. $ENVIRON_DIR/company.sh 2>/dev/null
. $ENVIRON_DIR/ssh_completion.sh
. $ENVIRON_DIR/travis.sh

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(realdir $BASH_SOURCE) on $(hostname -f)
