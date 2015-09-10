" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#define() "{{{
  call s:add_rm_action_on_file_kind()
  call s:add_mv_action_on_file_kind()
  let kinds = []
  for command in s:get_commands()
    let kind = call(s:to_define_func(command), [])
    if type({}) == type(kind)
      call add(kinds, kind)
    elseif type([]) == type(kind)
      call extend(kinds, kind)
    endif
    unlet kind
  endfor
  return kinds
endfunction "}}}

" local functions {{{
function! s:get_commands() "{{{
  return map(
\   split(
\     globpath(&runtimepath, 'autoload/unite/kinds/giti/*.vim'),
\     '\n'
\   ),
\   'fnamemodify(v:val, ":t:r")'
\ )
endfunction "}}}

function! s:to_define_func(command) "{{{
  return 'unite#kinds#giti#' . a:command . '#define'
endfunction}}}

function! s:add_rm_action_on_file_kind() "{{{
  let git_rm = {
\   'description'   : 'git rm selected files',
\   'is_selectable' : 1,
\ }
  function! git_rm.func(candidates)
    return giti#rm#run({'files' : map(a:candidates, 'v:val.action__path')})
  endfunction
  call unite#custom_action('file', 'git_rm', git_rm)
endfunction "}}}

function! s:add_mv_action_on_file_kind() "{{{
  let git_mv = {
\   'description'   : 'git mv selected file',
\   'is_selectable' : 0,
\ }
  function! git_mv.func(candidate)
    let source = a:candidate.action__path

    call giti#print("git mv")
    call giti#print(printf('from "%s"', source))

    let destination = giti#input('to: ', source)
    let is_directory = isdirectory(destination)

    return giti#mv#run({
\     'source'                : source,
\     'destination'           : is_directory ? '' : destination,
\     'destination_directory' : is_directory ? destination : '',
\   })
  endfunction
  call unite#custom_action('file', 'git_mv', git_mv)
endfunction "}}}
" }}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#kinds#giti#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
