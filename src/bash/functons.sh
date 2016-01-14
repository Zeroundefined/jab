#! /bin/cat

# set -e

. $JAB/bin/first_dir.sh

# Called functons.sh because "functions" is ... something else

# sorted by strcmp of function name

# x


c () {
    kd "$@"
    local c_result="$?"
    if [[ $c_result == "0" ]]; then
        _show_todo_here
        echo
        echo
        echo
        glg
        #show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
        #echo
        git_simple_status $(pwd)
    fi
    return $c_result
}

f () {
    shift_dir "$@" && shift
    local name=$1
    shift
    if [[ $name == "-name" ]]; then
        echo "Do not use '-name'"
        shift
        name=$1
    fi
    local old_ifs=$IFS
    IFS=";"
    for FOUND in $(find "$dir" -name "$name" -print "$@" | tr '\n' ';')
    do
        mython $JAB/bin/relpath -s $FOUND
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

p () {
    local me=$USER
    local here=$(jostname)
    export PYTHON=${PYTHON:-mython}
    console_title_on "mython@${here}" && \
        $PYTHON "$@" && \
        console_title_off "${me}@${here}"
}

q () {
    exit 0
}

v () {
    if [[ -z $* ]]; then
        $EDITOR
    else
        script=$(mython $JAB/src/python/vim.py "$@")
        status=$?
        if [[ $status == 0 ]]; then
            if [[ -n $script ]]; then
                if [[ -f "$script" ]]; then
                    bash $script
                    rq $script
                else
                    echo $script is not a file >&2
                fi
            else
                echo No script produced, please try
                echo mython $JAB/src/python/vim.py -U "$@"
            fi
        else
            echo Python error: $status
            if [[ -n $script ]]; then
                echo Script produced you could run it with
                echo "  bash $script"
                echo or debug the problem with
                echo "  mython $JAB/src/python/vim.py -U" "$@"
            else
                echo No script produced please try
                echo mython $JAB/src/python/vim.py -U "$@"
            fi
        fi
    fi
}

x () {
    exit 1
}

y () {
    clear
    mython $JAB/src/python/y.py "$@"
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
    . $JAB/src/bash/bd.sh -s "$@"
}

db () {
    ww $1;
    w $1;
    (set -x; "$@")
}

IP () {
    local BREAK=yes
    if [[ $1 == all ]]; then
        BREAK=no
    fi
    for number in 10 172 193 192 100
    do
        if python $JAB/src/python/ifconfig.py $number; then
            if [[ $BREAK == yes ]]; then
                break
            fi
        fi
    done
}

c. () {
    c . "$@"
}

cl () {
    c "$@" && lk
}

cn () {
    cat -n "$@"
}

cv () {
    kd $1
    v $(basename $1)
}

cy () {
    [[ -n $PYTHON_HOME ]] && c $PYTHON_HOME || echo "\$PYTHON_HOME not set"
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
    shift_dir "$@" && shift
    name=$1
    shift
    find $dir -type f -name $name "$@"
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

jj () {
    dir=$JAB
    clear; c $dir "$@"
}

_free_line_here () {
    :
}

ky () {
    shift_dir "$@" && shift
    dir=${dir:-$PYTHON_HOME}
    kd $dir "$@"
    y .
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
    lk $JAB "$@"
}

lh () {
    lk -lh  "$@"
}

lk () {
    LS_PROGRAM=$(which lk)
    local _gls=$(which gls)
    local _css=
    local _header=
    if [[ -f $_gls ]]; then
        LS_PROGRAM=$_gls
        _css="--color --classify "
        _header=--group-directories-first
    fi
    $LS_PROGRAM $_css $_header "$@"
    export LS_PROGRAM
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
    p $JAB/src/python/ls/ly.py  "$@"
}

ma () {
    local _storage=/tmp/fred.sh;
    if [[ -z "$@" ]]; then
        mython -c "print 'memo -a\"$*\"'" > $_storage;
        bash $_storage;
        cat $_storage;
        rq $_storage;
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
            script=$(mython $JAB/src/python/scripts.py -m $args 2>/dev/null)
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
    ranger "$@"
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
    cd $(tar ${contents}f $1 | hd1)
    ra
}

uj () {
# update $JAB from the repository
    if [[ $(svn up $JAB | grep -v "At revision" | wc -l) != "0" ]]; then
        BACK=$(pwd)
        if [[ $BACK != "$JAB" ]]; then
            cd $JAB
            source_path login.sh
            cd $BACK
        else
            source_path login.sh
        fi
    fi
}

v. () {
    v .
}

va () {
    _edit_jab src/bash/aliases.sh
}

vb () {
    _edit_jab login.sh
}

vd () {
    vim_diff "$1" "$2" "$3" -O
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
    pushd $JAB
    v.
    gsi
    popd >/dev/null 2>&1
}

vv () {
    [[ -n $* ]] && vim $JAB/vim/$1 || vim ~/.vimrc
}

vy () {
    v $(lk *.py | grep -v __*.py*)
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
    source_path $BITBUCKET/qaz/src/bash/qazrc
}

zm () {
    du -cms $1 | sort -n | sed -e "s/      / M     /g"
}

# xxx

add () {
    echo $(($1 + $2))
}

cib () {
    cn ~/.bashrc
}

cjy () {
    kd $JAB/src/python "$@"
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
        return 0
    fi
    ld $(pwd)
    echo
}

ddg () {
    firefox "https://next.duckduckgo.com/?q=$*"
}

dev () {
    if [[ -d "~/dev" ]]; then
        echo ~/dev exists
        echo
        here=$PWD
        cd ~/dev
        lk
        cd $here
        echo You may wish to try
        echo "    mv ~/dev/* ~/src; rm -rf ~/dev"
    fi
    [[ ! -d "~/src" ]] && mkdir ~/src
    c ~/src "$@"
    lk
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

fsh () {
# run fred.sh if it exists here or in ~/tmp
    $(freds -s "$@")
}

fpu () {
# debug fred.py if it exists here or in ~/tmp
    $(freds -d "$@")
}

fpy () {
# run fred.py if it exists here or in ~/tmp
    $(freds -p "$@")
}

ght () {
    gh "$@" | tel
}

ghv () {
    local __doc__="edit stuff from history"
    history | grep -v "\<\(history\|gh\)\>" | sed -e "s/^ *[0-9]\+ *//" -e "s/\([JFMASOND][a-z][a-z].[0-9][0-9] - [0-9:]\+\)\( \+\)/\1=/" | vim - +/"$@"
}

gre () {
    $(which grep) -h --color=never "$@"
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
    HEADLINES=${HEADLINES:-(( ${LINES:-$(tput lines)} / 2 ))}
    head -n ${1:-$HEADLINES} "$@"
}

hub () {
    c $HUB "$@"
    lk
}

jub () {
    c $HUB/../jab "$@"
    lk
}

jjj () {
# ssh back to the jab.ook (which is my laptop)
# it goes by different hostnames, try in order of probablity
    local jjj_host=
    local jab_ook=${JAB_OOK:-jab.ook}
    quick_ping jab.ook >/dev/null 2>&1 && jjj_host=jab.ook
    [[ -z $jjj_host ]] && echo Could not ping jab.ook || ssj jab $jjj_host
}


jjy () {
    ky $JAB/src/python "$@"
}

jpm () {
    PYTHONPATH=$PYTHONPATH:$HUB/jpm mython $HUB/jpm/bin/jpm "$@"
}

kpj () {
    rsync -a -e \"ssh -i $JAB_ID\"
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

lkr () {
    lk -lhtr "$@"
}

lll () {
    ll -a "$@"
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
    vim $JAB/local/numbers.txt
}

pi2 () {
    IPYTHON=ipython2; pi "$@"
}

pi3 () {
    IPYTHON=ipython3; pi "$@"
}

pyi () {
    cd $HUB/pym/pym
    add_to_a_path PATH ./bin
    add_to_a_path PYTHONPATH ./pym
    source ~/.virtualenvs/pym/bin/activate
    if [[ -n $* ]]; then
        if shift_dir "$@"; then
            shift
            cd $dir
        fi
    fi
    2
    pwd
    local _status=$(git status -s)
    if [[ -n $_status ]]; then
        echo -n "\$ git status -s: "
        git status -s
    else
        local has_dirs=
        for item in $(ls)
        do
            if [[ -d "$item" ]]; then
                has_dirs=1
                break
            fi
        done
        if [[ $has_dirs == 1 ]]; then
            3y -L 2 --noreport . | grep -v -e bdist.linux-x86_64 -e " _build$" -e __init__.py -e .egg-info
        fi
        echo
    fi
    if [[ -n $(ls *.py | grep -v __init__.py 2>/dev/null) ]]; then ly -q
    elif [[ -n $(ls * | grep -v __init__.py) ]]; then lk
    fi
    echo
    [[ -n $* ]] && "$@"
}

pyl () {
    pushd /home/alanb/src/git/code.rdkcentral.com/r/cmf/tools/blackduck >/dev/null 2>&1; grep "..pylint..disable=" */*/*.py | sed -e "s/=.*/=/" | uniq; popd > /dev/null 2>&1
}

ps3 () {
    if [[ -z "$@" ]]; then
        ps axf | vim - +
    else ps axf | vim - +/"$*"
    fi
}

raj () {
    pushd $JAB
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
    HEADLINES=${HEADLINES:-(( ${LINES:-$(tput lines)} / 2 ))}
    head -n ${1:-$HEADLINES} "$@"
    lines=$(echo "$*" | sed -e "s/ *-n.\([0-9]\+\)/\1/")
    if [[ -n $lines ]]; then
        args=$(echo "$*" | sed -e "s/^\(.*\) *-n.\([0-9]\+\)\(.*\)/\1\3/")
        echo tel $lines $args
        tail -n $lines $args
    else
        tail -n $(( ${LINES:-$(tput lines)} / 2 )) "$@"
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
    TRY=$JAB/src/python/testing/try.py
    [[ -f "./try.py" ]] && TRY=./try.py
    mython $TRY "$@"
}

vaf () {
    vim -p $JAB/src/bash/aliases.sh $JAB/src/bash/functons.sh
    source_path $JAB/src/bash/aliases.sh
    source_path $JAB/src/bash/functons.sh
}

vat () {
    vimcat "$@"
}

vbl () {
    vim $(ls -rt1 $JAB/log/*bashrc*.log | tail -n 1) + +?"^++ "
}

vib () {
    $EDITOR ~/.bashrc
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

vvb () {
    vvf sh.vim
}

vvf () {
    vv ftplugin/$1
}

vvg () {
    gv $JAB/vim/gvimrc
}

vvp () {
    vvf python
}

vvy () {
    vvf python/jab.vim
}


vvv () {
    v ~/.vim
}

vtr () {
    mython $JAB/src/python/vim_traceback.py "$@"
}

VIM () {
    sudo vim "$@"
}

xib () {
    bash -x ~/.bashrc
}

# xxxx

bump () {
    part=${1:-patch}
    bumpversion $part
    git push origin --tags
    grep current_version .bumpversion.cfg
}

down () {
    c ~/Download* "$@"
    lr -a
}

fynd () {
    shift_dir "$@" && shift
    local _level=2
    . $JAB/src/bash/functons.sh
    #sudo find $dir -maxdepth $_level -type f -exec $(which grep) -nH --color "$@" {} \; 2>&1 | sed -e /Binary.file/d -e /YouCompleteMe/d -e /.git/d 2>/dev/null
    sudo find $dir -maxdepth 2 -name .git -prune -o -type f -exec /bin/grep -nH --color "$@" {} \; | sed -e 's/.home.alanb.src.git.hub.jab/$JAB/' | g "$@"
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
    [[ -n $* ]] && cp $JAB/src/python/main.py $1 || cp $JAB/src/python/main.py $dir
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
    vim -p ~/.bashrc $JAB/login.sh
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

clock () {
    while sleep 1
    do
        tput sc
        tput cup 0 $(($(tput cols)-29))
        date
        tput rc
    done &
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
    mython $JAB/src/python/freds.py "$@"
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

vfile () {
    echo "I should've used vtr"
    mython $JAB/src/python/vfile.py "$@"
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
    sed -e s/TestClass/$classname/ -e s/test_case/$methodname/ $JAB/src/python/test_.py > $test_file
}

thirteen () {
    cd_one
    3d "$@"
}

todo_edit () {
    local todo_txt="$JAB/todo.txt"
    local git_options="--git-dir=$JAB/.git --work-tree=$JAB"
    if [[ -f todo.txt ]]; then
        todo_txt=todo.txt
        git_options=
    elif [[ -f TODO.md ]]; then
        todo_txt=TODO.md
        git_options=
    fi
    v $todo_txt
    if git status -s $JAB/todo.txt 2>&1 | grep -q "M.*$(basename $JAB/todo.txt)"; then
        git add $JAB/todo.txt
        git commit -m'more or less stuff to be done' $JAB/todo.txt
    elif svn stat "$JAB/todo.txt" 2>&1 | grep -q "M .* $JAB/todo.txt"; then
        svn ci -m'more or less stuff to be done' "$JAB/todo.txt"
    fi
}

todo_show () {
    local todo_txt="$JAB/todo.txt"
    if [[ -f todo.txt ]]; then todo_txt=todo.txt
    elif [[ -f TODO.md ]]; then todo_txt=TODO.md
    fi
    mython $JAB/src/python/todo.py $todo_txt
}

# xxxxxxxxxx
_like_duck () {
    has_py "$*"
}

jab_scripts () {
    mython $JAB/src/python/scripts.py "$@"
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
    editor_command="$EDITOR -d "
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
    /bin/bash $JAB/bin/publish_host.sh $HOME/public_html/index.html
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
        $EDITOR $filepath
    else
        pushd $filedir >/dev/null 2>&1
        $EDITOR $filepath
        popd >/dev/null 2>&1
    fi
    if echo $filepath | grep -q alias; then
        source_aliases $filepath
    else
        source_path $filepath "$@"
    fi
}

_edit_jab () {
    if [[ -z $JAB ]]; then
        echo \$JAB is empty >&2
    else
        [[ -d "$JAB" ]] || mkdir -p $JAB
        local filepath=$JAB/$1
        shift
        _edit_source $filepath "$@"
    fi
}

_edit_locals () {
    local local_dir=$JAB/local
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
