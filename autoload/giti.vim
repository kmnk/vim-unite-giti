" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#is_git_repository(...)"{{{
  let path = a:0 > 0 ? a:1 : getcwd()
  return finddir('.git', path . ';') != '' ? 1 : 0
endfunction"}}}

function! giti#to_relative_path(absolute_path)"{{{
  return substitute(a:absolute_path, getcwd() . '/\?\(.\+\)', '\1', '')
endfunction"}}}

function! giti#system(command)"{{{
  return giti#system_with_specifics({ 'command' : a:command })
endfunction"}}}

function! giti#system_with_specifics(param)"{{{
  if !giti#is_git_repository()
    echo 'Not a git repository'
    echo 'Specify directory of git repository (and change current directory of this window)'
    echo 'current  : ' . getcwd()
    call giti#execute(printf('lcd %s', input('change to: ', getcwd())))
    return giti#system_with_specifics(a:param)
  endif

  let a:param.command = s:trim(a:param.command)

  if exists('a:param.with_confirm') && a:param.with_confirm
    if !s:is_confirmed(a:param)
      echo 'canceled'
      return
    endif
  endif

  let ret = system('git ' . a:param.command)

  if exists('a:param.ignore_error') && a:param.ignore_error
    return ret
  else
    return s:handle_error(ret, a:param)
  endif
endfunction"}}}

function! giti#dir()"{{{
  if !exists('b:giti_dir')
    let b:giti_dir = giti#system('rev-parse --git-dir')
    if !v:shell_error
      let b:giti_dir = fnamemodify(split(b:giti_dir, '\n')[0], ':p')
    endif
  endif
  return b:giti_dir
endfunction"}}}

function! giti#edit_command()"{{{
  if !exists('g:giti_edit_command')
    let g:giti_edit_command = 'tabnew'
  endif
  return g:giti_edit_command
endfunction"}}}

function! giti#add_ignore(names)"{{{
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
endfunction"}}}

function! giti#execute(command)"{{{
  execute a:command
endfunction"}}}
function! giti#put(string, ...)"{{{
  if a:0 > 0 && a:1
    put!=a:string
  else
    put=a:string
  endif
endfunction"}}}

function! giti#new_buffer(param)"{{{
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
endfunction"}}}

function! giti#diffthis()"{{{
  diffthis
endfunction"}}}

" local functions {{{
function! s:handle_error(res, param)"{{{
  if v:shell_error
    echo 'error occured on executing "git ' . a:param.command . '"'
    echo a:res
    return
  else
    return a:res
  endif
endfunction"}}}

function! s:is_confirmed(param)
  let command = 'git ' . a:param.command
  return input('execute "' . command . '" ? [y/n] : ') == 'y' ? 1 : 0
endfunction

function! s:trim(string)"{{{
  return substitute(a:string, '\(.\+\)\s\+$', '\1', '')
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
