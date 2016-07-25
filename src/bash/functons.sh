#! /bin/cat

# set -e

. ~/jab/bin/first_dir.sh

# Called functons.sh because "functions" is ... something else

# sorted by strcmp of function name

# x


/. () {
    cc "$@"
}

b () {
    if [[ -f ./build.sh ]]; then
        bash ./build.sh
    elif [[ -f Makefile ]]; then
        make
    fi
}

c () {
    kd "$@" || return 1
    _show_todo_here
    echo
    echo
    echo
    show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
    echo
    git_simple_status $(pwd) || lk
}

f () {
    local _arg_1=$1
    if [[ $_arg_1 == "-name" ]]; then
        echo "Do not use '-name'" >&2
        shift
    fi
    local _argc=${#*}
    dir=
    if [[ $_argc > 1 ]]; then
        shift_dir "$@" && shift
    elif [[ -z $dir ]]; then
        dir=$(pwd)
    fi
    local name=$1
    shift
    local old_ifs=$IFS
    IFS=";"
    for FOUND in $(find "$dir" -name "$name" -print "$@" | tr '\n' ';')
    do
        relpath -s $FOUND
    done
    IFS=$old_ifs
}

g () {
    $(which grep) --color "$@"
}

h () {
    history | tel "$@"
}

l () {
    $LS_PROGRAM
}

q () {
    exit 0
}

x () {
    exit 1
}

y () {
    clear
    mython ~/jab/src/python/y.py "$@"
}

# xx

3d () {
    3l "$@" -d
}

3l () {
    if first_num "$@"; then
        Tree -L $num $args
    else
        Tree -L 2 "$@"
    fi
}

3y () {
    if [[ -f "$1" ]]; then
        dir=$(dirname $1)
        shift
    elif [[ -d "$1" ]]; then
        dir=$1
        shift
    else
        dir=
    fi
    3l -P "*.py" $dir "$@"  --prune | sed -e 's/^│/ /' -e 's/\\s/_/g' -e 's/[│├└]/ /g' -e 's:──:/:'
}

add () {
    echo $($1 + $2)
}

ag () {
    alias | grep "$@"
}

bd () {
    . ~/jab/src/bash/bd.sh -s "$@"
}

dp () {
    (PYTHON_DEBUGGING=-U db "$@")
}

IP () {
    local BREAK=yes
    if [[ $1 == all ]]; then
        BREAK=no
    fi
    for number in 10 172 193 192 100
    do
        if python ~/jab/src/python/ifconfig.py $number; then
            if [[ $BREAK == yes ]]; then
                break
            fi
        fi
    done
}

cc () {
    local __doc__="There's always gcc, on the off chance it's needed"
    c . "$@"
}

cb () {
    c ~/bash/
}

ch () {
    c ~/hub/
}

cj () {
    c ~/jab/
}

cl () {
    c "$@" && lk
}

cv () {
    kd $1
    v $(basename $1)
}

cy () {
    c ~/python/
}

gf () {
    local __doc__="grep in any file args for other args"
    shift_dir "$@" && shift
    name=$1
    shift
    find $dir -name "$name" -exec grep --colour "$@" -nH {} \;
    local pattern=
    for arg in "$@"; do
        test ! -f "$arg" && pattern="$pattern $arg"
    done
    for arg in "$@"; do
        [[ $(type -t "$arg") == "file" ]] && grep --colour -nH --binary-files=without-match $arg $pattern
    done
}

gr () {
    g -nH "$@" 2> /dev/null
}

fa () {
    fv "$@"
}

fc () {
    shift_dir "$@" && shift
    name=$1
    shift
    for path in $(find $dir -name $name -print)
    do
        echo cd $path
        [[ -f "$path" ]] && builtin cd $(dirname $path) || builtin cd $path
    done
}

fd () {
    shift_dir "$@" && shift
    if [[ -n $1 ]]; then
        name=$1
        shift
    fi
    find $dir -type d -name $name "$@"
}

ff () {
    local __doc__="ff $dir $filename # finds files with that name in that dir"
    shift_dir "$@" && shift
    filename=$1; shift
    find $dir -type f -name $filename "$@"
}

fl () {
    freds | tr ' ' '\n'
}

fv () {
    shift_dir "$@" && shift
    if [[ -z "$@" ]]; then
        echo Nothing to find
    else
        files=$(find $dir -name "$@")
        if [[ -z $files ]]; then
            echo "$@" not found
        else
            echo $files | tr ' ' '\n' | sed -e "s:^\./::"
            vim -p $files
        fi
    fi
}

gg () {
    local readme="show grep results as vim commands"
    sought="$1"
    shift
    grep "$sought" "$@" | sed -e "s/^/vim /" -e "s|:.*| +/\"$sought\"|" | uniq
}

gv () {
    if which gvim >/dev/null 2>&1; then
        date >> ~/log/gvim.log
        echo gvim "$@" >> ~/log/gvim.log
        gvim "$@" 2>> ~/log/gvim.log
    else
        echo gvim not available >&2
        return 1
    fi
}

hd () {
    vim_diff "$1" "$2" "$3" -o
}

hv () {
    history | vim - +
}


_free_line_here () {
    :
}

ky () {
    shift_dir "$@" && shift
    dir=${dir:-~/jab/src/python}
    kd $dir "$@"
    y .
}


lo () {
    locate "$@"
}

l1 () {
    lk -1tr "$@"
}

la () {
    lk -a "$@"
}

ld () {
    lk -1d "$@"
}

lf () {
    locate -f "$@"
}

lj () {
    lk ~/jab "$@"
}

lh () {
    lk -lh  "$@"
}

lk () {
    LS_PROGRAM=$(which ls 2>/dev/null)
    local _gls=$(which gls 2>/dev/null)
    [[ -f $_gls ]] && LS_PROGRAM=$_gls
    export LS_PROGRAM
    local _css=
    $LS_PROGRAM  --help 2>/dev/null | grep -q -- --color && _css=--color
    $LS_PROGRAM  --help 2>/dev/null | grep -q -- --classify && _css="$_css --classify"
    local _header=
    $LS_PROGRAM  --help 2>/dev/null | grep -q -- --group-directories-first && _header=--group-directories-first
    $LS_PROGRAM $_css $_header "$@"
}

ll () {
    lk -l  "$@"
}

lo () {
    locate "$@"
}

lr () {
    lk -lhtr "$@"
}

lt () {
    lk *.test*
}

lx () {
    lk -xhtr "$@"
}

ly () {
    python ~/jab/src/python/ls/ly.py  "$@"
}

ma () {
    local _storage=/tmp/fred.sh;
    if [[ -z "$@" ]]; then
        mython -c "print 'memo -a\"$*\"'" > $_storage;
        bash $_storage;
        cat $_storage;
        rr $_storage;
    fi
}

ml () {
    memo -l 9
}

pg () {
    ps -ef | grep -v grep | grep "$@"
}

pi () {
    local me=$USER
    local here=$(jostname)
    local options=-noconfirm_exit
    local _ipython=${IPYTHON:-ipython}
    if [[ $(ipython --help | grep no.*confirm) == "--no-confirm-exit" ]]; then
        options=--no-confirm-exit
    fi
    console_title_on "ipython@${here}" && \
        $_ipython $options "$@" && \
        console_title_off "${me}@${here}"
}


py () {
    if [[ -z "$@" ]]; then
        mython
    else
        all_args="$*"
        if [[ "$all_args" =~ "--help" || "$all_args" =~ "-h" ]]; then
            mython "$@"
        elif [[ "$all_args" =~ "-U" ]]; then
            mython "$@"
        else
            script=$(mython ~/jab/src/python/scripts.py -m $args 2>/dev/null)
            if [[ $? == 0 ]]; then
                if [[ -z $script ]]; then
                    script=${1/%./.py}
                    shift
                fi
                mython $script $*
            else
                mython "$@"
            fi
        fi
    fi
}

ra () {
    [[ -f $1 ]] && ranger $(dirname $1) || ranger "$@"
}

ru () {
    # do da root root route, do da ru !
    if [[ -z "$@" ]]; then
        SUDO
    else
        sudo "$@"
    fi
}

tm () {
    if [[ -z $1 ]]; then SESSION=$(jostname)
    else
        SESSION=$1
        shift
    fi
    ! tmux attach-session -t $SESSION "$@" && tmux new-session -s $SESSION "$@"
}

tf () {
    [[ $? -eq 0 ]] && echo "true" || echo "false"
}

tt () {
    if echo $1 | grep -q "gz$"; then
        contents=tz
        extract=xz
    else
        contents=t
        extract=x
    fi
    tar ${extract}f $1
    c $(tar ${contents}f $1 | hd1)
    ra
}

va () {
    _edit_jab src/bash/aliases.sh
}

ve () {
    _edit_jab environ.d/jab.sh "$@"
}

vf () {
    _edit_jab src/bash/functons.sh "$@"
}

if ! what -q vi; then

vi () {
    vim ~/.inputrc +/Key.bindings
}

fi

vj () {
    (cd ~/jab;
        v.
        gsi)
}

vy () {
    v $(ls *.py | grep -v '__*.py*')
}

xe () {
    local amount=$1
    local from=USD
    [[ -n $2 ]] && from=$2
    local to=EUR
    [[ -n $3 ]] && to=$3
    curl "http://www.xe.com/wap/2co/convert.cgi?Amount=$amount&From=$from&To=$to" -A "Mozilla" -s | sed -n "s/.*>\(.*\) $to<.*/\1/p";
}

sq () {
    . $GIT_BUCKET/qaz/src/bash/qazrc
}

zm () {
    du -cms "$1" | sort -n | sed -e "s/\t/    /" -e "s/    / Mb /g"
}

# xxx

add () {
    echo $(($1 + $2))
}

can () {
    cat -n "$@"
}

cib () {
    cn ~/.bashrc
}

cjy () {
    kd ~/jab/src/python "$@"
}

clf () {
    cat ~/jab/local/functons.sh
}

clo () {
    c $(locate "$@")
}

cls () {
    local __doc__="clean, clear, ls"
    clean
    clear
    if [[ -n "$@" ]]; then
        lk "$@"
    else
        ld $(pwd)
        echo
    fi
}

ddg () {
    firefox "https://next.duckduckgo.com/?q=$*"
}

fcc () {
    $(freds -l)
}

fee () {
    $(freds -e "$@")
}

fgg () {
    fgv *.py "$@"
}

fgp () {
    fgv *.py "$@"
}

fgt () {
    fgv *.test *.tests "$@"
}

fll () {
    $(freds -l)
}

fpu () {
# debug fred.py if it exists here or in ~/tmp
    $(freds -d "$@")
}

fpy () {
# run fred.py if it exists here or in ~/tmp
    $(freds -p "$@")
}

frd () {
# debug fred.py if it exists here or in ~/tmp
    $(freds -d "$@")
}

frr () {
# run fred.py if it exists here or in ~/tmp
    $(freds -p "$@")
}

fsh () {
# run fred.sh if it exists here or in ~/tmp
    $(freds -s "$@")
}

fss () {
# run fred.sh if it exists here or in ~/tmp
    $(freds -s "$@")
}

ftt () {
    fgv *.test *.tests "$@"
}
ght () {
    gh "$@" | tel
}

ghv () {
    local __doc__="edit stuff from history"
    history | grep -v "\<\(history\|gh\)\>" | sed -e "s/^ *[0-9]\+ *//" -e "s/\([JFMASOND][a-z][a-z].[0-9][0-9] - [0-9:]\+\)\( \+\)/\1=/" | vim - +/"$@"
}

gre () {
    [[ -z $* ]] && echo "gre what?" >&2 || $(which grep) -h --color=never "$@"
}

gv. () {
    PYTHONPATH=$(readlink -f .) gv .
}

gvd () {
    EDITOR=gvim vd "$@"
}

hd1 () {
    head -n 1 "$@"
}

hed () {
    SCREEN=$(screen_height)
    SCREEN=${LINES:-$(screen_height)}
    HALF_SCREEN=`expr $SCREEN / 2`
    HEADLINES=${HEADLINES:-$HALF_SCREEN}
    head -n ${1:-$HEADLINES} "$@"
}

hub () {
    c ~/hub "$@"
}

jjb () {
    kk ~/jab/src/bash "@"
}

jjy () {
    kk ~/jab/src/python "$@"
}

kpj () {
    rsync -a -e \"ssh -i ~/.ssh/jab_id\"
}

l1d () {
    ld -1 "$@"
}

lda () {
    ls -1da "$@"
}

lff () {
    ls fred*
}

lka () {
    lk -a "$@"
}

lkk () {
    lk -a "$@"
}

lkl () {
    lkra "$@"
}

lkq () {
    local _sought=$1
    if [[ -f $_sought ]]; then
        lk $_sought
        return 0
    fi
    while [[ -n $_sought ]]; do
        if lk -d $_sought 2>/dev/null; then
            break
        fi
        _sought=$(dirname $_sought)
        if [[ $_sought == / ]]; then
            break
        fi
    done
}

lkr () {
    lk -lhtr "$@"
}

lib () {
    lr ~/.bashrc
}

lly () {
    shift_dir "$@" && shift
    reset=$(shopt -p dotglob)
    shopt -s dotglob
    lr "$dir"/*.tests
    echo
    lr "$dir"/*.test
    echo
    lr "$dir"/*.py
    $reset
}

lr2 () {
    lra "$@" | grep --color -- "->"
}

lr1 () {
    shift_dir "$@" && shift
    lk -1tr --color=always "$dir" | tel
}

lra () {
    lr -a "$@"
}

lrd () {
    lr -d "$@"
}

lrt () {
    lk --color=always -lrth "$@" | tel
}

ls1 () {
    l1 "$@" | sort
}

lsh () {
    lk *.sh
}


lyy () {
    reset=$(shopt -p dotglob)
    shopt -s dotglob
    lk -xd $(ls -F |grep \/$)
    echo
    lx *.tests 2>/dev/null
    echo
    lx *.test 2>/dev/null
    echo
    lx *.py 2>/dev/null
    $reset
}

num () {
    vim ~/jab/local/numbers.txt
}

pi2 () {
    IPYTHON=ipython2; pi "$@"
}

pi3 () {
    IPYTHON=ipython3; pi "$@"
}

ps3 () {
    if [[ -z "$@" ]]; then
        ps axf | vim - +
    else ps axf | vim - +/"$*"
    fi
}

raj () {
    pushd ~/jab
    range "$@"
    popd >/dev/null 2>&1
}

rff () {
    $(freds -r "$@")
}

sib () {
    source_path ~/.bashrc
}

sto () {
    firefox "http://stackoverflow.com/search?q=$*"
}

tel () {
    # Using "$*" instead of "$@" deliberately here
    # Side effect: args are now text, not args
    HEADLINES=${HEADLINES:-(( ${LINES:-$(screen_height)} / 2 ))}
    head -n ${1:-$HEADLINES} "$@"
    lines=$(echo "$*" | sed -e "s/ *-n.\([0-9]\+\)/\1/")
    if [[ -n $lines ]]; then
        args=$(echo "$*" | sed -e "s/^\(.*\) *-n.\([0-9]\+\)\(.*\)/\1\3/")
        echo tel $lines $args
        tail -n $lines $args
    else
        tail -n $(( ${LINES:-$(screen_height)} / 2 )) "$@"
    fi
}

tma () {
    tmux new-session -A -s jabtmux
}

tmp () {
    pushd $(mython $KD_DIR/kd.py ~/tmp "$@")
}

unalias try > /dev/null 2>&1
try () {
    TRY=~/jab/src/python/testing/try.py
    [[ -f "./try.py" ]] && TRY=./try.py
    mython $TRY "$@"
}

vaf () {
    vim -p ~/jab/src/bash/aliases.sh ~/jab/src/bash/functons.sh
    source_path ~/jab/src/bash/aliases.sh
    source_path ~/jab/src/bash/functons.sh
}

vat () {
    vimcat "$@"
}

vbb () {
    vim -p ~/.bashrc ~/hub/jab/__init__.sh "$@" +/bash
    ls -l ~/.bashrc ~/hub/jab/__init__.sh
}

vbl () {
    vim $(ls -rt1 ~/jab/log/*bashrc*.log | tail -n 1) + +?"^++ "
}

vfg () {
    _sought="$1" && shift
    vf "$@" +/$_sought
}

vfr () {
    mython ~/jab/src/python/vim_traceback.py "$@"
}

vib () {
    v ~/.bashrc
}

vin () {
    vim -c "setlocal buftype=nofile bufhidden=hide noswapfile" -
}

vla () {
    _edit_locals aliases.sh
}

vle () {
    _edit_locals environ.sh
}

vlf () {
    _edit_locals functons.sh
}

vlo () {
    v $(locate "$@")
}

vff () {
    $(freds -e "$@")
}

vpe () {
    _edit_jab environ.d/python
}

vtr () {
    mython ~/jab/src/python/vim_traceback.py "$@"
}

vpr () {
    _crappy_program_py =$1
    python _crappy_program_py | python ~/jab/src/python/vim_traceback.py
}

vtr () {
    mython ~/jab/src/python/vim_traceback.py "$@"
}

VIM () {
    sudo vim "$@"
}

xib () {
    bash -x ~/.bashrc
}

# xxxx

brew () {
    GIT= /usr/local/bin/brew "$@"
}

bump () {
    local _bump_dir=.
    if [[ -d "$1" ]] ; then _bump_dir="$1"; shift; fi
    local _part=${1:-patch}
    if [[ $_part != show ]]; then
        if bumpversion "$@" $_part; then
            git push origin --tags
        fi
    fi
    local _config=$(git_root $_bump_dir)/.bumpversion.cfg 
    local _sought=^current_version
    if [[ $_part == show ]]; then
        grep $_sought $_config | grep --colour " [^ ]\+$"
    else
        grep $_sought $_config 2>/dev/null
    fi
}

calf () {
    cat ~/jab/local/functons.sh
}

down () {
    c ~/Download* "$@"
    lr -a
}

lkra () {
    lkr -a "$@"
}

left () {
    local last_command="$1"
    echo $last_command
    local last_command_line="$@"
    echo $last_command_line
}

main () {
    shift_dir "$@" && shift
    [[ -n $* ]] && cp ~/jab/src/python/main.py $1 || cp ~/jab/src/python/main.py $dir
}

mine () {
    sudo chown -R $(id -un):$(id -gn) "$@"
}

mkcd () {
    local __doc__='make a directory and start using it';
    if [[ -d "$@" ]]; then
        echo Directory existed "$@"
    else
        mkdir -p "$@"
    fi
    cd "$@"
}

nose () {
    nosetests --with-progressive "$@"
}

SUDO () {
    if [[ -n $1 ]]; then
        user="-u $1"
        you_sir="$1"
    else
        user=
        you_sir=root
    fi
    me=$USER
    here=$(jostname)
    console_title_on "${you_sir}@${here}" && \
        sudo -i $user bash && \
        console_title_off "${me}@${here}"
}

dicp () {
    COMMAND_FOR_SAME_FILES=cp
    _dixx "$1" "$2"
}

dihh () {
    COMMAND_FOR_SAME_FILES=hd
    _dixx "$@"
}

divv () {
    COMMAND_FOR_SAME_FILES=vd
    _dixx "$@"
}

this () {
    python -c "import this"
}

Tree () {
    tree "$@" | more
}

vibb () {
    vim -p ~/.bashrc ~/jab/login.sh
}

vini () {
    vim -p $(find ~/jab -name __init__.sh | tr '\n' ' ')
}

# xxxxx

build () {
    if [[ -f build.sh ]]; then bash build.sh "$@"
    elif [[ -f Makefile ]]; then make "$@"
    fi
}

clean () {
    rfq "$@"
}

detab () {
    local _expand=$(which expand)
    what -q gexpand && _expand=$(what -f gexpand)
    if [[ -f "$1" ]]; then
        if grep -Pq "^\s*\t\s*[^ \t]" $1; then
            $_expand -i --tabs=4 $1 > /tmp/txt
            mv /tmp/txt $1
            echo detabbed
        else
            echo no tabs
        fi
    else
        echo not a file $1
    fi
}

freds () {
    mython ~/jab/src/python/freds.py "$@"
}

LetGo () {
    echo 'Digger, Thumber, Tarzan, Climber'
}

quack () {
    local _result=1
    for $item in "$@"; do
        if _like_duck $item; then
            python  $1
            _result=0
        fi
    done
    return $_result
}

range () {
    local destination=.
    if [[ -n "$*" ]]; then
        local kd_script=$KD_DIR/kd.py
        if ! destination=$(PYTHONPATH=$python_directory mython $kd_script "$@" 2>&1); then
            echo "$destination"
            return 1
        fi
    fi
    local real_destination=$(PYTHONPATH=$python_directory python -c "import os; print os.path.realpath('$destination')")
    if [[ $destination != $real_destination ]]; then
        echo "ranger ($destination ->) $real_destination"
        destination=$real_destination
    elif [[ $destination != $1 && $1 != "-" ]]; then
        echo "ranger $destination"
    fi
    pushd "$destination"
    source $(which ranger) $(which ranger)
    console_whoami
    return 0
}

taocl() {
    curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80
}

ylint () {
    mython /home/alanb/.jab/src/python/site/ylint.py "$@"
}

# xxxxxx

cd_one () {
    clear
    shift_dir "$@" && shift
    c $dir
}

has_py () {
    has_ext py "$@"
}

lessen () {
    less -NR "$@"
}

lesser () {
    less -R "$@"
}

online () {
    quick_ping www.google.com >/dev/null 2>&1 && echo online || echo offline
}

please () {
    local last=$(history -p !-1)
    echo "sudo $last"
    sudo $last
}

mython () {
    PATH=$HOME/bin:/usr/local/bin:/usr/bin python2.7 "$@"
}

qwerty  () {
    echo '` 1 2 3 4 5 6 7 8 9 0 - = '
    echo 'q w e r t y u i o p [ ]'
    echo 'a s d f g h j k l ;' "'" '#'
    echo '\ z x c v b n m , . /'
}

run_as () {
    username=$1
    shift
    if [[ -n "$1" ]]; then
        sudo -u $username "$@"
    else
        SUDO $username
    fi
}

# xxxxxxx

has_ext () {
    [[ -n $(ls ${2:-.}/*.$1 2>/dev/null | grep -v -e fred -e log  | hd1) ]]
}


pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

relpath () {
    python ~/jab/src/python/relpath.py "$@"
}

# xxxxxxxx

jostname () {
    echo ${HOSTNAME:-$(hostname -s)}
}

maketest () {
    local path="$1"
    if [[ ! -f "$path" ]]; then
        echo $path is not a file >&2
        return 1
    fi
    local filename=$(basename $path)
    local stem=${filename%.*}
    local classname=$(mython -c "print 'Test%s' % '$stem'.title()")
    local methodname="test_$stem"
    local test_file=$(mython -c "import os; print os.path.join(os.path.dirname(os.path.abspath('$path')), 'test', 'test_%s' % os.path.basename('$path'))")
    if [[ -f "$test_file" ]]; then
        echo $test_file is already a file >&2
        return 1
    fi
    local test_dir=$(dirname $test_file)
    [[ -d "$test_dir" ]] || mkdir -p "$test_dir"
    sed -e s/TestClass/$classname/ -e s/test_case/$methodname/ ~/jab/src/python/test_.py > $test_file
}

sudo_ssh () {
    local _host=$1; shift
    ssh -t -q $_host "sudo ""$@"
}

thirteen () {
    cd_one
    3d "$@"
}

todo_edit () {
    local todo_txt="~/jab/todo.txt"
    local git_options="--git-dir=~/jab/.git --work-tree=~/jab"
    if [[ -f todo.txt ]]; then
        todo_txt=todo.txt
        git_options=
    elif [[ -f TODO.md ]]; then
        todo_txt=TODO.md
        git_options=
    fi
    v $todo_txt
    if git status -s ~/jab/todo.txt 2>&1 | grep -q "M.*$(basename ~/jab/todo.txt)"; then
        git add ~/jab/todo.txt
        git commit -m'more or less stuff to be done' ~/jab/todo.txt
    elif svn stat "~/jab/todo.txt" 2>&1 | grep -q "M .* ~/jab/todo.txt"; then
        svn ci -m'more or less stuff to be done' "~/jab/todo.txt"
    fi
}

todo_show () {
    local todo_txt="~/jab/todo.txt"
    if [[ -f todo.txt ]]; then todo_txt=todo.txt
    elif [[ -f TODO.md ]]; then todo_txt=TODO.md
    fi
    mython ~/jab/src/python/todo.py $todo_txt
}

# xxxxxxxxxx
_like_duck () {
    has_py "$*"
}

jab_scripts () {
    mython ~/jab/src/python/scripts.py "$@"
}

quick_ping () {
    if ping -c 1 -w 1 -W 1 "$@" 2>&1 | /bin/grep -q illegal; then
        # looks like OS X
        ping -c 1 -t 1 -W 1 "$@"
    else
        # make sure we return correctly
        ping -c 1 -w 1 -W 1 "$@"
    fi
}

thirty_two () {
    3l "$@"
    2
}

# _______________

_show_todo_here () {
    [[ -f todo.txt ]] && todo_show
}

_diff_two_files () {
    ! diff -q $1 $2 >/dev/null 2>&1
}

_any_diff () {
    _diff_two_files $1 $2 && return 0
    [[ -z $3 ]] && return 1
    _diff_two_files $1 $3 && return 0
    _diff_two_files $2 $3 && return 0
    return 1
}

vim_diff () {
    first_file="$1"
    shift
    second_file="$1"
    shift
    third_file=
    editor_command="v -d "
    for arg in "$@"
    do
        [[ $arg =~ -.* ]] && editor_command="$editor_command $arg" && continue
        [[ -z $third_file ]] && third_file=$arg
    done
    if ! _any_diff "$first_file" "$second_file" "$third_file"; then
        echo same
        return 0
    fi
    if [[ -n $third_file ]]; then
        $editor_command "$first_file" "$second_file" "$third_file"
    else $editor_command "$first_file" "$second_file"
    fi
}

# xxxxxxxxxx

# xxxxxxxxxxx

# xxxxxxxxxxxx

blank_script () {
    [[ -f "$1" ]] && return
    echo "#! /bin/bash" > $1
    echo "" >> $1
}

# xxxxxxxxxxxxx

console_hello () {
    local me=$USER
    local here=$(jostname)
    export PYTHON=${PYTHON:-mython}
    console_title_on "mython@${here}" && \
        $PYTHON "$@" && \
        console_title_off "${me}@${here}"
}

one_two_three () {
    clear
    cd_one "$@"
    todo_show
    if first_num "$@"; then
        3d $num --noreport $args
    else
        3d 1 --noreport "$@"
    fi
    lk $(ls1 -p | g -v "\(pyc\|/\)$")
}

sudo_default () {
    sudo_ssh default "$@"
}

three_two_one () {
    clear
    3d 2 "$@"
    todo_show
    cd_one "$@"
}

# xxxxxxxxxxxxxx

console_whoami () {
    console_title_on $USER@$(jostname)...$(basename "$PWD")
}

source_aliases () {
    local __doc__='source files which have aliases and remember the filenames'
    ALIASES="$ALIASES:$1"
    source $1
}

# xxxxxxxxxxxxxxx

# xxxxxxxxxxxxxxxx

console_title_on () {
    if [[ -n $TERM_PROGRAM && $TERM_PROGRAM == "iTerm.app" ]]; then
        echo -e "\033]0;$1\007" # http://stackoverflow.com/a/6887306/500942
    elif env | grep -iq konsole 2>/dev/null; then
        #dcop $KONSOLE_DCOP_SESSION renameSession $1
        echo -e "\033]0;$1\007" # http://stackoverflow.com/a/21380108/500942
    elif env | grep -iq gnome.terminal; then
        echo -e "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
    elif [[ -n $TERM ]]; then
        if [[ $TERM == "linux" ]]; then
            echo -e "]1;$1"
        elif [[ $TERM =~ xterm ]]; then
            echo -ne "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
        fi
    else
        echo "Title: $1"
    fi
}

show_functons_in ()
{
    for f in $(grep "^[a-z][a-z_]\+ .. .$" $1  | sed -e "s: .. .$::"); do
        what -v $f; done | lesser
}

# xxxxxxxxxxxxxxxxx

console_title_off () {
    if [[ -n $TERM_PROGRAM && $TERM_PROGRAM == "iTerm.app" ]]; then
        echo -e "]0;$1"
    elif env | grep -iq konsole 2>/dev/null; then
        dcop $KONSOLE_DCOP_SESSION renameSession $1
    elif env | grep -iq gnome.terminal; then
        echo -e "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
    elif [[ -n $TERM ]]; then
        if [[ $TERM == "linux" ]]; then
            echo -e "]1;$1"
        elif [[ $TERM =~ xterm ]]; then
            echo -e "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
        fi
    else
        echo "Title: $1"
    fi
}

# _xxxxxxxxxxxxxxxxxxx

_publish_Localhost () {
    /bin/bash ~/jab/bin/publish_host.sh $HOME/public_html/index.html
}

# functions starting with an underscore are intended for use within this file only

_dixx () {
    source_dir="$1"
    destination_dir="$2"
    local number_in_both=$(_divv_get_difference | grep Files | wc -l)
    if [[ $number_in_both -gt 0 ]]; then
        echo
        echo "# Files 1 and 2 differ"
        _divv_get_difference | grep Files | sed -e 's/Files /'$COMMAND_FOR_SAME_FILES' "/' -e 's/ and /" "/' -e 's/ differ/"/'
    fi
    local number_in_source=$(_divv_get_difference | grep "Only in $source_dir" | wc -l)
    if [[ $number_in_source -gt 0 ]]; then
        echo
        echo "Only in $source_dir"
        _divv_get_difference | grep "Only in $source_dir" | sed -e "s/Only in/vim /" -e "s|: |/|"
    fi
    local number_in_destination=$(_divv_get_difference | grep "Only in $destination_dir" | wc -l)
    if [[ $number_in_destination -gt 0 ]]; then
        echo
        echo "Only in $destination_dir"
        _divv_get_difference | grep "Only in $destination_dir" | sed -e "s/Only in/vim /" -e "s|: |/|"
    fi
}

_edit_source () {
    local filepath=$1
    shift
    blank_script $filepath
    filedir=$(dirname $filepath)
    if [[ $filedir == "." ]]; then
        v $filepath
    else
        pushd $filedir >/dev/null 2>&1
        v $filepath
        popd >/dev/null 2>&1
    fi
    if echo $filepath | grep -q alias; then
        source_aliases $filepath
    else
        source_path $filepath "$@"
    fi
}

_edit_jab () {
    if [[ -z ~/jab ]]; then
        echo ~/jab is empty >&2
    else
        [[ -d "~/jab" ]] || mkdir -p ~/jab
        local filepath=~/jab/$1
        shift
        _edit_source $filepath "$@"
    fi
}

_edit_locals () {
    local local_dir=~/jab/local
    [[ -d "$local_dir" ]] || mkdir -p $local_dir
    _edit_source $local_dir/$1
}

_divv_get_difference () {
    local source_gitignore=
    [[ -f "$source_dir/.gitignore" ]] && source_gitignore="--exclude-from=$source_dir/.gitignore"
    local destination_gitignore=
    [[ -f "$destination_dir/.gitignore" ]] && destination_gitignore="--exclude-from=$destination_dir/.gitignore"
    diff -q -r \
        --exclude=.svn \
        --exclude=.git \
        --exclude=.DS_Store \
        --exclude="*.fail" \
        --exclude="*.py[co]" \
        --exclude=tags \
        --exclude=".*sw[po]" \
        --exclude=tmp \
        --exclude="*~" \
        --exclude="*.beam" \
        --exclude="*.a" \
        --exclude="*.o" \
        --exclude=.gitignore \
        $source_gitignore \
        $destination_gitignore \
    "$source_dir" "$destination_dir" 2>/dev/null
}
#! /bin/cat

# set -e

. ~/jab/bin/first_dir.sh

# Called functons.sh because "functions" is ... something else

# sorted by strcmp of function name

# x


/. () {
    c . "$@"
}

b () {
    if [[ -f ./build.sh ]]; then
        bash ./build.sh
    elif [[ -f Makefile ]]; then
        make
    fi
}

c () {
    kd "$@"
    local c_result="$?"
    if [[ $c_result == "0" ]]; then
        _show_todo_here
        echo
        echo
        echo
        show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
        echo
        git_simple_status $(pwd) || lk
    fi
    return $c_result
}

f () {
    local _arg_1=$1
    if [[ $_arg_1 == "-name" ]]; then
        echo "Do not use '-name'" >&2
        shift
    fi
    local _argc=${#*}
    dir=
    if [[ $_argc > 1 ]]; then
        shift_dir "$@" && shift
    elif [[ -z $dir ]]; then
        dir=$(pwd)
    fi
    local name=$1
    shift
    local old_ifs=$IFS
    IFS=";"
    for FOUND in $(find "$dir" -name "$name" -print "$@" | tr '\n' ';')
    do
        relpath -s $FOUND
    done
    IFS=$old_ifs
}

g () {
    $(which grep) --color "$@"
}

h () {
    shift
    blank_script $filepath
    filedir=$(dirname $filepath)
    if [[ $filedir == "." ]]; then
        v $filepath
    else
        pushd $filedir >/dev/null 2>&1
        v $filepath
        popd >/dev/null 2>&1
    fi
    if echo $filepath | grep -q alias; then
        source_aliases $filepath
    else
        source_path $filepath "$@"
    fi
}

_edit_jab () {
    if [[ ! -d ~/jab ]]; then
        echo ~/jab is not a dir >&2
    else
        [[ -d ~/jab ]] || mkdir -p ~/jab
        local filepath=~/jab/$1
        shift
        _edit_source $filepath "$@"
    fi
}

_edit_locals () {
    local local_dir=~/jab/local
    [[ -d "$local_dir" ]] || mkdir -p $local_dir
    _edit_source $local_dir/$1
}

_divv_get_difference () {
    local source_gitignore=
    [[ -f "$source_dir/.gitignore" ]] && source_gitignore="--exclude-from=$source_dir/.gitignore"
    local destination_gitignore=
    [[ -f "$destination_dir/.gitignore" ]] && destination_gitignore="--exclude-from=$destination_dir/.gitignore"
    diff -q -r \
        --exclude=.svn \
        --exclude=.git \
        --exclude=.DS_Store \
        --exclude="*.fail" \
        --exclude="*.py[co]" \
        --exclude=tags \
        --exclude=".*sw[po]" \
        --exclude=tmp \
        --exclude="*~" \
        --exclude="*.beam" \
        --exclude="*.a" \
        --exclude="*.o" \
        --exclude=.gitignore \
        $source_gitignore \
        $destination_gitignore \
    "$source_dir" "$destination_dir" 2>/dev/null
}
