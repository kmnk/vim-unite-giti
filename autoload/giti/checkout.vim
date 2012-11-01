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

function! giti#checkout#create(param)"{{{
  let name = a:param.name

  call giti#print('create new branch [' . name . ']')

  let start_point = ''
  if exists('a:param.start_point')
    let start_point = a:param.start_point
  else
    let start_point = input('start-point (optional) : ')
  endif

  return giti#system('checkout -b ' . name . ' ' . start_point)
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
