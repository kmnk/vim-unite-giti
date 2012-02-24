" File:    reset.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#reset#run(files)"{{{
  return giti#reset#head(a:files)
endfunction"}}}

function! giti#reset#head(files)"{{{
  return giti#system('reset HEAD ' . join(a:files))
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
