" File:    remote.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: 

let s:save_cpo = &cpo
set cpo&vim

function! giti#remote#show()"{{{
  return giti#system('remote show')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
