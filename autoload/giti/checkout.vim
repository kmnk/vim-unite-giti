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
  return giti#system('checkout -- ' . join(a:files))
endfunction"}}}

function! giti#checkout#switch(name)"{{{
  return giti#system('checkout ' . a:name)
endfunction"}}}

function! giti#checkout#create(name)"{{{
  echo 'carete new branch [' . a:name . ']'
  let start_point = input('start-point(optional) : ')
  return giti#system('checkout -b ' . a:name . ' ' . start_point)
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
