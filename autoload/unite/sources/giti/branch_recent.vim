" File:    branch_recent.vim
" Author:  Fumihiro Ito <fmhrit@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#branch_recent#define() "{{{
  return [s:source, unite#sources#giti#branch#new#define()]
endfunction "}}}

let s:source = {
\ 'name' : 'giti/branch_recent',
\ 'description' : 'display recent changed branches',
\}

function! s:source.gather_candidates(args, context) "{{{
  call unite#print_message('[giti/branch_recent]')
  return map(giti#branch_recent#recent(), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : v:val.name,
\   "action__is_new" : 0,
\ }')
endfunction "}}}

function! s:source.change_candidates(args, context) "{{{
  if !strlen(a:context.input)
    return []
  endif
  return [{
\   "word"   : "[new branch] " . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : a:context.input,
\   "action__is_new" : 1,
\ }, {
\   "word"   : "[checkout branch] " . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : a:context.input,
\   "action__is_new" : 0,
\ }]
endfunction "}}}

" local functions {{{
let s:word_format = '%s(%s) %s| %s'
function! s:build_word(val) "{{{
  return printf(s:word_format,
\   a:val.name,
\   a:val.objectname,
\   a:val.relativedate,
\   a:val.message)
endfunction "}}}

" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#branch_recent#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
