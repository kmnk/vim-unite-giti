" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#log#define()"{{{
  return s:source
endfunction"}}}

let s:source = {
\ 'name' : 'giti/log',
\ 'description' : 'disp logs',
\}

function! s:source.gather_candidates(args, context)"{{{
  call unite#print_message('[giti/log] ' . s:build_title())
  let file = ''
  if len(a:args) > 0
    let file = a:args[0]
  endif
  let line_count = ''
  if len(a:args) == 2
    let line_count = a:args[1]
  endif
  return map(giti#log#list(line_count, file), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/log",
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

