" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#define()"{{{
  call s:add_rm_action_on_file_kind()
  return map(
\   map(s:get_commands(), 's:to_define_func(v:val)'),
\   'call(v:val, [])'
\ )
endfunction"}}}

" local functions {{{
function! s:get_commands()"{{{
  return map(
\   split(
\     globpath(&runtimepath, 'autoload/unite/kinds/giti/*.vim'),
\     '\n'
\   ),
\   'fnamemodify(v:val, ":t:r")'
\ )
endfunction"}}}

function! s:to_define_func(command)"{{{
  return 'unite#kinds#giti#' . a:command . '#define'
endfunction}}}

function! s:add_rm_action_on_file_kind()"{{{
  let git_rm = {
\   'description' : 'git rm selected files',
\   'is_selectable' : 1,
\ }
  function! git_rm.func(candidates)
    return giti#rm#run(map(a:candidates, 'v:val.action__path'))
  endfunction
  call unite#custom_action('file', 'git_rm', git_rm)
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
