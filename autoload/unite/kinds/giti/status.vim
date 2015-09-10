" File:    status.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#status#define() "{{{
  return s:kind
endfunction "}}}

let s:kind = {
\ 'name' : 'giti/status',
\ 'default_action' : 'open',
\ 'action_table' : {},
\ 'alias_table' : {},
\ 'parents' : ['file'],
\}

" actions {{{
let s:kind.action_table.add = {
\ 'description' : 'add selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.add.func(candidates) "{{{
  return giti#add#run(map(copy(a:candidates), 'v:val.action__path'))
endfunction "}}}
let s:kind.alias_table.stage = 'add'

let s:kind.action_table.add_patch = {
\ 'description' : 'add -p selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.add_patch.func(candidates) "{{{
  return giti#add#patch(map(copy(a:candidates), 'v:val.action__path'))
endfunction "}}}

let s:kind.action_table.reset_head = {
\ 'description' : "reset selected files' Index to HEAD",
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.reset_head.func(candidates) "{{{
  return giti#reset#head({'files' : map(copy(a:candidates), 'v:val.action__path')})
endfunction "}}}
let s:kind.alias_table.reset = 'reset_head'
let s:kind.alias_table.undo = 'reset_head'
let s:kind.alias_table.unstage = 'reset_head'

let s:kind.action_table.commit = {
\ 'description' : 'commit selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.commit.func(candidates) "{{{
  let files = []
  for candidate in a:candidates
    for path in candidate.action__paths
      call add(files, path)
    endfor
  endfor
  return giti#commit#run(files)
endfunction "}}}
let s:kind.alias_table.ci = 'commit'

let s:kind.action_table.amend = {
\ 'description' : 'amend selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.amend.func(candidates) "{{{
  let files = []
  for candidate in a:candidates
    for path in candidate.action__paths
      call add(files, path)
    endfor
  endfor
  return giti#commit#amend(files)
endfunction "}}}

let s:kind.action_table.checkout = {
\ 'description' : 'discard unstaged changes of selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.checkout.func(candidates) "{{{
  return giti#checkout#run(map(copy(a:candidates), 'v:val.action__path'))
endfunction "}}}

let s:kind.action_table.diff = {
\ 'description' : 'diff selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.diff.func(candidates) "{{{
  let diff = giti#diff#run({'files' : map(copy(a:candidates), 'v:val.action__path')})
  call giti#diff#view_git_diff(diff)
endfunction "}}}
let s:kind.alias_table.di = 'diff'

let s:kind.action_table.diff_cached = {
\ 'description' : 'diff --cached selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.diff_cached.func(candidates) "{{{
  let diff = giti#diff#cached({'files' : map(copy(a:candidates), 'v:val.action__path')})
  call giti#diff#view_git_diff(diff)
endfunction "}}}
let s:kind.alias_table.dic = 'diff_cached'

let s:kind.action_table.diff_head = {
\ 'description' : 'diff HEAD selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.diff_head.func(candidates) "{{{
  let diff = giti#diff#head({'files' : map(copy(a:candidates), 'v:val.action__path')})
  call giti#diff#view_git_diff(diff)
endfunction "}}}
let s:kind.alias_table.dih = 'diff_head'

let s:kind.action_table.vimdiff_head = {
\ 'description' : 'diff HEAD selected file by vimdiff',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.vimdiff_head.func(candidate) "{{{
  call giti#diff#view_vim_diff({
\   'file' : a:candidate.action__path,
\   'from' : 'HEAD',
\   'to'   : '',
\ })
endfunction "}}}
let s:kind.alias_table.vdih = 'vimdiff_head'
let s:kind.alias_table.vdi  = 'vimdiff_head'

let s:kind.action_table.rm_cached = {
\ 'description' : 'rm --cached selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.rm_cached.func(candidates) "{{{
  return giti#rm#cached({'files' : map(copy(a:candidates), 'v:val.action__path')})
endfunction "}}}
let s:kind.alias_table.rmc = 'rm_cached'

let s:kind.action_table.ignore = {
\ 'description' : 'ignore selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.ignore.func(candidates) "{{{
  call giti#add_ignore(
\   map(copy(a:candidates), '
\     fnamemodify(v:val.action__path, ":t")
\   ')
\ )
endfunction "}}}

" }}}

" local functions {{{
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#status#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
