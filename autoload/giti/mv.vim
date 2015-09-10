" File:    mv.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#mv#run(param) abort"{{{
  return s:run('', a:param)
endfunction "}}}

function! giti#mv#force(param) "{{{
  return s:run('-f', a:param)
endfunction "}}}

function! giti#mv#verbose(param) "{{{
  return s:run('-v', a:param)
endfunction "}}}

" local functions {{{
function! s:run(option, param) abort"{{{
  if !has_key(a:param, 'source') || len(a:param.source) <= 0
    throw 'source is required'
  endif

  if (!has_key(a:param, 'destination') || len(a:param.destination) <= 0)
\ && (!has_key(a:param, 'destination_directory') || len(a:param.destination_directory) <= 0)
    throw 'destination is required'
  endif

  let source = a:param.source
  let destination
\   = has_key(a:param, 'destination') ? a:param.destination
\                                     : ''
  let destination_directory
\   = has_key(a:param, 'destination_directory') ? a:param.destination_directory
\                                               : ''

  let option = len(a:option) <= 0 ? ''
\                                 : ' ' . a:option

  return giti#system('' != destination
\   ? printf('mv%s %s %s',     option, source, destination)
\   : printf('mv%s %s ... %s', option, source, destination_directory)
\ )
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
