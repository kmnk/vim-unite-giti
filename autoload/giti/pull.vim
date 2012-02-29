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

  let res = s:run('pull', repository, refspec)

  call s:handle_error(res)
  return res
endfunction"}}}

function! giti#pull#squash(...)"{{{
  let [repository, refspec] = s:map_param(a:000)

  let res = s:run('pull --squash', repository, refspec)

  call s:handle_error(res)
  return res
endfunction"}}}

function! giti#pull#expressly()"{{{
  let repository = input("repository: ")
  let refspec    = input("refspec: ")

  let res = s:run('pull', repository, refspec)

  call s:handle_error(res)
  return res
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

function! s:handle_error(res)"{{{
  if v:shell_error
    echoerr a:res
  endif
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

