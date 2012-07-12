" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! giti#branch#list()"{{{
  return map(
\   split(giti#system('branch'), '\n'),
\   's:build_branch_data(v:val)'
\ )
endfunction"}}}

function! giti#branch#list_all()"{{{
  return map(
\   split(giti#system('branch -a'), '\n'),
\   's:build_branch_data(v:val)'
\ )
endfunction"}}}

function! giti#branch#current_name()"{{{
  return giti#branch#current()['name']
endfunction"}}}

function! giti#branch#current()"{{{
  return remove(filter(
\   map(
\     split(giti#system('branch -a'), '\n'),
\     's:build_branch_data(v:val)'
\   ),
\   'v:val.is_current'
\ ), 0)
endfunction"}}}

function! giti#branch#delete(branches)"{{{
  return giti#system_with_specifics({
\   'command' : 'branch -d ' . join(a:branches),
\   'with_confirm' : 1,
\ })
endfunction"}}}

function! giti#branch#delete_force(branches)"{{{
  return giti#system_with_specifics({
\   'command' : 'branch -D ' . join(a:branches),
\   'with_confirm' : 1,
\ })
endfunction"}}}

function! giti#branch#delete_remote(params) abort "{{{
  if len(a:params) <= 0
    return
  endif

  let results = []
  for param in a:params
    if !has_key(param, 'branch') || len(param.branch) <= 0
      throw 'branch required'
    endif
    call add(results, giti#push#delete_remote_branch(param))
  endfor

  return results
endfunction"}}}

function! giti#branch#create(branch)"{{{
  return giti#checkout#create({'name' : a:branch})
endfunction"}}}

function! giti#branch#switch(branch)"{{{
  return giti#checkout#switch(a:branch)
endfunction"}}}

" local function {{{
function! s:build_branch_data(line)"{{{
  return {
\   'full_name'  : s:pickup_full_branch_name(a:line),
\   'name'       : s:pickup_branch_name(a:line),
\   'is_current' : s:is_current(a:line),
\   'is_remote'  : s:is_remote(a:line),
\ }
endfunction"}}}

function! s:pickup_full_branch_name(line)
  return substitute(a:line, '^*\?\s*\(.\+\)', '\1', '')
endfunction

function! s:pickup_branch_name(line)
  return substitute(a:line, '^*\?\s*\%(remotes/\)\?\([^ ]\+\).*', '\1', '')
endfunction

function! s:is_current(line)"{{{
  return match(a:line, '^*\s*.\+$') < 0 ? 0 : 1
endfunction"}}}

function! s:is_remote(line)"{{{
  return match(a:line, '^*\?\s*remotes/') < 0 ? 0 : 1
endfunction"}}}

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
