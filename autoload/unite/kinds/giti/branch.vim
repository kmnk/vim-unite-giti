" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#branch#define()"{{{
  return [s:kind, unite#kinds#giti#branch#new#define()]
endfunction"}}}

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
function! s:kind.action_table.run.func(candidate)"{{{
  if a:candidate.action__is_new
    let context = unite#get_context()
    let context.input = ''
    call unite#start([['giti/branch/new', a:candidate.action__name]], context)
  else
    echo giti#checkout#switch(a:candidate.action__name)
  endif
endfunction"}}}
let s:kind.alias_table.switch = 'run'
let s:kind.alias_table.sw = 'run'
let s:kind.alias_table.new = 'run'

let s:kind.action_table.delete = {
\ 'description' : 'delete this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete.func(candidate)"{{{
  let branch = a:candidate.action__name
  let repository = s:get_repository(branch)

  echo giti#branch#delete(branch)

  if len(repository) > 0 && !v:shell_error
    echo s:delete_remote({
\     'repository' : repository,
\     'branch'     : branch,
\   })
  endif
endfunction"}}}
let s:kind.alias_table.rm = 'delete'

let s:kind.action_table.delete_force = {
\ 'description' : 'delete force this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\}
function! s:kind.action_table.delete_force.func(candidate)"{{{
  let branch = a:candidate.action__name
  let repository = s:get_repository(branch)

  echo giti#branch#delete_force(branch)

  if len(repository) > 0 && !v:shell_error
    echo s:delete_remote({
\     'repository' : repository,
\     'branch'     : branch,
\   })
  endif
endfunction"}}}

let s:kind.action_table.merge = {
\ 'description' : 'merge this branch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.merge.func(candidate)"{{{
  echo giti#merge#run({ 'branch_name' : a:candidate.action__name })
endfunction"}}}

" }}}

" local functions {{{
function! s:is_deleting_remote_confirmed(param)"{{{
  return input('delete remote branch "' . a:param.branch . '" ? [y/n] : ') == 'y' ? 1 : 0
endfunction"}}}

function! s:get_repository(branch)"{{{
  return giti#config#read({
\   'location' : 'local',
\   'key'      : printf('branch.%s.remote', a:branch)
\ })
endfunction"}}}

function! s:delete_remote(param)"{{{
  if s:is_deleting_remote_confirmed(a:param)
    return giti#branch#delete_remote(a:param)
  else
    return 'canceled'
  endif
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

