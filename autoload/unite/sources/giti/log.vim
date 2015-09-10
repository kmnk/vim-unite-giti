" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#log#define() "{{{
  return s:source
endfunction "}}}

let s:source = {
\ 'name' : 'giti/log',
\ 'description' : 'disp logs',
\}

function! s:source.gather_candidates(args, context) "{{{
  call unite#print_message('[giti/log] ' . s:build_title())
  let file = ''
  if len(a:args) > 0
    let file = a:args[0]
  endif
  let line_count = ''
  if len(a:args) == 2
    let line_count = a:args[1]
  endif
  return map(giti#log#list({'file' : file, 'line_count' : line_count}), '{
\   "word" : s:build_word(v:val),
\   "source" : s:source.name,
\   "kind"   : "giti/log",
\   "action__data" : v:val,
\   "action__file" : file,
\ }')
endfunction "}}}

" local functions {{{
let s:word_format = '%-16s %s %- 20s %s'
function! s:build_word(val) "{{{
  if !has_key(a:val, 'hash') || len(a:val.hash) <= 0
    return printf(s:word_format,
\     '',
\     a:val.graph,
\     '',
\     '',
\   )
  endif

  return printf(s:word_format,
\   strftime('%Y/%m/%d %H:%M', a:val.author.time),
\   a:val.graph,
\   strlen(a:val.author.name) >= 20 ? a:val.author.name[0:18] . '~' : a:val.author.name,
\   a:val.subject,
\ )
endfunction "}}}
function! s:build_title() "{{{
  return printf(s:word_format,
\   'date',
\   '',
\   'author',
\   'subject',
\ )
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#log#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

