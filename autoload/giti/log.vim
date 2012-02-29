" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:default_line_count = 3
let s:pretty_format = "%H:%P:%an<%ae>[%ad]:%cn<%ce>[%cd]:%s"
" }}}

function! giti#log#run(...)"{{{
  return giti#system(
\   printf('log -%d ', s:default_line_count) .
\   len(a:000) > 0 ? a:1 : ''
\ )
endfunction"}}}

function! giti#log#full(...)"{{{
  return giti#system('log ' . len(a:000) > 0 ? a:1 : '')
endfunction"}}}

function! giti#log#list(...)"{{{
  return map(
\   s:get_list(
\     len(a:000) > 0  ? a:1 : s:default_line_count,
\     len(a:000) == 2 ? a:2 : ''
\   ),
\   's:build_log_data(v:val)'
\ )
endfunction"}}}

" local functions {{{

function! s:get_list(line_count, file)"{{{
  let res = giti#system(printf(
\   'log -%d --date=short --pretty=format:"%s" %s',
\   a:line_count, s:pretty_format, a:file
\ ))
  if v:shell_error
    echoerr res
    return []
  endif
  return split(res, '\n')
endfunction"}}}

function! s:build_log_data(line)"{{{
  let matches
\   = matchlist(a:line, '^\(.\+\):\(.\+\):\(.\+\):\(.\+\):\(.\+\)$')
  return {
\   'hash'        : matches[1],
\   'parent_hash' : matches[2],
\   'author'      : s:build_user_data(matches[3]),
\   'committer'   : s:build_user_data(matches[4]),
\   'comment'     : matches[5],
\ }
endfunction"}}}

function! s:build_user_data(line)"{{{
  let matches
\   = matchlist(a:line, '^\(.\+\)<\(.\+\)>\[\(.\+\)\]$')
  return {
\   'name' : matches[1],
\   'mail' : matches[2],
\   'date' : matches[3],
\ }
endfunction"}}}

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
