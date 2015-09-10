" File:    reset.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#reset#reset(param) "{{{
  let hash  = a:param.hash
  let files = exists('a:param.files') ? a:param.files : []
  return giti#system_with_specifics({
\   'command'      : printf('reset %s %s', hash, join(files)),
\   'with_confirm' : 1,
\ })
endfunction "}}}

function! giti#reset#hard(param) "{{{
  let hash  = a:param.hash
  let files = exists('a:param.files') ? a:param.files : []
  return giti#system_with_specifics({
\   'command'      : printf('reset --hard %s %s', hash, join(files)),
\   'with_confirm' : 1,
\ })
endfunction "}}}

function! giti#reset#head(param) "{{{
  let files = exists('a:param.files') ? a:param.files : ['.']
  return giti#system_with_specifics({
\   'command' : 'reset HEAD ' . join(files),
\   'ignore_error' : 1,
\ })
endfunction "}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
