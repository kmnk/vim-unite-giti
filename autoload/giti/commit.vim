" File:    commit.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#commit#run(files) "{{{
  return s:run('commit', a:files)
endfunction "}}}

function! giti#commit#dry_run(files) "{{{
  return s:run('commit --dry-run', a:files)
endfunction "}}}

function! giti#commit#amend(files) "{{{
  return s:run('commit --amend', a:files)
endfunction "}}}

" local functions {{{
function! s:run(command, files) "{{{
  call s:make_commit_editmsg(a:command, a:files)
  call s:edit_commit_editmsg(a:command, a:files)
endfunction "}}}

function! s:make_commit_editmsg(command, files) "{{{
  call giti#system_with_specifics({
\   'command'      : a:command . ' -- ' . join(a:files),
\   'ignore_error' : 1,
\ })
endfunction "}}}

function! s:edit_commit_editmsg(command, files) "{{{
  call giti#execute(printf('%s %sCOMMIT_EDITMSG', giti#edit_command(), giti#dir()))
  setlocal filetype=gitcommit bufhidden=wipe
  augroup GitiCommit"{{{
    autocmd BufWritePre <buffer> g/^#\|^\s*$/d
    execute printf(
\     'autocmd BufWritePost <buffer> call giti#system("%s") | ' .
\     'autocmd! GitiCommit * <buffer>',
\     a:command . ' -F ' . expand('%') . ' -- ' . join(a:files)
\   )
  augroup END"}}}
endfunction "}}}

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
