" File:    diff.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#diff#run(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  return s:run({'command' : 'diff', 'files' : files})
endfunction "}}}

function! giti#diff#cached(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  return s:run({'command' : 'diff --cached', 'files' : files})
endfunction "}}}

function! giti#diff#head(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  return s:run({'command' : 'diff HEAD', 'files' : files})
endfunction "}}}

function! giti#diff#specify(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  let command
\   = !exists('a:param.to') ? printf('diff %s', a:param.from)
\   : a:param.to == ''      ? printf('diff %s', a:param.from)
\   :                         printf('diff %s..%s', a:param.from, a:param.to)
  return s:run({'command' : command, 'files' : files})
endfunction "}}}

function! giti#diff#view_git_diff(diff) "{{{
  if !strlen(a:diff)
    call giti#print('no difference')
    return
  endif
  return giti#new_buffer({
\   'method'   : giti#edit_command(),
\   'string'   : a:diff,
\   'filetype' : 'diff',
\   'buftype'  : 'nofile',
\ })
endfunction "}}}

function! giti#diff#view_vim_diff(param) "{{{
  let file = a:param.file
  let from = a:param.from
  let to   = a:param.to

  call giti#new_buffer({
\   'method'  : 'tabnew',
\   'file'    : len(from) > 0 ? '' : file,
\   'string'  : giti#system(printf('cat-file -p %s:%s', from, file)),
\   'buftype' : 'nofile',
\ })

  call giti#diffthis()

  call giti#new_buffer({
\   'method'  : 'vnew',
\   'file'    : len(to) > 0 ? '' : file,
\   'string'  : giti#system(printf('cat-file -p %s:%s', to, file)),
\   'buftype' : 'nofile',
\ })

  call giti#diffthis()

  return 1
endfunction "}}}

" local functions {{{
function! s:run(param) "{{{
  let files = exists('a:param.files') ? a:param.files : []
  return giti#system(a:param.command . ' -- ' . join(files))
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
