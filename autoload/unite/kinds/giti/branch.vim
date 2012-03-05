" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#branch#define()"{{{
  return [s:kind, unite#kinds#giti#branch#new#define()]
endfunction"}}}

let s:kind = {
\ 'name' : 'giti/branch',
\ 'default_action' : 'run',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.run = {
\ 'description' : 'switch branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.run.func(candidate)"{{{
  if a:candidate.action__is_new
    let context = unite#get_context()
    let context.input = ''
    call unite#start([['giti/branch/new', a:candidate.action__name]], context)
  else
    let res = giti#checkout#switch(a:candidate.action__name)
    if !v:shell_error
      echoerr res
    else
      echo res
    endif
  endif
endfunction"}}}
let s:kind.alias_table.switch = 'run'
let s:kind.alias_table.sw = 'run'
let s:kind.alias_table.new = 'run'

let s:kind.action_table.delete = {
\ 'description' : 'delete this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete.func(candidate)"{{{
  let res = giti#branch#delete(a:candidate.action__name)
  if !v:shell_error
    echoerr res
  else
    echo res
  endif
endfunction"}}}
let s:kind.alias_table.rm = 'delete'

let s:kind.action_table.delete_force = {
\ 'description' : 'delete force this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete_force.func(candidate)"{{{
  let res = giti#branch#delete_force(a:candidate.action__name)
  if !v:shell_error
    echoerr res
  else
    echo res
  endif
endfunction"}}}

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

