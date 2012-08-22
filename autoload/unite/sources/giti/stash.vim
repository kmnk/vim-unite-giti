" File:    stash.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: 

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#stash#define()"{{{
  return s:source
endfunction"}}}

let s:source = {
\ 'name' : 'giti/stash',
\ 'description' : 'manage stash',
\}

function! s:source.gather_candidates(args, context)"{{{
  call unite#print_message('[giti/stash]')
  return map(giti#stash#built_list(), '{
\   "word"   : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : s:source.name,
\   "action__data" : v:val,
\ }')
endfunction"}}}

" local functions {{{
let s:word_format = '%s - %s, %s : %s'
function! s:build_word(val)"{{{
  return printf(s:word_format,
\   a:val.hash[0:6],
\   a:val.author.name,
\   a:val.author.date,
\   a:val.comment
\ )
endfunction"}}}
function! s:build_title()"{{{
  return printf(s:word_format,
\   'hash',
\   'author',
\   'relative date',
\   'comment')
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
