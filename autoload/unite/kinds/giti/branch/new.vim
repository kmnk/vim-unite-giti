" File:    new.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#branch#new#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
\ 'name' : 'giti/branch/new',
\ 'default_action' : 'run',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.run = {
\ 'description' : 'create new branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.run.func(candidate)"{{{
  let arg = { 'name' : a:candidate.action__name }
  if a:candidate.action__start_point != ''
    let arg.start_point = a:candidate.action__start_point
  endif
  echo giti#checkout#create(arg)
endfunction"}}}
let s:kind.alias_table.create = 'run'
let s:kind.alias_table.new = 'run'

let s:kind.action_table.checkout = {
\ 'description' : 'checkout branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.checkout.func(candidate)"{{{
  echo giti#checkout#switch(a:candiddate.action__name)
endfunction"}}}
let s:kind.alias_table.co = 'checkout'

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
