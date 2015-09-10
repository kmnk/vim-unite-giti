" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#log#define() "{{{
  return s:kind
endfunction "}}}

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
function! s:kind.action_table.view.func(candidate) "{{{
  if s:is_graph_only_line(a:candidate)
    call giti#print('graph only line')
    return
  endif

  let data = a:candidate.action__data
  call giti#print(       'Hash:       ' . data.hash)
  call giti#print(       'ParentHash: ' . data.parent_hash)
  call giti#print(printf('Author:     %s <%s> - %s',
\                        data.author.name, data.author.mail, data.author.date))
  call giti#print(printf('Committer:  %s <%s> - %s',
\                        data.committer.name, data.committer.mail, data.committer.date))
  call giti#print(       'Subject:    ' . data.subject)
endfunction "}}}

let s:kind.action_table.diff = {
\ 'description' : 'git diff',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.diff.func(candidates) "{{{
  if s:is_graph_only_line(a:candidates[0])
\ || len(a:candidates) > 1 && s:is_graph_only_line(a:candidates[1])
    call giti#print('graph only line')
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
    call giti#print('no difference')
    return
  endif

  return giti#new_buffer({
\   'method'   : giti#edit_command(),
\   'string'   : diff,
\   'filetype' : 'diff',
\   'buftype'  : 'nofile',
\ })
endfunction "}}}
let s:kind.alias_table.di = 'diff'

let s:kind.action_table.revert = {
\ 'description' : 'git revert this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.revert.func(candidate) "{{{
  if s:is_graph_only_line(a:candidate)
    call giti#print('graph only line')
    return
  endif

  call giti#revert#run([a:candidate.action__data.hash])
endfunction "}}}

let s:kind.action_table.vimdiff = {
\ 'description' : 'git diff by vimdiff',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.vimdiff.func(candidates) "{{{
  if s:is_graph_only_line(a:candidates[0])
\ || len(a:candidates) > 1 && s:is_graph_only_line(a:candidates[1])
    call giti#print('graph only line')
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
endfunction "}}}
let s:kind.alias_table.vdi = 'vimdiff'

let s:kind.action_table.reset = {
\ 'description' : 'git reset this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.reset.func(candidate) "{{{
  if s:is_graph_only_line(a:candidate)
    call giti#print('graph only line')
    return
  endif

  call giti#reset#reset({'hash' : a:candidate.action__data.hash})
endfunction "}}}

let s:kind.action_table.reset_hard = {
\ 'description' : 'git reset --hard this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.reset_hard.func(candidate) "{{{
  if s:is_graph_only_line(a:candidate)
    call giti#print('graph only line')
    return
  endif

  call giti#reset#hard({'hash' : a:candidate.action__data.hash})
endfunction "}}}

let s:kind.action_table.yank_hash = {
\ 'description' : 'yank hash of this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.yank_hash.func(candidate) "{{{
  let @" = a:candidate.action__data.hash
endfunction "}}}

let s:kind.action_table.changed_files = {
\ 'description' : 'show changed files',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.changed_files.func(candidates) "{{{
  if s:is_graph_only_line(a:candidates[0])
\ || len(a:candidates) > 1 && s:is_graph_only_line(a:candidates[1])
    call giti#print('graph only line')
    return
  endif

  let from  = ''
  let to    = ''
  if len(a:candidates) == 1
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[0].action__data.parent_hash
  elseif len(a:candidates) == 2
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[1].action__data.hash
  else
    call unite#print_error('too many commits selected')
  endif

  let context = unite#get_context()
  let context.input = ''
  return unite#start([['giti/diff_tree/changed_files', from, to]], context)
endfunction "}}}

" }}}

" local functions {{{
function! s:is_graph_only_line(candidate) "{{{
  return has_key(a:candidate.action__data, 'hash') ? 0 : 1
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#log#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
