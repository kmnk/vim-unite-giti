" File:    rebase.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#rebase#run(param) "{{{
  return giti#system_with_specifics({
\   'command' : printf('rebase %s %s',
\                 has_key(a:param, 'onto')
\                   ? '--onto ' . a:param.onto
\                   : '',
\                 has_key(a:param, 'upstream')
\                   ? a:param.upstream
\                   : ''
\               ),
\   'with_confirm' : 1,
\ })
endfunction "}}}

function! giti#rebase#interactive(param) "{{{
  return giti#execute(printf('! git rebase -i %s %s',
\   has_key(a:param, 'onto')     ? '--onto ' . a:param.onto : '',
\   has_key(a:param, 'upstream') ? a:param.upstream         : '',
\ ))
endfunction "}}}

function! giti#rebase#continue() "{{{
  return giti#system('rebase --continue')
endfunction "}}}

function! giti#rebase#skip() "{{{
  return giti#system('rebase --skip')
endfunction "}}}

function! giti#rebase#abort() "{{{
  return giti#system('rebase --abort')
endfunction "}}}

" local functionss {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
