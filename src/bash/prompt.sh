#! /bin/cat -n


export PROMPT_COLOUR=none
if [[ "$1" == "green" ]]; then
    export PROMPT_COLOUR="$PROMPT_GREEN"
    export PROMPT_OPPOSITE_COLOUR="$PROMPT_MAGENTA"
elif [[ "$1" == "red" ]]; then
    export PROMPT_COLOUR="$PROMPT_RED"
    export PROMPT_OPPOSITE_COLOUR="$PROMPT_CYAN"
elif [[ "$1" == "blue" ]]; then
    export PROMPT_COLOUR="$PROMPT_LIGHT_BLUE"
    export PROMPT_OPPOSITE_COLOUR="$PROMPT_YELLOW"
else
    export PROMPT_COLOUR="$PROMPT_GREEN"
    export PROMPT_OPPOSITE_COLOUR="$PROMPT_MAGENTA"
fi

changes=0

get_repo_status () {
    PYTHON=${PYTHON:-mython}
    GIT_BRANCH=
    if git branch > /dev/null 2>&1; then
        if git status >/dev/null 2>&1; then
            local branch=$(git rev-parse --abbrev-ref HEAD)
            local modified=$(git status --porcelain | wc -l | tr -d ' ')
            local remote="$(\git config --get branch.${branch}.remote 2>/dev/null)"
            local remote_branch="$(\git config --get branch.${branch}.merge)"
            local pushes=$(git rev-list --count ${remote_branch/refs\/heads/refs\/remotes\/$remote}..HEAD)
            [[ -z $pushes ]] && pushes=0
            local pulls=$(git rev-list --count HEAD..${remote_branch/refs\/heads/refs\/remotes\/$remote})
            [[ -z $pulls ]] && pulls=0
            if [[ $modified == 0 && $pushes == 0 && $pulls == 0 ]]; then
                GIT_BRANCH=" (${branch})"
            else
                if [[ $pulls == 0 ]]; then
                    if [[ $pushes == 0 ]]; then
                        GIT_BRANCH=" ${PROMPT_OPPOSITE_COLOUR}(${branch} $modified)${PROMPT_COLOUR}"
                    else
                        GIT_BRANCH=" ${PROMPT_OPPOSITE_COLOUR}(${branch} $modified.$pushes)${PROMPT_COLOUR}"
                    fi
                else
                    GIT_BRANCH=" ${PROMPT_OPPOSITE_COLOUR}(${branch} $modified.$pushes.$pulls)${PROMPT_COLOUR}"
                fi
            fi
            return 2
        fi
    fi
}

prompt_command () {
    if [[ -z "$1" ]]; then
        how_do_you_do_nothing_in_a_bash_script=0
    elif [[ $1 == 0 ]]; then
        export STATUS="${PROMPT_GREEN}$1${PROMPT_NO_COLOUR}"
    else
        export STATUS="${PROMPT_RED}$1${PROMPT_NO_COLOUR}"
    fi
    changes=0
    local endir="$(mython $JAB/bin/endiron -x OLDPWD PWD JAB_SSH -- "${PWD}")"
    local Dir="${endir/\$/\\$}"
    [[ $? == 2 ]] && Dir="${PROMPT_OPPOSITE_COLOUR}${endir/\$/\\$}${PROMPT_COLOUR}"
    local endir="$PWD"
    [[ -n $IGNORE_CHANGES ]] || get_repo_status
    Dir="${Dir}${GIT_BRANCH}"
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    console_whoami 
    export PS1="$STATUS ${PROMPT_COLOUR}[\D{%A %Y-%m-%d.%T} $python_version \u@${HOSTNAME:-$(hostname -s)}:$Dir]${PROMPT_NO_COLOUR}\n$ "
    what -q kd && kd --add . >/dev/null 2>&1
    history -a
    local python_version=$($PYTHON --version 2>&1 | cut -d' ' -f2)
    [[ -n "$VIRTUAL_ENV" ]] && python_version=${python_version}.$(basename $VIRTUAL_ENV)
    export PS1="$STATUS ${PROMPT_COLOUR}\
[\D{%A %Y-%m-%d.%T} $python_version \u@${HOSTNAME:-$(hostname -s)}:$Dir]\
        ${PROMPT_NO_COLOUR}\n$ "
}

sp () {
    source $JAB/src/bash/prompt.sh
}

vp () {
    _edit_jab src/bash/prompt.sh "$@"
}

if [[ -n "$MYVIMRC" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
    export PROMPT_COMMAND='prompt_command $?'
elif [[ "$PROMPT_COLOUR" == "none" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
else
    export PROMPT_COMMAND='prompt_command $?'
fi