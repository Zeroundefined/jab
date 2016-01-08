#! /bin/cat

require $JAB/src/bash/hub.sh
require $JAB/src/bash/asserts.sh

trap_what () {
    _assert_directory $HUB/what
    _assert_source $HUB/what/what.sh
}

_trap_what () {
    [[ ! -d $WHAT && -d $HUB/what ]] && WHAT=$HUB/what
    _trap_file $WHAT_SH
    source $WHAT_SH
}


_trap_python () {
    _assert_executable $(/usr/bin/env python)
    export PYTHON
}


_trap_jab () {
    [[ ! -d $JAB && -d $HUB/jab ]] && JAB=$HUB/jab
    [[ -d $JAB ]] || return 1
    [[ ! -d $JAB_LOCAL ]] && JAB_LOCAL=$JAB/local
}

