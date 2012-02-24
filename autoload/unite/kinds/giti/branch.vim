" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#branch#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
\ 'name' : 'giti/branch',
\ 'default_action' : 'switch',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.run = {
\ 'description' : 'switch or create branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.run.func(candidate)"{{{
  if a:candidate.action__is_new
    return giti#checkout#create(a:candidate.action__name)
  else
    return giti#checkout#switch(a:candidate.action__name)
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
  return giti#branch#delete(a:candidate.action__name)
endfunction"}}}
let s:kind.alias_table.rm = 'delete'

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

