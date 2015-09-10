" File:    pull_request.vim
" Author:  alpaca-tc <alprhcp666@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#pull_request#define() "{{{
  return s:kind
endfunction "}}}

let s:kind = {
\ 'name' : 'giti/pull_request',
\ 'default_action' : 'run',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.run = {
\ 'description' : 'select head repository',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.run.func(candidate) "{{{
  let context = unite#get_context()
  let context.input = ''

  let base_repo = a:candidate.action__base_repo
  let head_repo = a:candidate.action__head_repo

  if empty(base_repo)
    call unite#start([['giti/pull_request/base', head_repo]], context)
  elseif empty(head_repo)
    call unite#start([['giti/pull_request/head', base_repo]], context)
  else
    call giti#pull_request#run(base_repo, head_repo)
  endif
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#pull_request#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

