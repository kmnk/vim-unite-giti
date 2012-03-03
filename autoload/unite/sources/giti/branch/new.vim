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
  return add(map(giti#branch#list(), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/branch/new",
\   "action__name" : a:args[0],
\   "action__start_point" : v:val.name,
\ }'), {
\   "word" : "(no start point)",
\   "source" : s:source.name,
\   "kind"   : "giti/branch/new",
\   "action__name" : a:args[0],
\   "action__start_point" : '',
\ })
endfunction"}}}

" local functions {{{
let s:word_format = '%s %s'
function! s:build_word(val)"{{{
  return printf('%s %s',
\   a:val.name,
\   a:val.is_current ? '*current*' : '')
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

