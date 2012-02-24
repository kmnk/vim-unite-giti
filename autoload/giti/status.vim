" File:    status.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:symbol_meaning = {
\ ' ' : 'Unmodified',
\ 'M' : 'Modified',
\ 'A' : 'Added',
\ 'D' : 'Deleted',
\ 'R' : 'Renamed',
\ 'C' : 'Copied',
\ 'U' : 'Unmerged',
\ '?' : 'Untracked',
\}
" }}}

function! giti#status#run()"{{{
  call giti#status#list()
endfunction"}}}

function! giti#status#list()"{{{
  return map(
\   split(giti#system('status -s'), '\n'),
\   's:build_status_data(v:val)'
\ )
endfunction"}}}

" local functions {{{

function! s:build_status_data(line)"{{{
  let matches = matchlist(a:line, '^\(.\)\(.\)\s*\(.\+\)$')
  return {
\   'path'  : matches[3],
\   'index' : s:get_symbol_meaning(matches[1]),
\   'work'  : s:get_symbol_meaning(matches[2]),
\ }
endfunction"}}}

function! s:get_symbol_meaning(symbol)"{{{
  if !exists('s:symbol_meaning["' . a:symbol . '"]')
    return 'Unknown'
  endif
  return s:symbol_meaning[a:symbol]
endfunction"}}}


" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
