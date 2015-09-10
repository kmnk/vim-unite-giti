" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#branch#define() "{{{
  return [s:kind, unite#kinds#giti#branch#new#define()]
endfunction "}}}

let s:kind = {
\ 'name' : 'giti/branch',
\ 'default_action' : 'run',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.run = {
\ 'description' : 'switch branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.run.func(candidate) "{{{
  if a:candidate.action__is_new
    let context = unite#get_context()
    let context.input = ''
    call unite#start([['giti/branch/new', a:candidate.action__name]], context)
  else
    call giti#print(giti#checkout#switch({'name' : a:candidate.action__name}))
  endif
endfunction "}}}
let s:kind.alias_table.switch = 'run'
let s:kind.alias_table.sw = 'run'
let s:kind.alias_table.new = 'run'

let s:kind.action_table.checkout_tracking = {
\ 'description' : 'checkout branch (tracking)',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.checkout_tracking.func(candidate) "{{{
  call giti#print(giti#checkout#switch({
\   'name' : a:candidate.action__name,
\   'track' : 1,
\ }))
endfunction "}}}
let s:kind.alias_table.cot = 'checkout_tracking'

let s:kind.action_table.checkout_no_tracking = {
\ 'description' : 'checkout branch (no tracking)',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.checkout_no_tracking.func(candidate) "{{{
  call giti#print(giti#checkout#switch({
\   'name' : a:candidate.action__name,
\   'track' : 0,
\ }))
endfunction "}}}
let s:kind.alias_table.con = 'checkout_no_tracking'

let s:kind.action_table.delete = {
\ 'description' : 'delete this branch',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete.func(candidates) "{{{
  let args = map(copy(a:candidates), '
\   {
\     "branch"     : v:val.action__name,
\     "repository" : s:get_repository(v:val.action__name),
\   }
\ ')

  call giti#print(giti#branch#delete(map(copy(args), 'v:val.branch')))
endfunction "}}}
let s:kind.alias_table.rm = 'delete'

let s:kind.action_table.delete_force = {
\ 'description' : 'delete force this branch',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete_force.func(candidates) "{{{
  let args = map(copy(a:candidates), '
\   {
\     "branch"     : v:val.action__name,
\     "repository" : s:get_repository(v:val.action__name),
\   }
\ ')

  call giti#print(giti#branch#delete_force(map(copy(args), 'v:val.branch')))
endfunction "}}}

let s:kind.action_table.delete_remote = {
\ 'description' : 'delete this branch and remote',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete_remote.func(candidates) "{{{
  let args = map(copy(a:candidates), '
\   {
\     "branch"     : v:val.action__name,
\     "repository" : s:get_repository(v:val.action__name),
\   }
\ ')

  call giti#print(giti#branch#delete(map(copy(args), 'v:val.branch')))

  call s:handle_delete_remote(args)
endfunction "}}}

let s:kind.action_table.delete_remote_force = {
\ 'description' : 'delete force this branch and remote',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete_remote_force.func(candidates) "{{{
  let args = map(copy(a:candidates), '
\   {
\     "branch"     : v:val.action__name,
\     "repository" : s:get_repository(v:val.action__name),
\   }
\ ')

  call giti#print(giti#branch#delete_force(map(copy(args), 'v:val.branch')))

  call s:handle_delete_remote(args)
endfunction "}}}

let s:kind.action_table.merge = {
\ 'description' : 'merge this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.merge.func(candidate) "{{{
  call giti#print(giti#merge#run({ 'branch_name' : a:candidate.action__name }))
endfunction "}}}

let s:kind.action_table.merge_squash = {
\ 'description' : 'merge squash this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.merge_squash.func(candidate) "{{{
  call giti#print(giti#merge#run({ 'branch_name' : a:candidate.action__name, 'squash' : 1 }))
endfunction "}}}

let s:kind.action_table.merge_no_ff = {
\ 'description' : 'no fast forward merge this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.merge_no_ff.func(candidate) "{{{
  call giti#print(giti#merge#run({ 'branch_name' : a:candidate.action__name, 'no_ff' : 1 }))
endfunction "}}}

let s:kind.action_table.rebase = {
\ 'description' : 'rebase on this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.rebase.func(candidate) "{{{
  call giti#print(giti#rebase#run({ 'upstream' : a:candidate.action__name }))
endfunction "}}}

let s:kind.action_table.rebase_interactive = {
\ 'description' : 'rebase interactive on this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.rebase_interactive.func(candidate) "{{{
  call giti#print(giti#rebase#interactive({ 'upstream' : a:candidate.action__name }))
endfunction "}}}

" }}}

" local functions {{{
function! s:is_deleting_remote_confirmed(params) "{{{
  return giti#input('delete remote branches ? [y/n] : ') == 'y' ? 1 : 0
endfunction "}}}

function! s:get_repository(branch) "{{{
  return giti#config#read({
\   'location' : 'local',
\   'key'      : printf('branch.%s.remote', a:branch)
\ })
endfunction "}}}

function! s:handle_delete_remote(params) "{{{
  if len(a:params) > 0 && !giti#has_shell_error()
    let result = s:delete_remote(a:params)
    if type(result) == type([])
      for output in result
        call giti#print(output ? output : 'some error occured')
      endfor
    else
      call giti#print(result)
    endif
  endif
endfunction "}}}

function! s:delete_remote(params) "{{{
  if s:is_deleting_remote_confirmed(a:params)
    return giti#branch#delete_remote(a:params)
  else
    return 'canceled'
  endif
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#branch#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

