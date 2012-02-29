" File:    diff.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#diff#run(...)"{{{
  call s:run('diff', len(a:000) > 0 ? a:1 : [])
endfunction"}}}

function! giti#diff#cached(...)"{{{
  call s:run('diff --cached', len(a:000) > 0 ? a:1 : [])
endfunction"}}}

function! giti#diff#head(...)"{{{
  call s:run('diff HEAD', len(a:000) > 0 ? a:1 : [])
endfunction"}}}

function! giti#diff#specify(from, to, ...)"{{{
  call s:run(printf('diff %s..%s', a:from, a:to),
\            len(a:000) > 0 ? a:1 : [])
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
