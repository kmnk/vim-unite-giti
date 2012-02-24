" File:    branch.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! giti#branch#run()"{{{
  call unit#giti#branch#list()
endfunction"}}}

function! giti#branch#list()"{{{
  return map(
\   split(giti#system('branch'), '\n'),
\   's:build_branch_data(v:val)'
\ )
endfunction"}}}

function! giti#branch#delete(branch)"{{{
endfunction"}}}

function! giti#branch#add(branch)"{{{
endfunction"}}}

function! giti#branch#switch(branch)"{{{
  call giti#checkout#run(branch)
endfunction"}}}

" local function {{{
function! s:build_branch_data(line)"{{{
  return {
\   'name' : substitute(a:line, '^\*\?\s\(.\+\)', '\1', ''),
\   'is_current' : s:is_current(a:line),
\ }
endfunction"}}}

function! s:is_current(line)"{{{
  return match(a:line, '^\*\s\*.\+$') ? 1 : 0
endfunction"}}}



" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
