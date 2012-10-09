" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#log#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
\ 'name' : 'giti/log',
\ 'default_action' : 'view',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.view = {
\ 'description' : 'view information of this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 0,
\}

function! s:format_body(body)
  let res = ""
  let first = 1
  for one_line in split(a:body, "\n")
    let space = first == 1 ? '' : '            '
    let res .= space . one_line . "\n"
    let first = 0
  endfor

  return res
endfunction

function! s:kind.action_table.view.func(candidate)"{{{
  if s:is_graph_only_line(a:candidate)
    echo 'graph only line'
    return
  endif

  let data      = a:candidate.action__data
  let log_hash  = data.hash . "^..." . data.hash
  let body      = giti#system(printf('log %s --pretty="%s"', log_hash, "%b"))
  let data.body = s:format_body(body)

  echo        'Hash:       ' . data.hash
  echo        'ParentHash: ' . data.parent_hash
  echo printf('Author:     %s <%s> - %s',
\       data.author.name, data.author.mail, data.author.date)
  echo printf('Committer:  %s <%s> - %s',
\       data.committer.name, data.committer.mail, data.committer.date)
  echo        'Comment:    ' . data.comment
  if data.body != ""
    echo      'Body:       ' . data.body
  endif
endfunction"}}}

let s:kind.action_table.diff = {
\ 'description' : 'git diff',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.diff.func(candidates)"{{{
  if s:is_graph_only_line(a:candidates[0])
\ || len(a:candidates) > 1 && s:is_graph_only_line(a:candidates[1])
    echo 'graph only line'
    return
  endif

  let from  = ''
  let to    = ''
  let files = [a:candidates[0].action__file]
  if len(a:candidates) == 1
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[0].action__data.parent_hash
  elseif len(a:candidates) == 2
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[1].action__data.hash
  else
    call unite#print_error('too many commits selected')
  endif
  let diff = giti#diff#specify({'from' : from, 'to' : to, 'files' : files})

  if !strlen(diff)
    echo 'no difference'
    return
  endif

  call giti#new_buffer({
\   'method'   : giti#edit_command(),
\   'string'   : diff,
\   'filetype' : 'diff',
\   'buftype'  : 'nofile',
\ })
endfunction"}}}
let s:kind.alias_table.di = 'diff'

let s:kind.action_table.revert = {
\ 'description' : 'git revert this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.revert.func(candidate)"{{{
  if s:is_graph_only_line(a:candidate)
    echo 'graph only line'
    return
  endif

  call giti#revert#run([a:candidate.action__data.hash])
endfunction"}}}

let s:kind.action_table.vimdiff = {
\ 'description' : 'git diff by vimdiff',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.vimdiff.func(candidates)"{{{
  if s:is_graph_only_line(a:candidates[0])
\ || len(a:candidates) > 1 && s:is_graph_only_line(a:candidates[1])
    echo 'graph only line'
    return
  endif

  let from  = ''
  let to    = ''
  let file  = len(a:candidates[0].action__file) > 0
\               ? a:candidates[0].action__file
\               : expand('%:p')
  let relative_path = giti#to_relative_path(file)
  if len(a:candidates) == 1
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[0].action__data.parent_hash
  elseif len(a:candidates) == 2
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[1].action__data.hash
  else
    call unite#print_error('too many commits selected')
  endif
  call giti#diff#view_vim_diff({
\   'file' : relative_path,
\   'from' : from,
\   'to'   : to,
\ })
endfunction"}}}
let s:kind.alias_table.vdi = 'vimdiff'

let s:kind.action_table.reset_hard = {
\ 'description' : 'git reset --hard this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.reset_hard.func(candidate)"{{{
  if s:is_graph_only_line(a:candidate)
    echo 'graph only line'
    return
  endif

  call giti#reset#hard({'hash' : a:candidate.action__data.hash})
endfunction"}}}
let s:kind.alias_table.reset_hard = 'reset'

" }}}

" local functions {{{
function! s:is_graph_only_line(candidate)"{{{
  return has_key(a:candidate.action__data, 'hash') ? 0 : 1
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
