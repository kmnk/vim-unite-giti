" File:    rm.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#rm#run(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  return s:run({'command' : 'rm', 'files' : files})
endfunction "}}}

function! giti#rm#cached(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  return s:run({'command' : 'rm --cached', 'files' : files})
endfunction "}}}

" local functions {{{
function! s:run(param) "{{{
  let files = len(a:param.files) > 0 ? join(a:param.files) : '.'
  return giti#system_with_specifics({
\   'command' : a:param.command . ' -- ' . files,
\   'with_confirm' : 1,
\ })
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
