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

function! giti#system(command)"{{{
  return giti#system_with_specifics({ 'command' : a:command })
endfunction"}}}

function! giti#system_with_specifics(param)"{{{
  if !giti#is_git_repository()
    throw 'Not a git repository'
    return
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
function! giti#put(string)"{{{
  put=a:string
endfunction"}}}

" local functions {{{
function! s:handle_error(res, param)"{{{
  if v:shell_error
    throw 'System error: git ' . a:param.command . "\n" . a:res
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
  return substitute(a:string, '\([^ ]\+\)\s\+$', '\1', '')
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
