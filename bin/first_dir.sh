#! /bin/bash

reuse_path () {
    [[ -n $path && -d "$path" ]] && return 0
    shift_path "$@"
    return $?
}

shift_path () {
    path=$(pwd)
    [[ -z "$*" ]] && return 0
    for p in "$@"
    do
        if [[ -f "$p" || -d "$p" ]]; then
            path=$(python -c"import os; print os.path.realpath('$p')")
            return 0
        fi
    done
    return 1
}

reuse_dir () {
    [[ -n $dir && -d "$dir" ]] && return 0
    shift_dir "$@"
    return $?
}

shift_dir () {
    dir=$(pwd)
    [[ -z "$*" ]] && return 0
    for d in "$@"
    do
        if [[ -d "$d" ]]; then
            dir=$(python -c"import os; print os.path.realpath('$d')")
            return 0
        fi
    done
    return 1
}