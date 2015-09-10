" File:    pull.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#pull#run(param) "{{{
  let arg = a:param
  let arg.command = 'pull'
  return s:run(arg)
endfunction "}}}

function! giti#pull#squash(param) "{{{
  let arg = a:param
  let arg.command = 'pull --squash'
  return s:run(arg)
endfunction "}}}

function! giti#pull#rebase(param) "{{{
  let arg = a:param
  let arg.command = 'pull --rebase'
  return s:run(arg)
endfunction "}}}

function! giti#pull#expressly() "{{{
  let arg = {}
  let arg.command = 'pull'
  let arg.repository = giti#input("repository: ")
  let arg.refspec    = giti#input("refspec: ")
  return s:run(arg)
endfunction "}}}

" local functions {{{

function! s:run(param) "{{{
  return giti#system_with_specifics({
\   'command' : printf('%s %s %s',
\     exists('a:param.command')    ? a:param.command    : '',
\     exists('a:param.repository') ? a:param.repository : '',
\     exists('a:param.refspec')    ? a:param.refspec    : '',
\   ),
\   'with_confirm' : 1,
\ })
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
