" File:    remote.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#remote#define() "{{{
  return s:source
endfunction "}}}

let s:source = {
\ 'name' : 'giti/remote',
\ 'description' : 'disp remotes',
\}

function! s:source.gather_candidates(args, context) "{{{
  call unite#print_message('[giti/remote]')
  return map(giti#remote#show(), '{
\   "word" : v:val,
\   "source" : s:source.name,
\   "kind"   : "giti/remote",
\   "action__name" : v:val,
\ }')
endfunction "}}}

function! s:source.change_candidates(args, context) "{{{
  if !strlen(a:context.input)
    return []
  endif
  return [{
\   "word"   : "[add new remote] " . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/remote",
\   "action__name" : a:context.input,
\   "action__is_new" : 1,
\ }]
endfunction "}}}

" local functions {{{
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#remote#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
