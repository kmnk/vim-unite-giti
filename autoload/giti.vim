" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:V = vital#of('giti')
let s:G = s:V.import('VCS.Git')
let s:GCore = s:V.import('VCS.Git.Core')
" }}}

" Summary: get vcs-git dictionary
" Returns: vcs-git data dictionary
function! giti#git() "{{{
  return s:G.find(expand('%'))
endfunction "}}}

" Summary: is current directory included git repository ?
" Param: target path
" Returns: if included, returns true else returns false
function! giti#is_git_repository(...) "{{{
  let path = a:0 > 0 ? a:1 : getcwd()
  return has_key(s:G.find(path), 'repository')
endfunction "}}}

" Summary: resolve relative path from repository root directory
" Param: path to resolve
" Returns: relative path from repository root directory
function! giti#to_relative_path(absolute_path) "{{{
  return s:GCore.get_relative_path(s:GCore.find_worktree(a:absolute_path), a:absolute_path)
endfunction "}}}

function! giti#system(command) "{{{
  return giti#system_with_specifics({ 'command' : a:command })
endfunction "}}}

function! giti#system_with_specifics(param) "{{{
  if !giti#is_git_repository()
    call giti#print('Not a git repository')
    call giti#print('Specify directory of git repository (and change current directory of this window)')
    call giti#print('current  : ' . getcwd())
    let new_directory = giti#input('change to: ', getcwd())
    if new_directory == ''
      " Note 'redraw' is required to prevent 'Press ENTER or type...' message
      redraw | call giti#print('cacneled')
      return
    endif
    call giti#execute(printf('lcd %s', new_directory))
    return giti#system_with_specifics(a:param)
  endif

  let a:param.command = s:normalize_command(a:param.command)

  if exists('a:param.with_confirm') && a:param.with_confirm
    if !giti#is_confirmed(a:param.command)
      call giti#print('canceled')
      return
    endif
  endif

  let ret = system(g:giti_git_command . ' ' . a:param.command)

  if exists('a:param.ignore_error') && a:param.ignore_error
    return ret
  else
    return s:handle_shell_error(ret, a:param)
  endif
endfunction "}}}

function! giti#dir() "{{{
  if !exists('b:giti_dir')
    let b:giti_dir = giti#system('rev-parse --git-dir')
    if !giti#has_shell_error()
      let b:giti_dir = fnamemodify(split(b:giti_dir, '\n')[0], ':p')
    endif
  endif
  return b:giti_dir
endfunction "}}}

function! giti#edit_command() "{{{
  if !exists('g:giti_edit_command')
    let g:giti_edit_command = 'tabnew'
  endif
  return g:giti_edit_command
endfunction "}}}

function! giti#add_ignore(names) "{{{
  if len(a:names) <= 0
    return
  endif
  let lines = join(a:names, "\n")
  call giti#execute(printf(
\   '%s %s/.gitignore',
\   giti#edit_command(),
\   fnamemodify(giti#dir(), ':h:h')
\ ))
  keepjumps normal G
  call giti#put(join(a:names, "\n"))
  keepjumps normal g;
endfunction "}}}

function! giti#execute(command) "{{{
  execute a:command
endfunction "}}}
function! giti#put(string, ...) "{{{
  if a:0 > 0 && a:1
    put!=a:string
  else
    put=a:string
  endif
endfunction "}}}

function! giti#new_buffer(param) "{{{
  call giti#execute(
\   has_key(a:param, 'method') ? a:param.method : giti#edit_command()
\ )

  if has_key(a:param, 'file') && len(a:param.file) > 0
    call giti#execute(printf('read %s', a:param.file))
  elseif has_key(a:param, 'string')
    call giti#put(a:param.string)
  endif

  keepjumps normal gg
  call giti#execute('delete')

  if has_key(a:param, 'filetype')
    call giti#execute(printf('setlocal filetype=%s', a:param.filetype))
  endif

  if has_key(a:param, 'buftype')
    call giti#execute(printf('setlocal buftype=%s', a:param.buftype))
  endif

  return 1
endfunction "}}}

function! giti#diffthis() "{{{
  diffthis
endfunction "}}}

function! giti#print(string) "{{{
  echo a:string
endfunction "}}}

function! giti#has_shell_error() "{{{
  return v:shell_error ? 1 : 0
endfunction "}}}

function! giti#input(prompt, ...) "{{{
  if a:0 <= 0
    return input(a:prompt)
  endif
  if a:0 == 1
    return input(a:prompt, a:1)
  endif
  if a:0 == 2
    return input(a:prompt, a:1, a:2)
  endif
endfunction "}}}

" Summary: confirm before executing command, and return answer
" Param: a:command to execute
" Returns: if is confirmed then return true else return false
function! giti#is_confirmed(command) "{{{
  let command = g:giti_git_command . ' ' . a:command
  return giti#input('execute "' . command . '" ? [y/n] : ') == 'y' ? 1 : 0
endfunction "}}}

" local functions {{{
function! s:handle_shell_error(res, param) "{{{
  if giti#has_shell_error()
    call giti#print('error occured on executing "git ' . a:param.command . '"')
    call giti#print(a:res)
    return
  else
    return a:res
  endif
endfunction "}}}

" Summary: normalize command for exexuting
" Param: a:string to normalize command
" Returns: normalized string
function! s:normalize_command(string) "{{{
  let result = a:string
  let result = substitute(result, '\s\+$', '', '')
  let result = substitute(result, '\s\{2,}', ' ', '')
  return result
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
