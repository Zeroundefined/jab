if exists("g:loaded_jab_python")
    finish
endif
let g:loaded_jab_python = "v001"

noremap } :cn<cr>
noremap { :cp<cr>

noremap D Oimport pudb; pudb.set_trace()  # pylint: disable=multiple-statements<esc>j
noremap tf :Fix<cr>
noremap tm :Mash<cr>
noremap tt :MashTry<cr>
noremap tr :Try<cr>
noremap tp :Pylint<cr>
noremap <S-F9> :call WritePEP()<cr>
noremap <leader><space> :%s/\s\+$//<cr>
noremap <leader>;   :s/:$//<cr>
noremap <leader>:   :s/$/:/<cr>
noremap <leader>8   b"aye<c-o>/\(def\\|class\) <c-r>a(<cr>
noremap <leader>c   ?^\s*class \zs\i<cr>*
noremap <leader>d   ?^\s*def \i\+\zs.*<cr>*zv
noremap <leader>o   O<esc>
noremap <leader>e   ?^\s*def \zs\i<cr>*#zv
noremap <leader>k   $%a<cr><esc
noremap <leader>8   call matchadd('ColorColumn', '\(\%80v\|\%100v\)', 100)

call matchadd('ColorColumn', '\(\%80v\|\%100v\)', 100)

function! FoldCommentsAndIndentation(lnum)
    let line = getline(a:lnum)
    if line =~ '.*{{{'
        return 'a1'
    elseif line =~ '.*}}}'
        return 's1'
    endif
    let comment_re = '\v^\s*#(([{}]{3})@!.)*$'
    if getline(a:lnum) =~ comment_re
        if getline(a:lnum - 1) =~ comment_re
            return '1'
        else
            return '0'
        endif
    endif
    return indent(a:lnum) / &tabstop
endfunction

" PEP 8 calls for indentation with 4 spaces
set foldmethod=indent
" set foldexpr=FoldCommentsAndIndentation(v:lnum)
set foldlevel=0
" Do not treat comments differently (default has foldignore=#)
" https://stackoverflow.com/questions/8993455/how-do-i-fix-vim-to-properly-indent-folds-containing-python-comment-lines
set foldignore=
NoMatchParen

" Checkers
let g:syntastic_python_checkers=['pep8', 'pylint', 'python']
"let g:syntastic_python_python_exec = '~/bin/python'
"
" commenting this out because on jab.ook vim says
" E117: Unknown function: SyntasticStatuslineFlag
" E15: Invalid expression: SyntasticStatuslineFlag()
"
" set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
set laststatus=2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_stl_format = '%E{%e errors, from line %fe}%B{, }%W{%w warnings from line %fw}'


function FindUnitTest()
    let s:unit_test = substitute(s:file_py,'\.py$','_test.py',"")
    if ! filereadable(s:unit_test)
        let s:unit_test = 'test/' . s:unit_test
        if ! filereadable(s:unit_test)
            let s:unit_test = 'test/' . substitute(s:file_py,'\.py$','_test.py',"")
            if ! filereadable(s:unit_test)
                let s:unit_test = 'test/test_' . s:file_py
            endif
        endif
    endif
endfunction

function LoadUnitTest()
    call FindUnitTest()
    if filereadable(s:unit_test) && s:file_py != s:unit_test && &loadplugins
        setl autoread
        exec "tabnew " s:unit_test
        set filetype=python
        set foldlevel=1
    endif
endfunction

function FindTestUnit()
    let s:test_unit = substitute(s:file_py,'^','test_',"")
    if ! filereadable(s:test_unit)
        let s:test_unit = substitute(s:file_py,'^','tests/test_',"")
    endif
endfunction

function LoadTestUnit()
    call FindTestUnit()
    if filereadable(s:test_unit) && s:file_py != s:test_unit && s:unit_test != s:test_unit && &loadplugins
        setl autoread
        exec "tabnew " s:test_unit
        set filetype=python
        set foldlevel=1
    endif
endfunction

set autowrite
let s:file_name = expand("%")
let s:file_stem = fnamemodify(s:file_name,":r")
let s:file_py = s:file_stem . '.py'
let s:file_expected = s:file_stem . '.expected'
let s:file_actual = s:file_stem . '.actual'
if ! &diff && ! exists("g:recovering") && argc() == 1
    let s:file_jabber = substitute(s:file_py,'\.py$','.j',"")
    if filereadable(s:file_jabber) && s:file_py != s:file_jabber && &loadplugins
        exec "tabnew " s:file_jabber
    endif
    let s:file_parsley = substitute(s:file_py,'\.py$','.parsley',"")
    if filereadable(s:file_parsley) && s:file_py != s:file_parsley && &loadplugins
        exec "tabnew " s:file_parsley
        set filetype=doctest
    endif
    let s:file_grammar = substitute(s:file_py,'\.py$','.g',"")
    if filereadable(s:file_grammar) && s:file_py != s:file_grammar && &loadplugins
        exec "tabnew " s:file_grammar
        set filetype=doctest
    endif
    call LoadUnitTest()
    call LoadTestUnit()
    let s:file_test = substitute(s:file_py,'\.py$','.test',"")
    if filereadable(s:file_test) && s:file_py != s:file_test && &loadplugins
        setl autoread
        exec "tabnew " s:file_test
        set filetype=doctest
        set foldlevel=1
    endif
    let s:file_tests = substitute(s:file_py,'\.py$','.tests',"")
    if filereadable(s:file_tests) && s:file_py != s:file_tests && &loadplugins
        setl autoread
        exec "tabnew " s:file_tests
        set filetype=doctest
        set foldlevel=1
    endif
    let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
    if filereadable(s:file_fail) && s:file_py != s:file_fail && &loadplugins
        setl autoread
        exec "tabnew " s:file_fail
        set filetype=doctest_fail
    endif
    tabnext
    if !getfsize(expand('%')) > 0
        tabnext
        syntax on
    endif
endif
"
" Try to run this file(s) through doctest
"
if !exists("Try")
    function NewTestFile(filename)
        exec "tabnew! " . s:file_test
        exec "normal IThe " . s:file_stem . " module\<cr>===========" . substitute(s:file_stem, ".", "=", "g") . "\<cr>\<cr>    >>> import ". s:file_stem . "\<cr>>>> print " . s:file_stem . ".__doc__\<Esc>"
        set cmdheight+=1
        write
        set cmdheight-=1
    endfunction
    function TryTest(quietly)
        let item_name = s:file_stem . "."
        if ! filereadable(s:file_test) && ! filereadable(s:file_tests) && ! filereadable(s:test_unit) && ! filereadable(s:unit_test)
            call NewTestFile(s:file_test)
        endif
        if filereadable('./try.py')
            let try_py = './try.py'
        elseif filereadable($TRY)
            let try_py = $TRY
        else
            let try_py = '~/pysyte/testing/try.py'
        endif
        let command = "! TERM=linux && python " . try_py . " -qa "
        let command_line = command . item_name . " | grep -v DocTestRunner.merge "
        if a:quietly
            let tmpfile = tempname()
            let quiet_line = command_line . " > " . tmpfile . " 2>&1 || true"
        else
            let tmpfile = 'none'
            let quiet_line = command_line
        endif
        let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
        try
            exec quiet_line
            if tmpfile != 'none'
                call rename(tmpfile,s:file_fail)
            endif
            redraw!
        catch /.*/
            " echo fred
        endtry
        let old_tab = expand("%")
        exec "tablast"
        let last_tab = expand("%")
        if expand("%:e") == "fail"
            exec "quit!"
        endif
        if old_tab != last_tab
            while old_tab != expand("%")
                exec "tabnext"
            endwhile
        endif
        let path_to_fails = expand(s:file_fail)
        let z = getfsize(path_to_fails)
        " echo "Size of " . path_to_fails . " is " . z
        if ! z
            return
        endif
        exec "tablast"
        exec "tabnew! " . s:file_fail
    endfunction
    function Vim_Difference_Between_Expected_And_Got()
        if bufloaded(s:file_expected)
            exec "bunload " . s:file_expected
        endif
        if bufloaded(s:file_actual)
            exec "bunload " . s:file_actual
        endif
        if line('.') < 3
            call cursor(4,1)
        endif
        let a:wrapscan=&wrapscan
        set nowrapscan
        call search("Failed","b")
        let v:errmsg = ""
        silent! exec "/Expected/+1,/Got:/-1 w! " . s:file_expected
        if v:errmsg != ""
            echoerr "\"Expected\" not found after the cursor"
            return
        endif
        silent exec "/Got:/+1,/\\(^File\\)\\|\\(had failures\\)/-2 w! " . s:file_actual
        silent exec "tabnew " . s:file_expected
        set buftype=nofile
        set diffopt=filler,iwhite,vertical
        silent exec "diffsplit " . s:file_actual
        silent exec "tabprev"
        silent exec "tabnext"
        set buftype=nofile
        call delete(s:file_expected)
        call delete(s:file_actual)
        let &wrapscan=a:wrapscan
    endfunction
    function Try(quietly)
        if expand("%:e") == "fail"
            call Vim_Difference_Between_Expected_And_Got()
        else
            call TryTest(a:quietly)
        endif
    endfunction
    command! -nargs=0 Try :call Try(1)
endif
if !exists("Mash")
    function Mash()
        " replace tabs with 4 spaces
        try
            if &filetype == "doctest"
                exec "%s/^\t/    /"
            else
                exec "%s/^\t/    /g"
            endif
        catch /.*/
        endtry
    endfunction
    command -nargs=0 Mash :call Mash()

    function MashTry()
        call Mash()
        call Try(1)
    endfunction
    command -nargs=0 MashTry :call MashTry()
endif
"   From vim/vim70/vimrc_example.vim

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

function ReSpacePython()
    exec "retab"
    exec "%s/\\s\\+$//e"
endfunction


function WritePython()
    call ReSpacePython()
    call Try(1)
endfunction
autocmd BufWritePost * call WritePython()

" function LintPython()
"     let command = "! TERM=linux && pylint "
"     exec command_line
"     redraw!
" endfunction
" autocmd InsertLeave * call LintPython()

if !exists("PPP")
    function WritePEP()
        mkview
        normal zR
        call ReSpacePython()
        exec "%s/'''/\"\"\"/gce"
        exec "%s/^\\([^<'\"[]\\+\\):\\([^ ]\\)/\\1: \\2/gce"
        exec "%s/\\([^ ]\\) #/\\1  #/e"
        exec "%s/\\([^\\s]\\)\\n^\\n\\([a-z]\\)/\\1\\2/ce"
        exec "%s/\\[ \\(.*\\) ]/[\\1]/gce"
        exec "%s/\\[ /[/gce"
        exec "%s/\\([^ ]\\) \\]/\\1]/gce"
        exec "%s/( \\(.*\\) )/(\\1)/gce"
        exec "%s/( /(/gce"
        exec "%s/ )/)/gce"
        exec "%s/{ \\(.*\\) }/{\\1}/gce"
        exec "%s/{ /{/gce"
        exec "%s/\\([^ ]\\) }/}/gce"
        exec "%s/ , /, /gce"
        exec "%s/\\(^\\(\\s\\+\\)\\(try\\|for\\|if\\|except\\)\\( [^:]*\\)\\?: \\)/\\1\\2 /ce"
        " exec "%s/\\([^ ]\\)\\([=+-]\\)/\\1 \\2/gce"
        " exec "%s/\\([=+,-]\\)\\([^ =]\\)/\\1 \\2/gce"
        exec "%s/,\\([^ ]\\)/, \\1/gce"
        exec "%s/ += \\[\\(.*\\)]/.append(\\1)/gce"
        exec "%s/ += \\([^0-9].*\\)$/.append(\\1)/gce"
        exec "%s/\\s\\+$//ge"
        exec "%s/raise \\([A-Za-z]\\+\\), \\(.*\\)/raise \\1(\\2)/gce"
        loadview
    endfunction
    function AddDocstrings()
        exec '%s/\(^\s*def \)\([^(]\+\)\((.*):\n\)\(\s\+\)\([^  "]\)/\1\2\3\4""""""\4\5/e'
        let empty_docstring_line = search('""""""',"cn")
        if empty_docstring_line != 0
            exec '/"""\zs"""'
            normal n
            startinsert
        else
            normal i
        endif
    endfunction
    command -nargs=0 PPP :call WritePEP()
    command -nargs=0 PPA :call AddDocstrings()
endif
