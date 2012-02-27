" File:    push.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#push#run(...)"{{{
  let repository = ''
  let refspec = ''

  if exists('a:000[0]')
    let repository = a:000[0]
  endif
  if exists('a:000[1]')
    let refspec = a:000[1]
  endif

  let res = s:run(repository, refspec)

  call s:handle_error(res)

  return res
endfunction"}}}

function! giti#push#expressly()"{{{
  let repository = input("repository: ")
  let refspec    = input("refspec: ")

  let res = s:run(repository, refspec)

  call s:handle_error(res)

  return res
endfunction"}}}

" local functions {{{
function! s:run(repository, refspec)"{{{
  return giti#system_with_confirm(join(['push', a:repository, a:refspec]))
endfunction"}}}

function! s:handle_error(res)"{{{
  if v:shell_error
    echoerr a:res
  else
    echo a:res
  endif
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
