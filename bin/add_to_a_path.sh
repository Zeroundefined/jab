#! /bin/bash
#
# Based on a file found at https://github.com/jalanb/jab.sh/blob/master/add_to_a_path.sh
# See also ./add_to_path.py and ./add_to_path.test
#

if [[ $0 == $BASH_SOURCE ]]
then
    echo "This file should be run as"
    echo "  source $0"
    echo "and should not be run as"
    echo "  sh $0"
fi
#
# Gonna need python
#
find_python ()
{
    [[ -n $PYTHON ]] && return
    PYTHON=$(which python 2>/dev/null)
    [[ -n $PYTHON ]] && return
    if [[ -f /usr/local/bin/python ]]
    then PYTHON=/usr/local/bin/python
    elif [[ -f /usr/bin/python ]]
    then PYTHON=/usr/bin/python
    fi
}

#
# Once sourced there is one major command:
#
add_to_a_path ()
{
    find_python
    if [[ -z $1 ]]
    then
        echo "Usage: add_to_a_path <SYMBOL> <new_path>"
        echo "  e.g. add_to_a_path PYTHONPATH /dev/null"
    else
        eval $1=$(python $JAB_PYTHON/add_to_a_path.py "$@")
        export $1
    fi
}

show_value ()
{
    local name=${1-SHELL}
    local value=${!name}
    if [[ -z "$value" ]]
    then echo \$$name is not set
    else
        local where=${2-bash}
        printf "$where has set \$$name to\n\t$value\n"
    fi
}

show_a_path ()
{
    local name=${1-PATH}
    local value=${!name}
    local where=${2-bash}
    printf "$where has set \$$name to\n\t${value//:/\n\t}\n"
}

show_path ()
{
    show_a_path PATH $*
}

show_ppath ()
{
    show_a_path PYTHONPATH $*
}

debug_show_a_path ()
{
    if [[ $DEBUG_PATHS == "yes" ]]
    then
        show_a_path $*
    fi
}
debug_show_path ()
{
    debug_show_a_path PATH $*
}
debug_show_ppath ()
{
    debug_show_a_path PYTHONPATH $*
}
