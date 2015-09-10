" File:    remote.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#remote#define() "{{{
  return s:kind
endfunction "}}}

let s:kind = {
\ 'name' : 'giti/remote',
\ 'default_action' : 'run',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

let s:kind.action_table.run = {
\ 'description' : 'fetch this remote',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.run.func(candidate) "{{{
  if has_key(a:candidate, 'action__is_new') && a:candidate.action__is_new
    let context = unite#get_context()
    let context.input = ''
    let arg = {'name' : a:candidate.action__name}

    let arg.url = giti#input('url: ')

    call giti#print(giti#remote#add(arg))
  else
    call giti#print(giti#fetch#run({'repository' : a:candidate.action__name}))
  endif
endfunction "}}}
let s:kind.alias_table.fetch = 'run'
let s:kind.alias_table.default = 'run'

let s:kind.action_table.rm = {
\ 'description' : 'remove this remote',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.rm.func(candidate) "{{{
  call giti#print(giti#remote#rm(a:candidate.action__name))
endfunction "}}}
let s:kind.alias_table.delete = 'rm'

let s:kind.action_table.rename = {
\ 'description' : 'rename this remote',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.rename.func(candidate) "{{{
  let arg = {'old' : a:candidate.action__name}
  let arg.new = giti#input('new name: ', a:candidate.action__name)
  call giti#print(giti#remote#rename(arg))
endfunction "}}}
"let s:kind.alias_table.alias_action = 'rename'

" local functions {{{
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#remote#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
