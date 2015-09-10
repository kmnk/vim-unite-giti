" File:    new.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#branch#new#define() "{{{
  return s:kind
endfunction "}}}

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
function! s:kind.action_table.run.func(candidate) "{{{
  let arg = { 'name' : a:candidate.action__name }
  if a:candidate.action__start_point != ''
    let arg.start_point = a:candidate.action__start_point
  endif
  call giti#print(giti#checkout#create(arg))
endfunction "}}}
let s:kind.alias_table.create = 'run'
let s:kind.alias_table.new = 'run'

let s:kind.action_table.create_tracking = {
\ 'description' : 'create new remote tracking branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.create_tracking.func(candidate) "{{{
  let arg = {
\   'name' : a:candidate.action__name,
\   'track' : 1,
\ }
  if a:candidate.action__start_point != ''
    let arg.start_point = a:candidate.action__start_point
  endif
  call giti#print(giti#checkout#create(arg))
endfunction "}}}
let s:kind.alias_table.cot = 'create_tracking'

let s:kind.action_table.create_no_tracking = {
\ 'description' : 'create new not remote tracking branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.create_no_tracking.func(candidate) "{{{
  let arg = {
\   'name' : a:candidate.action__name,
\   'track' : 0,
\ }
  if a:candidate.action__start_point != ''
    let arg.start_point = a:candidate.action__start_point
  endif
  call giti#print(giti#checkout#create(arg))
endfunction "}}}
let s:kind.alias_table.con = 'create_no_tracking'

" }}}

" local functions {{{
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#branch#new#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
