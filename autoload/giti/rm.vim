" File:    rm.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#rm#run(...)"{{{
  if len(a:000) > 0
    return s:run('rm', a:1)
  else
    return s:run('rm', [])
  endif
endfunction"}}}

function! giti#rm#cached(...)"{{{
  if len(a:000) > 0
    return s:run('rm --cached', a:1)
  else
    return s:run('rm --cached', [])
  endif
endfunction"}}}

" local functions {{{
function! s:run(command, files)"{{{
  let files = len(a:files) > 0 ? join(a:files) : '.'
  return giti#system_with_specifics({
\   'command' : a:command . ' -- ' . files,
\   'with_confirm' : 1,
\ })
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
