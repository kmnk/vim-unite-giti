" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#branch#define()"{{{
  return [s:source, unite#sources#giti#branch#new#define()]
endfunction"}}}

let s:source = {
\ 'name' : 'giti/branch',
\ 'description' : 'disp branches',
\}

function! s:source.gather_candidates(args, context)"{{{
  call unite#print_message('[giti/branch]')
  return map(giti#branch#list(), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : v:val.name,
\   "action__is_new" : 0,
\ }')
endfunction"}}}

function! s:source.change_candidates(args, context)
  if !strlen(a:context.input)
    return []
  endif
  return [{
\   "word"   : "[new branch]" . a:context.input,
\   "source" : s:source.name,
\   "kind"   : "giti/branch",
\   "action__name" : a:context.input,
\   "action__is_new" : 1,
\ }]
endfunction

" local functions {{{
let s:word_format = '% 1s%s'
function! s:build_word(val)"{{{
  return printf('%s %s',
\   a:val.is_current ? '*' : '',
\   a:val.name)
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
