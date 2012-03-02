" File:    pull.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#pull#run(...)"{{{
  let [repository, refspec] = s:map_param(a:000)

  return s:run('pull', repository, refspec)
endfunction"}}}

function! giti#pull#squash(...)"{{{
  let [repository, refspec] = s:map_param(a:000)

  return s:run('pull --squash', repository, refspec)
endfunction"}}}

function! giti#pull#expressly()"{{{
  let repository = input("repository: ")
  let refspec    = input("refspec: ")

  return s:run('pull', repository, refspec)
endfunction"}}}

" local functions {{{

function! s:map_param(params)"{{{
  let repository = ''
  let refspec = ''

  if exists('a:params[0]')
    let repository = a:params[0]
  endif
  if exists('a:params[1]')
    let refspec = a:params[1]
  endif

  return [repository, refspec]
endfunction"}}}

function! s:run(command, repository, refspec)"{{{
  return giti#system_with_confirm(
\   join(filter([a:command, a:repository, a:refspec], 'v:val!=""'))
\ )
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

