" File:    pull.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#pull#run(param)"{{{
  let param = a:param
  let param.command = 'pull'
  return s:run(param)
endfunction"}}}

function! giti#pull#squash(param)"{{{
  let param = a:param
  let a:param.command = 'pull --squash'
  return s:run(param)
endfunction"}}}

function! giti#pull#expressly()"{{{
  let param = {}
  let param.command = 'pull'
  let param.repository = input("repository: ")
  let param.refspec    = input("refspec: ")
  return s:run(param)
endfunction"}}}

" local functions {{{

function! s:run(param)"{{{
  return giti#system_with_specifics({
\   'command' : printf('%s %s %s',
\     exists('a:param.command')    ? a:param.command    : '',
\     exists('a:param.repository') ? a:param.repository : '',
\     exists('a:param.refspec')    ? a:param.refspec    : '',
\   ),
\   'with_confirm' : 1,
\ })
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
