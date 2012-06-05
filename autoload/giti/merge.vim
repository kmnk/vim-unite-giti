" File:    merge.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#merge#run(param)"{{{
  if !exists('a:param.branch_name')
    echoerr 'branch_name required'
    return
  endif

  let branch_name = a:param.branch_name
  return giti#system_with_specifics({
\   'command' : printf('merge %s', branch_name)
\ })
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
