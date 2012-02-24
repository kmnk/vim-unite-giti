" File:    checkout.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:edit_command = 'tabnew'
" }}}

function! giti#checkout#run(files)"{{{
  return giti#system('checkout ' . join(a:files))
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
