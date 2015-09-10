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

function! giti#status#list() "{{{
  return map(s:get_list(), 's:build_status_data(v:val)')
endfunction "}}}

" local functions {{{

function! s:get_list()
  let res = giti#system('status -s')
  if type(res) == 0
    " the operation has canceled
    return []
  endif
  return split(res, '\n')
endfunction

function! s:build_status_data(line) "{{{
  let matches = matchlist(a:line, '^\(.\)\(.\)\s*\(.\+\)$')

  let index = matches[1]
  let work  = matches[2]

  let path1 = ''
  let path2 = ''
  if giti#status#symbol#is_renamed(index)
    let path_matches = matchlist(matches[3], '^\(.\+\)\s\+->\s\+\(.\+\)$')
    let path1 = path_matches[1]
    let path2 = path_matches[2]
  else
    let path1 = matches[3]
  endif

  return {
\   'description' : matches[3],
\   'path1' : path1,
\   'path2' : path2,
\   'index' : giti#status#symbol#name_of(index),
\   'work'  : giti#status#symbol#name_of(work),
\ }
endfunction "}}}

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
