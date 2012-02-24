" File:    commit.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:edit_command = 'tabnew'
" }}}

function! giti#commit#run(files)"{{{
  call s:run('commit', a:files)
endfunction"}}}

function! giti#commit#amend()"{{{
  call s:run('commit --amend', [])
endfunction"}}}

" local functions {{{
function! s:run(command, files)"{{{
  call giti#system(a:command . ' -- ' . join(a:files))
  execute printf('%s %sCOMMIT_EDITMSG', s:edit_command, giti#dir())
  setlocal filetype=gitcommit bufhidden=wipe
  augroup GitiCommit
    autocmd BufWritePre <buffer> g/^#\|^\s*$/d
    execute printf('autocmd BufWritePost <buffer> call giti#system("%s") | ' .
\                  'autocmd! GitiCommit * <buffer>',
\     a:command . ' -F ' . expand('%') . ' -- ' . join(a:files))
  augroup END
endfunction"}}}
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
