" File:    config.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#config#define() "{{{
  return s:source
endfunction "}}}

let s:source = {
\ 'name' : 'giti/config',
\ 'description' : 'disp config list',
\}

function! s:source.gather_candidates(args, context) "{{{
  call unite#print_message('[giti/config]')
  return map(giti#config#list(), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/config",
\   "action__key"      : v:val.key,
\   "action__location" : v:val.location,
\   "action__value"    : v:val.value,
\   "action__is_new"   : 0,
\ }')
endfunction "}}}

function! s:source.change_candidates(args, context)
  if !strlen(a:context.input)
    return []
  endif
  return [{
\   "word"   : "[new config]" . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/config",
\   "action__key"      : a:context.input,
\   "action__location" : '',
\   "action__value"    : '',
\   "action__is_new"   : 1,
\ }]
endfunction

" local functions {{{
let s:word_format = '%-8s %s = %s'
function! s:build_word(val) "{{{
  return printf(s:word_format,
\   '[' . a:val.location . ']',
\   a:val.key,
\   a:val.value)
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#config#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
