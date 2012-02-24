" File:    push.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#push#run(...)"{{{
  if len(a:000) == 2
    let res = giti#system_with_confirm('push ' . a:1 . ' ' . a:2)
  else
    let res = giti#system_with_confirm('push')
  endif
  if v:shell_error
    echoerr res
  endif
  return res
endfunction"}}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
