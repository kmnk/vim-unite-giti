" File:    branch_all.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#branch_all#define() "{{{
  return [s:source, unite#sources#giti#branch#new#define()]
endfunction "}}}

let s:source = {
\ 'name' : 'giti/branch_all',
\ 'description' : 'disp all branches',
\}

function! s:source.gather_candidates(args, context) "{{{
  call unite#print_message('[giti/branch_all]')
  return map(sort(giti#branch#list_all(), 's:sort_by_is_current'), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : v:val.name,
\   "action__is_new" : 0,
\ }')
endfunction "}}}

function! s:source.change_candidates(args, context) "{{{
  let g:candidates = a:context
  if !strlen(a:context.input)
    return []
  endif
  let current_branch = filter(copy(g:candidates.source.unite__cached_candidates), 'v:val.word =~ "^\*"')[0].action__name
  return [{
\   "word"   : "[new branch] " . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : a:context.input,
\   "action__is_new" : 1,
\ }, {
\   "word"   : "[checkout branch from " . current_branch . "] " . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/branch/new",
\   "action__name" : a:context.input,
\   "action__start_point" : current_branch,
\   "action__is_new" : 0,
\ }
\ ]
endfunction "}}}

" local functions {{{
let s:word_format = '% 1s %s'
function! s:build_word(val) "{{{
  return printf(s:word_format,
\   a:val.is_current ? '*' : '',
\   a:val.full_name,
\ )
endfunction "}}}

function! s:sort_by_is_current(context1, context2) "{{{{
  return a:context1.is_current ? -1
\      : a:context2.is_current ? +1
\      :                         0
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#branch_all#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
