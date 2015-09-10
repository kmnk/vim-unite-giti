" File:    push.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#push#run(param) "{{{
  let arg = a:param
  let arg.command = 'push'
  return s:run(arg)
endfunction "}}}

function! giti#push#set_upstream(param) "{{{
  let arg = a:param
  let arg.command = 'push -u'
  return s:run(arg)
endfunction "}}}

function! giti#push#delete_remote_branch(param) abort "{{{
  if !has_key(a:param, 'branch') || len(a:param.branch) <= 0
    throw 'branch required'
  endif

  let arg = a:param
  let arg.command = 'push'
  let arg.refspec = ':' . a:param.branch

  return s:run(arg)
endfunction "}}}

function! giti#push#expressly() "{{{
  let arg = {}
  let arg.command = 'push'
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
