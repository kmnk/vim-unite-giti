" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#run(arg)"{{{
  return giti#system(a:arg)
endfunction"}}}

function! giti#system(arg)"{{{
  return system('git ' . a:arg)
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
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
