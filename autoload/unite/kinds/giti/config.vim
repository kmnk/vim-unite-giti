" File:    config.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#config#define() "{{{
  return s:kind
endfunction "}}}

let s:kind = {
\ 'name' : 'giti/config',
\ 'default_action' : 'run',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.yank_value = {
\ 'description' : 'yank selected config value',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.yank_value.func(candidate) "{{{
  if a:candidate.action__is_new
    return s:create_new_config(a:candidate)
  else
    call giti#print('yanked ' . a:candidate.action__key)
    let @" = a:candidate.action__value
    return
  endif
endfunction "}}}
let s:kind.alias_table.run = 'yank_value'

let s:kind.action_table.write = {
\ 'description' : 'write this config value',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.write.func(candidate) "{{{
  let location = s:get_location(a:candidate.action__location)
  call giti#print(printf('write "%s" on %s', a:candidate.action__key, location))
  call giti#print(printf('current value: %s', a:candidate.action__value))
  let value = giti#input('new value: ', a:candidate.action__value)
  let res = giti#config#write({
\   'key'      : a:candidate.action__key,
\   'value'    : value,
\   'location' : location,
\ })
endfunction "}}}

let s:kind.action_table.remove = {
\ 'description' : 'remove this config',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.remove.func(candidates) "{{{
  for candidate in a:candidates
    let location = s:get_location(candidate.action__location)
    let res = giti#config#remove({
\     'key'      : candidate.action__key,
\     'location' : location,
\   })
  endfor
endfunction "}}}

" }}}

" local functions {{{
function! s:get_location(location) "{{{
  let default = 'local'
  return giti#config#is_valid_location(a:location) ? a:location
\                                                  : default
endfunction "}}}

function! s:create_new_config(candidate) "{{{
  call giti#print('create new config "' . a:candidate.action__key . '"')
  let location = s:get_location(giti#input('location(default is "local") : '))
  let value    = giti#input('value : ')
  let res = giti#config#add({
\   'key'      : a:candidate.action__key,
\   'value'    : value,
\   'location' : location,
\ })
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#config#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

