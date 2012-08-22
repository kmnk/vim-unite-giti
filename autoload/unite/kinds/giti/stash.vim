" File:    stash.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: 

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#stash#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
\ 'name' : 'giti/stash',
\ 'default_action' : 'show',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

let s:kind.action_table.view = {
\ 'description' : 'view information of this stash',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.view.func(candidate)"{{{
  let data = a:candidate.action__data
  echo        'Hash:       ' . data.hash
  echo        'Stash:      ' . data.stash
  echo printf('Author:     %s <%s> - %s',
\       data.author.name, data.author.mail, data.author.date)
  echo printf('Committer:  %s <%s> - %s',
\       data.committer.name, data.committer.mail, data.committer.date)
  echo        'Comment:    ' . data.comment
endfunction"}}}

let s:kind.action_table.show = {
\ 'description' : 'show stash',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.show.func(candidate)"{{{
  let data = a:candidate.action__data
  echo giti#stash#show({'stash' : data.hash})
endfunction"}}}

let s:kind.action_table.patch = {
\ 'description' : 'show stash patch',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.patch.func(candidate)"{{{
  let data = a:candidate.action__data
  let patch = giti#stash#show({'stash' : data.hash, 'patch' : 1})

  if !strlen(patch)
    echo 'no patch'
    return
  endif

  call giti#new_buffer({
\   'method'   : giti#edit_command(),
\   'string'   : patch,
\   'filetype' : 'diff',
\   'buftype'  : 'nofile',
\ })
endfunction"}}}
let s:kind.alias_table.diff = 'patch'
let s:kind.alias_table.di = 'patch'

let s:kind.action_table.drop = {
\ 'description' : 'drop this stash',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.drop.func(candidate)"{{{
  let data = a:candidate.action__data
  echo giti#stash#drop({'stash' : data.hash})
endfunction"}}}

let s:kind.action_table.pop = {
\ 'description' : 'pop this stash (apply and drop)',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.pop.func(candidate)"{{{
  let data = a:candidate.action__data
  echo giti#stash#pop({'stash' : data.hash})
endfunction"}}}

let s:kind.action_table.apply = {
\ 'description' : 'apply this stash',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.apply.func(candidate)"{{{
  let data = a:candidate.action__data
  echo giti#stash#apply({'stash' : data.hash})
endfunction"}}}

let s:kind.action_table.branch = {
\ 'description' : 'make new branch with this stash',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\ 'is_listed' : 1,
\}
function! s:kind.action_table.branch.func(candidate)"{{{
  let data = a:candidate.action__data
  let branchname = input('branch name: ')
  echo giti#stash#branch({'stash' : data.hash, 'branchname' : branchname})
endfunction"}}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
