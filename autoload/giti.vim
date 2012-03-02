" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#run(arg, option)"{{{
  return giti#system(a:arg, option)
endfunction"}}}

function! giti#system(arg, option)"{{{
  if exists('a:option.ignore_error') && a:option.ignore_error
    return system('git ' . a:arg)
  else
    return s:handle_error(system('git ' . a:arg))
  endif
endfunction"}}}

function! giti#system_with_confirm(arg)"{{{
  let command = 'git ' . a:arg
  if input('execute "' . command . '" ? [y/n] : ') == 'y'
    return system(command)
  endif
    echo 'canceled'
  return
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

" local functions {{{
function! s:handle_error(res)"{{{
  if v:shell_error
    echoerr a:res
  else
  return a:res
endfunction"}}}

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
