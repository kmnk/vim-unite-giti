" File:    add.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#add#run(files) "{{{
  return giti#system('add ' . join(a:files))
endfunction "}}}

function! giti#add#patch(files) "{{{
  return giti#execute('! git add -p ' . join(a:files))
endfunction "}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
