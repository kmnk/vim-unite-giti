" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#branch#define()"{{{
  return s:source
endfunction"}}}

let s:source = {
\ 'name' : 'giti/branch',
\ 'description' : 'disp branches',
\}

function! s:source.gather_candidates(args, context)"{{{
  call unite#print_message('[giti/branch]')
  return extend(map(giti#branch#list(), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : ["jump_list"],
\   "action__path" : v:val.name,
\   "action__line" : 1,
\ }'), [{
\   "word" : "(execute other action)",
\   "source" : s:source.name,
\   "kind"   : "jump_list",
\   "action__path" : "./",
\   "action__line" : 1,
\ }])
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
