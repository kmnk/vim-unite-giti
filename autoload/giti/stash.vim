" File:    stash.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
let s:pretty_format = "::%gd::%H::%P::%an<%ae>[%ad]::%cn<%ce>[%cd]::%s"
" }}}

function! giti#stash#list()"{{{
  return giti#system('stash list')
endfunction"}}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
