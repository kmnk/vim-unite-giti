" File:    reset.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#reset#hard(hash)"{{{
  echo giti#system_with_confirm(printf('reset --hard %s', a:hash))
endfunction"}}}

function! giti#reset#head(files)"{{{
  return giti#system('reset HEAD ' . join(a:files))
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
