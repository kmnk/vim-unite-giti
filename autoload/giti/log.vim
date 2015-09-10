" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
if !exists('g:giti_log_default_line_count')
  let g:giti_log_default_line_count = 50
endif
let s:pretty_format = ":::%H:::%P:::%an<%ae>[%ad(%at)]:::%cn<%ce>[%cd(%at)]:::%s"
" }}}

function! giti#log#run(...) "{{{
  let file = a:0 > 0 ? a:1 : ''
  return giti#system(printf('log -%d -- %s',
\   g:giti_log_default_line_count, file
\ ))
endfunction "}}}

function! giti#log#full(...) "{{{
  let file = a:0 > 0 ? a:1 : ''
  return giti#system(printf('log -- %s', file))
endfunction "}}}

function! giti#log#line(...) "{{{
  let file = a:0 > 0 ? a:1 : ''
  return giti#system(printf('log --pretty=oneline --graph -- %s', file))
endfunction "}}}

function! giti#log#list(...) "{{{
  let param = a:0 > 0 ? a:1 : {}
  return map(s:get_list(param), '
\   s:build_log_data(v:val)
\ ')
endfunction "}}}

" local functions {{{

function! s:get_list(param) "{{{
  let line_count
\   = exists('a:param.line_count') && a:param.line_count > 0
\     ? a:param.line_count
\     : g:giti_log_default_line_count
  let file = exists('a:param.file') ? a:param.file : ''
  let res = giti#system(printf(
\   'log -%d --graph --date=default --pretty=format:"%s" %s',
\   line_count, s:pretty_format, file
\ ))
  if type(res) == 0
    " the operation has canceled
    return []
  endif
  return split(res, '\n')
endfunction "}}}

function! s:build_log_data(line) "{{{
  let splited = split(a:line, ':::')

  if 1 == len(splited)
    return {
\     'graph' : substitute(substitute(substitute(substitute(remove(splited, 0), '/', '//', 'g'), '\', '/', 'g'), '//', '\', 'g'), '_', '~', 'g'),
\   }
  endif

  return {
\   'graph'       : substitute(substitute(substitute(substitute(remove(splited, 0), '/', '//', 'g'), '\', '/', 'g'), '//', '\', 'g'), '_', '~', 'g'),
\   'hash'        : remove(splited, 0),
\   'parent_hash' : remove(splited, 0),
\   'author'      : s:build_user_data(remove(splited, 0)),
\   'committer'   : s:build_user_data(remove(splited, 0)),
\   'subject'     : remove(splited, 0),
\ }
endfunction "}}}

function! s:build_user_data(line) "{{{
  let matches
\   = matchlist(a:line, '^\(.\+\)<\(.\+\)>\[\(.\+\)(\(.\+\))]$')
  return {
\   'name' : matches[1],
\   'mail' : matches[2],
\   'date' : matches[3],
\   'time' : matches[4]
\ }
endfunction "}}}

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
