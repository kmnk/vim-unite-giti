" File:    revert.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#revert#run(hash_list) "{{{
  return s:run(a:hash_list)
endfunction "}}}

" local functions {{{
function! s:run(hash_list) "{{{
  call s:make_revert_editmsg(a:hash_list)
  call s:edit_revert_editmsg()
endfunction "}}}

function! s:make_revert_editmsg(hash_list) "{{{
  call giti#system_with_specifics({
\   'command'      : printf('revert %s', join(a:hash_list)),
\   'ignore_error' : 1,
\ })
endfunction "}}}

function! s:edit_revert_editmsg() "{{{
  call giti#execute(printf(
\   '%s %sCOMMIT_EDITMSG',
\   giti#edit_command(),
\   giti#dir()
\ ))
  setlocal filetype=gitcommit bufhidden=wipe
  augroup GitiCommit"{{{
    autocmd BufWritePre <buffer> g/^#\|^\s*$/d
    execute printf(
\     'autocmd BufWritePost <buffer> call giti#system("%s") | ' .
\     'autocmd! GitiCommit * <buffer>',
\     'commit --amend -F ' . expand('%')
\   )
  augroup END"}}}
endfunction "}}}
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

