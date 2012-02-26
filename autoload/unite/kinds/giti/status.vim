" File:    status.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#status#define()"{{{
  return s:kind
endfunction"}}}

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
function! s:kind.action_table.add.func(candidates)"{{{
  return giti#add#run(map(a:candidates, 'v:val.action__path'))
endfunction"}}}

let s:kind.action_table.reset = {
\ 'description' : 'reset selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.reset.func(candidates)"{{{
  return giti#reset#run(map(a:candidates, 'v:val.action__path'))
endfunction"}}}

let s:kind.action_table.commit = {
\ 'description' : 'commit selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.commit.func(candidates)"{{{
  return giti#commit#run(map(a:candidates, 'v:val.action__path'))
endfunction"}}}
let s:kind.alias_table.ci = 'commit'

let s:kind.action_table.amend = {
\ 'description' : 'amend selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.amend.func(candidates)"{{{
  return giti#commit#amend()
endfunction"}}}

let s:kind.action_table.checkout = {
\ 'description' : 'discard unstaged changes of selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.checkout.func(candidates)"{{{
  return giti#checkout#run(map(a:candidates, 'v:val.action__path'))
endfunction"}}}

let s:kind.action_table.diff = {
\ 'description' : 'diff selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.diff.func(candidates)"{{{
  return giti#diff#run(map(a:candidates, 'v:val.action__path'))
endfunction"}}}
let s:kind.alias_table.di = 'diff'

let s:kind.action_table.diff_cached = {
\ 'description' : 'diff --cached selected files',
\ 'is_selectable' : 1,
\}
function! s:kind.action_table.diff_cached.func(candidates)"{{{
  return giti#diff#cached(map(a:candidates, 'v:val.action__path'))
endfunction"}}}
let s:kind.alias_table.dic = 'diff_cached'

let s:kind.action_table.rm = {
\ 'description' : 'rm selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.rm.func(candidates)"{{{
  return giti#rm#run(map(a:candidates, 'v:val.action__path'))
endfunction"}}}

let s:kind.action_table.rm_cached = {
\ 'description' : 'rm --cached selected files',
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 1,
\}
function! s:kind.action_table.rm_cached.func(candidates)"{{{
  return giti#rm#cached(map(a:candidates, 'v:val.action__path'))
endfunction"}}}
let s:kind.alias_table.rmc = 'rm_cached'

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
