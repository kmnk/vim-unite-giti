" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! giti#branch#list() "{{{
  let result = giti#system('branch')
  if type(result) == 0
    " canceled
    return []
  endif
  return map(
\   split(result, '\n'),
\   's:build_branch_data(v:val)'
\ )
endfunction "}}}

function! giti#branch#list_all() "{{{
  let result = giti#system('branch -a')
  if type(result) == 0
    " canceled
    return []
  endif
  return map(
\   split(result, '\n'),
\   's:build_branch_data(v:val)'
\ )
endfunction "}}}

function! giti#branch#github_list_all() "{{{
  let remotes = filter(giti#remote#github_list(), 'v:val.type == "(fetch)"')
  let remote_branches = filter(giti#branch#list_all(), 'v:val.is_remote && v:val.full_name !~ "->"')

  let github_branches = []
  for branch in remote_branches
    let [remote_name; branch_name_splited] = split(branch.name, '/')
    let branch_name = join(branch_name_splited, '/')
    let matched = filter(copy(remotes), 'v:val.name == "'.remote_name.'"')

    if empty(matched)
      " TODO Change message
      throw 'Error occured:'
    else
      let g:r = remotes
      let g:n = remote_name
      let g:h = matched
      let remote = matched[-1]
      let branch.head_name = join([remote.github.account, branch_name], ':')
      let branch.remote = remote
    endif

    call add(github_branches, branch)
  endfor

  return github_branches
endfunction "}}}

function! giti#branch#current_name() "{{{
  let current_branch = giti#branch#current()
  return has_key(current_branch, 'name') ? current_branch['name'] : 'master'
endfunction "}}}

function! giti#branch#current() "{{{
  let result = giti#system('branch -a')
  if type(result) == 0
    " canceled
    return []
  endif
  let branches = filter(
\   map(
\     split(result, '\n'),
\     's:build_branch_data(v:val)'
\   ),
\   'v:val.is_current'
\ )
  return len(branches) > 0 ? remove(branches, 0) : {}
endfunction "}}}

function! giti#branch#delete(branches) "{{{
  return giti#system_with_specifics({
\   'command' : 'branch -d ' . join(a:branches),
\   'with_confirm' : 1,
\ })
endfunction "}}}

function! giti#branch#delete_force(branches) "{{{
  return giti#system_with_specifics({
\   'command' : 'branch -D ' . join(a:branches),
\   'with_confirm' : 1,
\ })
endfunction "}}}

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
endfunction "}}}

function! giti#branch#create(branch) "{{{
  return giti#checkout#create({'name' : a:branch})
endfunction "}}}

function! giti#branch#switch(branch) "{{{
  return giti#checkout#switch({'name' : a:branch})
endfunction "}}}

" local function {{{
function! s:build_branch_data(line) "{{{
  return {
\   'full_name'  : s:pickup_full_branch_name(a:line),
\   'name'       : s:pickup_branch_name(a:line),
\   'is_current' : s:is_current(a:line),
\   'is_remote'  : s:is_remote(a:line),
\ }
endfunction "}}}

function! s:pickup_full_branch_name(line)
  return substitute(a:line, '^*\?\s*\(.\+\)', '\1', '')
endfunction

function! s:pickup_branch_name(line)
  if match(a:line, '^*\s*\%((no branch)\)') >= 0
    return '(no branch)'
  endif
  return substitute(a:line, '^*\?\s*\%(remotes/\)\?\([^ ]\+\).*', '\1', '')
endfunction

function! s:is_current(line) "{{{
  return match(a:line, '^*\s*.\+$') < 0 ? 0 : 1
endfunction "}}}

function! s:is_remote(line) "{{{
  return match(a:line, '^*\?\s*remotes/') < 0 ? 0 : 1
endfunction "}}}

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
