" File:    stash.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:pretty_format = "::%gd::%H::%an<%ae>[%ad]::%cn<%ce>[%cd]::%s"
" }}}

function! giti#stash#list()"{{{
  return giti#system('stash list')
endfunction"}}}

function! giti#stash#built_list()"{{{
  return map(split(giti#system(
\   printf('stash list --date=relative --pretty=format:"%s"',
\          s:pretty_format)
\ ), '\n'), '
\   s:build_data(v:val)
\ ')
endfunction"}}}

function! giti#stash#show(param)"{{{
  let stash = has_key(a:param, 'stash') ? a:param.stash : ''
  return giti#system('stash show ' . stash)
endfunction"}}}

function! giti#stash#drop(param)"{{{
  let stash = has_key(a:param, 'stash') ? a:param.stash : ''
  return giti#system('stash drop ' . stash)
endfunction"}}}

function! giti#stash#pop(param)"{{{
  let stash = has_key(a:param, 'stash') ? a:param.stash : ''
  return giti#system('stash pop ' . stash)
endfunction"}}}

function! giti#stash#apply(param)"{{{
  let stash = has_key(a:param, 'stash') ? a:param.stash : ''
  return giti#system('stash apply ' . stash)
endfunction"}}}

function! giti#stash#branch(param)"{{{
  if !has_key(a:param, 'branchname')
    throw 'branchname required'
  endif
  let branchname = a:param.branchname
  let stash = has_key(a:param, 'stash') ? a:param.stash : ''
  return giti#system(printf('stash branch %s %s', branchname, stash))
endfunction"}}}

function! giti#stash#clear()"{{{
  return giti#system('stash clear')
endfunction"}}}

" local functions {{{
function! s:build_data(line)"{{{
  let splited = split(a:line, '::')

  return {
\   'stash'       : remove(splited, 0),
\   'hash'        : remove(splited, 0),
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
