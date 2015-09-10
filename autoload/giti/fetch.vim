" File:    fetch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: 

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#fetch#run(...) "{{{
  let param = a:0 > 0 ? a:1 : {}

  let repository = exists('param.repository') ? param.repository : ''

  return giti#system(printf('fetch %s', repository))
endfunction "}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
