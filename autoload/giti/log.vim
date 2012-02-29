" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
if !exists('g:giti_log_default_count')
  let g:giti_log_default_line_count = 50
endif
let s:pretty_format = "%H::%P::%an<%ae>[%ad]::%cn<%ce>[%cd]::%s"
" }}}

function! giti#log#run(...)"{{{
  return giti#system(printf(
\   'log -%d %s',
\   g:giti_log_default_line_count,
\   a:0 > 0 ? a:1 : ''
\ ))
endfunction"}}}

function! giti#log#full(...)"{{{
  return giti#system(printf(
\   'log %s',
\   a:0 > 0 ? a:1 : ''
\ )
endfunction"}}}

function! giti#log#line(...)"{{{
  return giti#system(printf(
\   'log --pretty=oneline --graph %s',
\   a:0 > 0 ? a:1 : ''
\ ))
endfunction"}}}

function! giti#log#list(...)"{{{
  return map(
\   s:get_list(
\     a:0 > 0 && a:1 > 0 ? a:1 : g:giti_log_default_line_count,
\     a:0 == 2           ? a:2 : ''
\   ),
\   's:build_log_data(v:val)'
\ )
endfunction"}}}

" local functions {{{

function! s:get_list(line_count, file)"{{{
  let res = giti#system(printf(
\   'log -%d --date=relative --pretty=format:"%s" %s',
\   a:line_count, s:pretty_format, a:file
\ ))
  if v:shell_error
    echoerr res
    return []
  endif
  return split(res, '\n')
endfunction"}}}

function! s:build_log_data(line)"{{{
  let splited = split(a:line, '::')
  return {
\   'hash'        : remove(splited, 0),
\   'parent_hash' : remove(splited, 0),
\   'author'      : s:build_user_data(remove(splited, 0)),
\   'committer'   : s:build_user_data(remove(splited, 0)),
\   'comment'     : join(splited, ':'),
\ }
endfunction"}}}

function! s:build_user_data(line)"{{{
  let matches
\   = matchlist(a:line, '^\(.\+\)<\(.\+\)>\[\(.\+\)\]$')
  return {
\   'name' : matches[1],
\   'mail' : matches[2],
\   'date' : matches[3]
\ }
endfunction"}}}

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
