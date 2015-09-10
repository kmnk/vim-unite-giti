" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#define() "{{{
  let sources = []
  for command in s:get_commands()
    let source = call(s:to_define_func(command), [])
    if type({}) == type(source)
      call add(sources, source)
    elseif type([]) == type(source)
      call extend(sources, source)
    endif
    unlet source
  endfor
  return add(sources, s:source)
endfunction "}}}

let s:source = {
\ 'name' : 'giti',
\ 'description' : 'disp giti sources',
\}

function! s:source.gather_candidates(args, context) "{{{
  call unite#print_message('[giti] giti sources')
  return map(s:get_commands(), '{
\   "word"   : v:val,
\   "source" : s:source.name,
\   "kind"   : "source",
\   "action__source_name" : "giti/" . v:val,
\ }')
endfunction "}}}

" local functions {{{
function! s:get_commands() "{{{
  return map(
\   split(
\     globpath(&runtimepath, 'autoload/unite/sources/giti/*.vim'),
\     '\n'
\   ),
\   'fnamemodify(v:val, ":t:r")'
\ )
endfunction "}}}

function! s:to_define_func(command) "{{{
  return 'unite#sources#giti#' . a:command . '#define'
endfunction}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
