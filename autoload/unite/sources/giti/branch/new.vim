" File:    new.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#branch#new#define()"{{{
  return s:source
endfunction"}}}

let s:source = {
\ 'name' : 'giti/branch/new',
\ 'description' : 'create new branch',
\}

function! s:source.gather_candidates(args, context)"{{{
  call unite#print_message(printf(
\   '[giti/branch/new] choose start point of new branch "%s"',
\   a:args[0]))
  return map(giti#branch#list(), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/branch/new",
\   "action__name" : a:args[0],
\   "action__start_point" : v:val.name,
\ }')
endfunction"}}}

function! s:source.change_candidates(args, context)"{{{
  if !strlen(a:context.input)
    return []
  endif
  return [{
\   "word"   : "[input start point] " . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/branch/new",
\   "action__name" : a:args[0],
\   "action__start_point" : a:context.input,
\ }]
endfunction"}}}

" local functions {{{
let s:word_format = '% 1s %s'
function! s:build_word(val)"{{{
  return printf(s:word_format,
\   a:val.is_current ? '*' : '',
\   a:val.name)
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

