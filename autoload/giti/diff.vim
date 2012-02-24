" File:    diff.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#diff#run(...)"{{{
  if len(a:000) > 0
    call s:run('diff', a:1)
  else
    call s:run('diff', [])
  endif
endfunction"}}}

function! giti#diff#cached(...)"{{{
  if len(a:000) > 0
    call s:run('diff --cached', a:1)
  else
    call s:run('diff --cached', [])
  endif
endfunction"}}}

" local functions {{{
function! s:run(command, files)"{{{
  let diff = giti#system(a:command . ' -- ' . join(a:files))
  if !strlen(diff)
    echo 'no difference'
    return
  endif
  execute printf('%s', giti#edit_command())
  put!=diff
  setlocal filetype=diff buftype=nofile readonly nomodifiable nofoldenable
  keepjumps normal gg
endfunction"}}}
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
