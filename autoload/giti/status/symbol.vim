" File:    symbol.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:symbol_to_name = {
\ ' ' : 'Unmodified',
\ 'M' : 'Modified',
\ 'A' : 'Added',
\ 'D' : 'Deleted',
\ 'R' : 'Renamed',
\ 'C' : 'Copied',
\ 'U' : 'Unmerged',
\ '?' : 'Untracked',
\}

let s:name_to_symbol = {}
for item in items(s:symbol_to_name)
  let s:name_to_symbol[item[1]] = item[0]
endfor
let g:hoge = s:name_to_symbol
" }}}

function! giti#status#symbol#name_of(symbol) "{{{
  if !has_key(s:symbol_to_name, a:symbol)
    throw 'Unknown symbol: ' . a:symbol
  endif
  return s:symbol_to_name[a:symbol]
endfunction "}}}

function! giti#status#symbol#symbol_of(name) "{{{
  if !has_key(s:name_to_symbol, a:name)
    throw 'Unknown name: ' . a:name
  endif
  return s:name_to_symbol[a:name]
endfunction "}}}

function! giti#status#symbol#is_valid_symbol(symbol) "{{{
  try
    call giti#status#symbol#name_of(a:symbol)
  catch /^Unknown symbol:/
    return 0
  endtry
  return 1
endfunction "}}}

function! giti#status#symbol#is_valid_name(name) "{{{
  try
    call giti#status#symbol#symbol_of(a:name)
  catch /^Unknown name:/
    return 0
  endtry
  return 1
endfunction "}}}

function! giti#status#symbol#is_unmodified(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Unmodified'
endfunction "}}}

function! giti#status#symbol#is_modified(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Modified'
endfunction "}}}

function! giti#status#symbol#is_added(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Added'
endfunction "}}}

function! giti#status#symbol#is_deleted(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Deleted'
endfunction "}}}

function! giti#status#symbol#is_renamed(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Renamed'
endfunction "}}}

function! giti#status#symbol#is_copied(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Copied'
endfunction "}}}

function! giti#status#symbol#is_unmerged(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Unmerged'
endfunction "}}}

function! giti#status#symbol#is_untracked(symbol) "{{{
  if !giti#status#symbol#is_valid_symbol(a:symbol)
    return 0
  endif
  return giti#status#symbol#name_of(a:symbol) == 'Untracked'
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
