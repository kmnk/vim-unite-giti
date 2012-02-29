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
function! s:kind.action_table.view.func(candidate)"{{{
  let data = a:candidate.action__data
  echo        'Hash:       ' . data.hash
  echo        'ParentHash: ' . data.parent_hash
  echo printf('Author:     %s <%s> - %s',
\       data.author.name, data.author.mail, data.author.date)
  echo printf('Committer:  %s <%s> - %s',
\       data.committer.name, data.committer.mail, data.committer.date)
  echo        'Comment:    ' . data.comment
endfunction"}}}

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
